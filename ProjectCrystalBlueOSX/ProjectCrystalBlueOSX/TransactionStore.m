//
//  TransactionStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "TransactionStore.h"
#import "Transaction.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"TransactionStore"

@interface TransactionStore()
{
    FMDatabaseQueue *localQueue;
}

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
        
        // Setup table, if fail, try again after 2 seconds
        if (![self setupTable]) {
            sleep(2);
            [self setupTable];
        }
    }
    return self;
}

- (NSArray *)getAllTransactions
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [TransactionConstants tableName]];
    NSMutableArray *transactions = [[NSMutableArray alloc] init];
    
    // Get commit history from table
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if ([localDatabase hadError]) {
            DDLogCError(@"%@: Failed to get unsynced transactions from local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
            [results close];
            return;
        }
        
        // Add all the results to the commitHistory array
        while ([results next]) {
            NSNumber *timestamp = [NSNumber numberWithDouble:[[[results resultDictionary] objectForKey:@"timestamp"] doubleValue]];
            [transactions addObject:[[Transaction alloc] initWithTimestamp:timestamp
                                                AndWithAttributeDictionary:[results resultDictionary]]];
        }
        [results close];
    }];
    
    return transactions;
}

- (BOOL)commitTransaction:(Transaction *)transaction
{
    // Make sure sql command is a valid command to commit
    NSString *sqlCommand = [[transaction attributes] objectForKey:@"sqlCommandType"];
    if (![sqlCommand isEqualToString:@"PUT"] || ![sqlCommand isEqualToString:@"DELETE"] || ![sqlCommand isEqualToString:@"UPDATE"]) {
        DDLogCError(@"%@: Not a valid sql command to commit the transaction.", CLASS_NAME);
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
                     [TransactionConstants tableName], [TransactionConstants tableColumns], [TransactionConstants tableValueKeys]];
    
    __block BOOL commitSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        commitSuccess = [localDatabase executeUpdate:sql withParameterDictionary:[transaction attributes]];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to commit transaction to local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
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
            DDLogCError(@"%@: Failed to clear local transactions. Error: %@", CLASS_NAME, [localDatabase lastError]);
    }];
    
    return clearSuccess;
}

- (BOOL)setupTable
{
    __block BOOL setupSuccess = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        // Create transaction table
        setupSuccess = [localDatabase executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",
                                                      [TransactionConstants tableName], [TransactionConstants tableSchema]]];
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to create the transaction table. Error: %@", CLASS_NAME, [localDatabase lastError]);
    }];
    
    return setupSuccess;
}

@end