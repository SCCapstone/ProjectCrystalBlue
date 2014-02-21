//
//  TransactionStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "TransactionStore.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface TransactionStore()
{
    FMDatabaseQueue *localQueue;
}

- (Transaction *)optimizeTransaction:(Transaction *)newTransaction;
- (BOOL)updateTimeOfSync;
- (BOOL)setupTable;

@end

@implementation TransactionStore

- (id)initInLocalDirectory:(NSString *)directory
          WithDatabaseName:(NSString *)databaseName
{
    self = [super init];
    if (self) {
        // Setup local directory
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *localDirectory = [documentsDirectory stringByAppendingPathComponent:directory];
        
        BOOL directoryExists;
        [[NSFileManager defaultManager] fileExistsAtPath:localDirectory isDirectory:&directoryExists];
        if (!directoryExists) {
            [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        
        localQueue = [FMDatabaseQueue databaseQueueWithPath:[localDirectory stringByAppendingPathComponent:databaseName]];
        
        // Setup table
        if (![self setupTable]) {
            return nil;
        }
    }
    return self;
}

- (NSArray *)getAllTransactions
{
    // Don't include the lastSyncUpdate
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY ROWID ASC LIMIT -1 OFFSET 1", [TransactionConstants tableName]];
    
    // Get commit history from table
    __block NSMutableArray *transactions;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if ([localDatabase hadError]) {
            DDLogCError(@"%@: Failed to get unsynced transactions from local database. Error: %@", NSStringFromClass(self.class), [localDatabase lastError]);
            [results close];
            return;
        }
        
        // Add all the results to the commitHistory array
        transactions = [[NSMutableArray alloc] init];
        while ([results next]) {
            NSNumber *timestamp = [NSNumber numberWithDouble:[[[results resultDictionary] objectForKey:TRN_TIMESTAMP] doubleValue]];
            [transactions addObject:[[Transaction alloc] initWithTimestamp:timestamp
                                                AndWithAttributeDictionary:[results resultDictionary]]];
        }
        [results close];
    }];
    
    return transactions;
}

- (Transaction *)getTransactionWithLibraryObjectKey:(NSString *)key
{
    // Don't include the lastSyncUpdate
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", [TransactionConstants tableName], TRN_LIBRARY_OBJECT_KEY, key];
    
    __block NSDictionary *resultDictionary = nil;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to get transaction from local database. Error: %@", NSStringFromClass(self.class), [localDatabase lastError]);
        
        // Have the transaction's attributes
        else if ([results next])
            resultDictionary = [results resultDictionary];
        [results close];
    }];
    
    if (!resultDictionary)
        return nil;
    
    NSNumber *timestamp = [NSNumber numberWithDouble:[[resultDictionary objectForKey:TRN_TIMESTAMP] doubleValue]];
    return [[Transaction alloc] initWithTimestamp:timestamp AndWithAttributeDictionary:resultDictionary];
}

- (BOOL)commitTransaction:(Transaction *)transaction
{
    // Make sure sql command is a valid command to commit
    NSString *sqlCommand = [[transaction attributes] objectForKey:TRN_SQL_COMMAND_TYPE];
    if (!([sqlCommand isEqualToString:@"PUT"] || [sqlCommand isEqualToString:@"DELETE"] || [sqlCommand isEqualToString:@"UPDATE"])) {
        DDLogCError(@"%@: Not a valid sql command to commit the transaction.", NSStringFromClass(self.class));
        return NO;
    }
    
    // Only keep latest change to a single library object
    Transaction *optimizedTransaction = [self optimizeTransaction:transaction];
    if (!optimizedTransaction)
        return YES;
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
                     [TransactionConstants tableName], [TransactionConstants tableColumns], [TransactionConstants tableValueKeys]];
    
    __block BOOL commitSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        commitSuccess = [localDatabase executeUpdate:sql withParameterDictionary:[optimizedTransaction attributes]];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to commit transaction to local database. Error: %@", NSStringFromClass(self.class), [localDatabase lastError]);
    }];
    
    return commitSuccess;
}

- (BOOL)clearLocalTransactions
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [TransactionConstants tableName]];
    
    __block BOOL clearSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        clearSuccess = [localDatabase executeUpdate:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to clear local transactions. Error: %@", NSStringFromClass(self.class), [localDatabase lastError]);
    }];
    
    // Add current time to top of transaction table as last sync time
    [self updateTimeOfSync];
    
    return clearSuccess;
}

- (NSTimeInterval)timeOfLastSync
{
    NSString *sql = [NSString stringWithFormat:@"SELECT timestamp FROM %@ ORDER BY ROWID ASC LIMIT 1", [TransactionConstants tableName]];
    
    // Get first row of transactions table which holds last sync time
    __block NSTimeInterval syncTime;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if ([localDatabase hadError]) {
            DDLogCError(@"%@: Failed to get last sync time from database. Error: %@", NSStringFromClass(self.class), [localDatabase lastError]);
            [results close];
            return;
        }
        
        [results next];
        syncTime = [[[results resultDictionary] objectForKey:TRN_TIMESTAMP] doubleValue];
        [results close];
    }];
    
    return syncTime;
}

- (NSArray *)resolveConflicts:(NSArray *)transactions
{
    NSMutableArray *remoteTransactionsNeeded = [[NSMutableArray alloc] init];
    
    for (Transaction *transaction in transactions) {
        Transaction *conflictingTransaction = [self getTransactionWithLibraryObjectKey:[transaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
        if (!conflictingTransaction)
            continue;
        
        // Remote is more recent than local - need to make remote call
        if ([conflictingTransaction.timestamp doubleValue] < [transaction.timestamp doubleValue]) {
            [remoteTransactionsNeeded addObject:transaction];
        }
    }
    
    return remoteTransactionsNeeded;
}

- (Transaction *)optimizeTransaction:(Transaction *)newTransaction
{
    Transaction *existingTransaction = [self getTransactionWithLibraryObjectKey:[newTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
    // No other transactions to optimize with
    if (!existingTransaction)
        return newTransaction;
    
    NSString *newCommandType = [newTransaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE];
    NSString *existingCommandType = [existingTransaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE];
    
    // Delete all existing transactions
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@'", [TransactionConstants tableName], TRN_LIBRARY_OBJECT_KEY, [newTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];;
    __block BOOL deleteSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        deleteSuccess = [localDatabase executeUpdate:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to optimize transaction. Error: %@", NSStringFromClass(self.class), [localDatabase lastError]);
    }];
    
    if (!deleteSuccess)
        [NSException raise:@"Failed to optimize transaction." format:@"Optimiazation failed. Raising this exception is a temporary solution."];
    
    
    // No optimizations possible with PUT
    if ([newCommandType isEqualToString:@"PUT"])
        return newTransaction;
    
    // Optimizations for UPDATE
    else if ([newCommandType isEqualToString:@"UPDATE"]) {
        // Keep the PUT
        if ([existingCommandType isEqualToString:@"PUT"])
            return existingTransaction;
        
        // Keep the newer UPDATE
        else if ([existingCommandType isEqualToString:@"UPDATE"])
            return newTransaction;
    }
    
    // Optimizations for DELETE
    else if ([newCommandType isEqualToString:@"DELETE"]) {
        // Keep neither as it was put and then deleted
        if ([existingCommandType isEqualToString:@"PUT"])
            return nil;
        
        // Remove the UPDATE as it is going to be deleted
        else if ([existingCommandType isEqualToString:@"UPDATE"])
            return newTransaction;
    }
    
    return nil;
}

- (BOOL)updateTimeOfSync
{
    // Create a new transaction object with current time and everything else nil
    Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:@"" AndWithTableName:@"" AndWithSqlCommandType:@""];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
                     [TransactionConstants tableName], [TransactionConstants tableColumns], [TransactionConstants tableValueKeys]];
    
    __block BOOL updateSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        updateSuccess = [localDatabase executeUpdate:sql withParameterDictionary:[transaction attributes]];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to update time of sync to local database. Error: %@", NSStringFromClass(self.class), [localDatabase lastError]);
    }];
    
    return updateSuccess;
}

- (BOOL)setupTable
{
    __block BOOL setupSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        // Create transaction table
        setupSuccess = [localDatabase executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",
                                                      [TransactionConstants tableName], [TransactionConstants tableSchema]]];
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to create the transaction table. Error: %@", NSStringFromClass(self.class), [localDatabase lastError]);
    }];
    
    [self updateTimeOfSync];
    
    return setupSuccess;
}

@end