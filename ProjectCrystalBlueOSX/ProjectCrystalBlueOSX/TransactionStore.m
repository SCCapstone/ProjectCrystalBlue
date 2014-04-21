//
//  TransactionStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "TransactionStore.h"
#import "ConflictResolution.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FileSystemUtils.h"
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

/*  This method will guarantee that only a single Transaction will reference a LibraryObject in the
 *  Transaction table.  Reduces overhead and simplifies network calls to the remote database.
 */
- (Transaction *)optimizeTransaction:(Transaction *)newTransaction;

/*  Inserts the specified time into the Transaction table.  
 *
 *  This should only be called if the table is empty! (after syncing or on table setup)
 */
- (BOOL)updateTimeOfSync:(NSNumber *)syncTime;

/*  Creates the sqlite Transaction table if it does not already exist.
 */
- (void)setupTable;

@end

@implementation TransactionStore

- (id)initInLocalDirectory:(NSString *)directory
          WithDatabaseName:(NSString *)databaseName
{
    self = [super init];
    if (self) {
        // Setup local directory
        NSString *localDirectory = directory;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        
        localQueue = [FMDatabaseQueue databaseQueueWithPath:[localDirectory stringByAppendingPathComponent:databaseName]];
        
        // Setup table
        [self setupTable];
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
        
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to get unsynced transactions from local database. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [results close];
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to get all unsynced transactions." userInfo:nil] raise];
        }
        
        // Add all the results to the commitHistory array
        transactions = [[NSMutableArray alloc] init];
        while (results.next) {
            NSNumber *timestamp = [NSNumber numberWithDouble:[[results.resultDictionary objectForKey:TRN_TIMESTAMP] doubleValue]];
            [transactions addObject:[[Transaction alloc] initWithTimestamp:timestamp
                                                AndWithAttributeDictionary:results.resultDictionary]];
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
        
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to get transaction from local database. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to get transaction with library object key." userInfo:nil] raise];
        }
        
        // Have the transaction's attributes
        else if (results.next)
            resultDictionary = results.resultDictionary;
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
    NSString *sqlCommand = [transaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE];
    if (!([sqlCommand isEqualToString:@"PUT"] || [sqlCommand isEqualToString:@"DELETE"] || [sqlCommand isEqualToString:@"UPDATE"])) {
        DDLogCError(@"%@: Not a valid sql command to commit the transaction.", NSStringFromClass(self.class));
        return NO;
    }
    
    // Only keep latest change to a single library object
    Transaction *optimizedTransaction = [self optimizeTransaction:transaction];
    
    // PUT + DELETE -> no commit
    if (!optimizedTransaction)
        return YES;
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
                     [TransactionConstants tableName], [TransactionConstants tableColumns], [TransactionConstants tableValueKeys]];
    
    __block BOOL commitSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        commitSuccess = [localDatabase executeUpdate:sql withParameterDictionary:optimizedTransaction.attributes];
        
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to commit transaction to local database. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to add transaction to table." userInfo:nil] raise];
        }
    }];
    
    return commitSuccess;
}

- (BOOL)clearLocalTransactions
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [TransactionConstants tableName]];
    
    __block BOOL clearSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        clearSuccess = [localDatabase executeUpdate:sql];
        
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to clear local transactions. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to clear the transaction table." userInfo:nil] raise];
        }
    }];
    
    // Add current time to top of transaction table as last sync time
    [self updateTimeOfSync:[NSNumber numberWithDouble:[[[NSDate alloc] init] timeIntervalSince1970]]];
    
    return clearSuccess;
}

- (BOOL)deleteLocalTransactionWithLibraryObjectKey:(NSString *)key
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@'", [TransactionConstants tableName], TRN_LIBRARY_OBJECT_KEY, key];
    
    __block BOOL deleteSuccess;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        deleteSuccess = [localDatabase executeUpdate:sql];
        
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to delete the local transaction with library key. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to delete the local transaction with library key." userInfo:nil] raise];
        }
    }];
    
    return deleteSuccess;
}

- (NSTimeInterval)timeOfLastSync
{
    NSString *sql = [NSString stringWithFormat:@"SELECT timestamp FROM %@ ORDER BY ROWID ASC LIMIT 1", [TransactionConstants tableName]];
    
    // Get first row of transactions table which holds last sync time
    __block NSTimeInterval syncTime = 0;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to get last sync time from database. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [results close];
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to get last time of sync." userInfo:nil] raise];
        }
        
        if (results.next)
            syncTime = [[results.resultDictionary objectForKey:TRN_TIMESTAMP] doubleValue];
        [results close];
    }];
    
    return syncTime;
}

- (NSArray *)resolveConflicts:(NSArray *)remoteTransactions
{
    NSMutableArray *resolvedConflicts = [[NSMutableArray alloc] init];
    
    for (Transaction *remoteTransaction in remoteTransactions) {
        Transaction *localTransaction = [self getTransactionWithLibraryObjectKey:[remoteTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
        
        // No conflict, remote is more recent
        if (!localTransaction)
            [resolvedConflicts addObject:[[ConflictResolution alloc] initWithTransaction:remoteTransaction
                                                                  AndIfLocalIsMoreRecent:false]];
        // Conflict exists
        else {
            // Prevent duplicate uploads
            [self deleteLocalTransactionWithLibraryObjectKey:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
            
            // Conflict exists, remote is more recent
            if ([localTransaction.timestamp doubleValue] < [remoteTransaction.timestamp doubleValue]) 
                [resolvedConflicts addObject:[[ConflictResolution alloc] initWithTransaction:remoteTransaction
                                                                      AndIfLocalIsMoreRecent:false]];
            // Conflict exists, local is more recent
            else
                [resolvedConflicts addObject:[[ConflictResolution alloc] initWithTransaction:localTransaction
                                                                      AndIfLocalIsMoreRecent:true]];
        }
    }
    
    return resolvedConflicts;
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
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@'", [TransactionConstants tableName], TRN_LIBRARY_OBJECT_KEY, [newTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
    __block BOOL deleteSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        deleteSuccess = [localDatabase executeUpdate:sql];
        
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to optimize the transaction. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to optimize the transaction." userInfo:nil] raise];
        }
    }];
    
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

- (BOOL)updateTimeOfSync:(NSNumber *)syncTime
{
    // Create a new transaction object with current time and everything else nil
    Transaction *transaction = [[Transaction alloc] initWithTimestamp:syncTime
                                           AndWithAttributeDictionary:[[NSDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                                                                    forKeys:[TransactionConstants attributeNames]]];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
                     [TransactionConstants tableName], [TransactionConstants tableColumns], [TransactionConstants tableValueKeys]];
    
    __block BOOL updateSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        updateSuccess = [localDatabase executeUpdate:sql withParameterDictionary:transaction.attributes];
        
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to update time of sync to local database. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to update time of sync." userInfo:nil] raise];
        }
    }];
    
    return updateSuccess;
}

- (void)setupTable
{
    __block NSInteger count;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        // Create transaction table
        [localDatabase executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)", [TransactionConstants tableName], [TransactionConstants tableSchema]]];
        if (localDatabase.hadError) {
            DDLogCError(@"%@: Failed to create the transaction table. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed create the transaction table." userInfo:nil] raise];
        }
        
        // Check if this is the initial setup
        FMResultSet *results = [localDatabase executeQuery:[NSString stringWithFormat:@"SELECT count(*) FROM %@", [TransactionConstants tableName]]];
        
        if (localDatabase.hadError){
            DDLogCError(@"%@: Failed to get count of transaction table. Error: %@", NSStringFromClass(self.class), localDatabase.lastError);
            [[NSException exceptionWithName:@"SQLiteException" reason:@"SQLite failed to get count of transaction table." userInfo:nil] raise];
        }
        
        // Get the count
        else if (results.next)
            count = [[results.resultDictionary objectForKey:@"count(*)"] integerValue];
        [results close];
    }];
    
    // Add initial time to database
    if (count == 0)
        [self updateTimeOfSync:[NSNumber numberWithInt:0]];
}

@end