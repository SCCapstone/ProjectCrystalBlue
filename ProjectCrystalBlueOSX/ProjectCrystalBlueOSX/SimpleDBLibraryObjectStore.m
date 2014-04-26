//
//  SimpleDBLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SimpleDBLibraryObjectStore.h"
#import "AbstractLibraryObjectStore.h"
#import "LocalLibraryObjectStore.h"
#import "TransactionStore.h"
#import "Sample.h"
#import "Split.h"
#import "ConflictResolution.h"
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import "LocalEncryptedCredentialsProvider.h"
#import "SimpleDBUtils.h"
#import "LoadingSheet.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SimpleDBLibraryObjectStore()
{
    AmazonSimpleDBClient *simpleDBClient;
    AbstractLibraryObjectStore *localStore;
    TransactionStore *transactionStore;
}
@end


@implementation SimpleDBLibraryObjectStore

- (id)initInLocalDirectory:(NSString *)directory
          WithDatabaseName:(NSString *)databaseName
{
    self = [super initInLocalDirectory:directory WithDatabaseName:databaseName];
    
    if (self) {
        localStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:directory
                                                          WithDatabaseName:databaseName];
        transactionStore = [[TransactionStore alloc] initInLocalDirectory:directory
                                                         WithDatabaseName:databaseName];
        
        id<AmazonCredentialsProvider> credentialsProvider = [LocalEncryptedCredentialsProvider sharedInstance];
        simpleDBClient = [[AmazonSimpleDBClient alloc] initWithCredentialsProvider:credentialsProvider];
    }
    
    return self;
}

- (BOOL)synchronizeWithCloud
{
    LoadingSheet *loading = [[LoadingSheet alloc] init];
    [loading activateSheetWithParentWindow:[NSApp keyWindow]
                                   AndText:@"Syncing with the remote database. Do not interupt this operation.  It may take several minutes to complete."];
    [loading.progressIndicator setIndeterminate:NO];
    
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block BOOL success = NO;
    dispatch_sync(backgroundQueue, ^{
        
        // Get remote history since last update (and 3 minutes before, just in case)
        DDLogCInfo(@"%@: Getting remote history since last update.", NSStringFromClass(self.class));
        NSTimeInterval lastSyncTime = [transactionStore timeOfLastSync];
        NSString *query = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' order by %@ limit 250", [TransactionConstants tableName], TRN_TIMESTAMP, lastSyncTime, TRN_TIMESTAMP];
        NSArray *remoteTransactions = [SimpleDBUtils executeSelectQuery:query
                                                WithReturnedObjectClass:[Transaction class]
                                                            UsingClient:simpleDBClient];
        [loading.progressIndicator incrementBy:10.00];
        if (!remoteTransactions) {
            success = NO;
            return;
        }
        
        // Initialize some arrays and get ConflictResolution objects
        DDLogCInfo(@"%@: Resolving conflicts.", NSStringFromClass(self.class));
        NSArray *resolvedConflicts = [transactionStore resolveConflicts:remoteTransactions];
        NSMutableArray *unsyncedTransactions = [[NSMutableArray alloc] init];
        NSMutableArray *unsyncedSamplePuts = [[NSMutableArray alloc] init];
        NSMutableArray *unsyncedSplitPuts = [[NSMutableArray alloc] init];
        NSMutableArray *unsyncedSampleDeletes = [[NSMutableArray alloc] init];
        NSMutableArray *unsyncedSplitDeletes = [[NSMutableArray alloc] init];
        
        // For each conflict where local is more recent, add to appropriate array
        DDLogCInfo(@"%@: Preparing resolved conflicts for remote syncing.", NSStringFromClass(self.class));
        for (ConflictResolution *resolvedConflict in resolvedConflicts) {
            double progressStepSize = 25.00 / (double)resolvedConflicts.count;
            
            if (resolvedConflict.isLocalMoreRecent) {
                // Reset transaction to current time
                Transaction *resolvedTransaction = resolvedConflict.transaction;
                [resolvedTransaction resetTimestamp];
                
                // Delete transaction
                if ([[resolvedTransaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE] isEqualToString:@"DELETE"]) {
                    if ([[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE] isEqualToString:[SampleConstants tableName]])
                        [unsyncedSampleDeletes addObject:[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
                    else
                        [unsyncedSplitDeletes addObject:[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
                }
                // Put/Update transaction
                else {
                    // Get library object associated with transaction
                    LibraryObject *resolvedObject = [localStore getLibraryObjectForKey:[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]
                                                                             FromTable:[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE]];
                    // Add it to Sample/Split array to be sent to remote
                    if ([resolvedObject isMemberOfClass:[Sample class]])
                        [unsyncedSamplePuts addObject:resolvedObject];
                    else
                        [unsyncedSplitPuts addObject:resolvedObject];
                }
                // Add transaction to be sent to remote
                [unsyncedTransactions addObject:resolvedTransaction];
            }
            [loading.progressIndicator incrementBy:progressStepSize];
        }
        if (resolvedConflicts.count == 0)
            [loading.progressIndicator incrementBy:25.00];
        
        // Add remaining 'dirty' transactions/objects to unsynced arrays
        DDLogCInfo(@"%@: Adding remaining dirty transactions to data to be synced.", NSStringFromClass(self.class));
        NSArray *unsyncedLocalTransactions = [transactionStore getAllTransactions];
        for (Transaction *localTransaction in unsyncedLocalTransactions) {
            double progressStepSize = 15.00 / (double)unsyncedLocalTransactions.count;
            
            // Reset localTransactions to current time
            [localTransaction resetTimestamp];
            
            // Delete transaction
            if ([[localTransaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE] isEqualToString:@"DELETE"]) {
                if ([[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE] isEqualToString:[SampleConstants tableName]])
                    [unsyncedSampleDeletes addObject:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
                else
                    [unsyncedSplitDeletes addObject:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
            }
            // Put/Update transaction
            else {
                // Get library object associated with transaction
                LibraryObject *resolvedObject = [localStore getLibraryObjectForKey:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]
                                                                         FromTable:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE]];
                // Add it to Sample/Split array to be sent to remote
                if ([resolvedObject isMemberOfClass:[Sample class]])
                    [unsyncedSamplePuts addObject:resolvedObject];
                else
                    [unsyncedSplitPuts addObject:resolvedObject];
            }
            
            // Add transaction to be sent to remote
            [unsyncedTransactions addObject:localTransaction];
            
            [loading.progressIndicator incrementBy:progressStepSize];
        }
        if (unsyncedLocalTransactions.count == 0)
            [loading.progressIndicator incrementBy:15.00];
        
        // Put unsynced objects in remote database
        DDLogCInfo(@"%@: Batch put unsynced samples.", NSStringFromClass(self.class));
        [SimpleDBUtils executeBatchPut:unsyncedSamplePuts WithDomainName:[SampleConstants tableName] UsingClient:simpleDBClient];
        DDLogCInfo(@"%@: Batch put unsynced splits.", NSStringFromClass(self.class));
        [SimpleDBUtils executeBatchPut:unsyncedSplitPuts WithDomainName:[SplitConstants tableName] UsingClient:simpleDBClient];
        [loading.progressIndicator incrementBy:10.00];
        
        // Delete unsynced objects in remote database
        DDLogCInfo(@"%@: Batch delete unsynced samples.", NSStringFromClass(self.class));
        [SimpleDBUtils executeBatchDelete:unsyncedSampleDeletes WithDomainName:[SampleConstants tableName] UsingClient:simpleDBClient];
        DDLogCInfo(@"%@: Batch delete unsynced splits.", NSStringFromClass(self.class));
        [SimpleDBUtils executeBatchDelete:unsyncedSplitDeletes WithDomainName:[SplitConstants tableName] UsingClient:simpleDBClient];
        [loading.progressIndicator incrementBy:10.00];
        
        // Put unsycned transaction in remote database
        DDLogCInfo(@"%@: Batch put unsynced transactions.", NSStringFromClass(self.class));
        [SimpleDBUtils executeBatchPut:unsyncedTransactions WithDomainName:[TransactionConstants tableName] UsingClient:simpleDBClient];
        [loading.progressIndicator incrementBy:5.00];
        
        // Get changed objects from remote database
        DDLogCInfo(@"%@: Adding remotely changed objects to local database", NSStringFromClass(self.class));
        @try {
            for (ConflictResolution *resolvedConflict in resolvedConflicts) {
                double progressStepSize = 25.00 / (double)resolvedConflicts.count;
                
                // Only for conflicts where remote is more recent
                if (!resolvedConflict.isLocalMoreRecent) {
                    NSString *tableName = [resolvedConflict.transaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE];
                    NSString *sqlCommandType = [resolvedConflict.transaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE];
                    NSString *libraryObjectKey = [resolvedConflict.transaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY];
                    
                    // Update changes to remote object with local database
                    if ([sqlCommandType isEqualToString:@"DELETE"])
                        [localStore deleteLibraryObjectWithKey:libraryObjectKey FromTable:tableName];
                    else {
                        // Get library object from remote database
                        LibraryObject *remoteObject = (LibraryObject *)[SimpleDBUtils executeGetWithItemName:libraryObjectKey
                                                                                           AndWithDomainName:tableName
                                                                                                 UsingClient:simpleDBClient
                                                                                             ToObjectOfClass:[tableName isEqualToString:[SampleConstants tableName]] ? [Sample class] : [Split class]];
                        if ([sqlCommandType isEqualToString:@"PUT"])
                            [localStore putLibraryObject:remoteObject IntoTable:tableName];
                        else if ([sqlCommandType isEqualToString:@"UPDATE"])
                            [localStore updateLibraryObject:remoteObject IntoTable:tableName];
                    }
                }
                [loading.progressIndicator incrementBy:progressStepSize];
            }
            if (resolvedConflicts.count == 0)
                [loading.progressIndicator incrementBy:25.00];
        }
        @catch (NSException *exception) {
            DDLogCError(@"%@: Failed while get changed library object from remote database. Error: %@", NSStringFromClass(self.class), exception);
            success = NO;
            return;
        }
        
        [transactionStore clearLocalTransactions];
        success = YES;
        return;
    });
    
    [loading closeSheet];
    return success;
}

- (BOOL)setupDomains
{
    return [SimpleDBUtils setupDomainsUsingClient:simpleDBClient];
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)tableName
{
    return [localStore getLibraryObjectForKey:key FromTable:tableName];
}

- (NSArray *)getAllLibraryObjectsFromTable:(NSString *)tableName
{
    return [localStore getAllLibraryObjectsFromTable:tableName];
}

- (NSArray *)getAllSplitsForSampleKey:(NSString *)sampleKey
{
    return [localStore getAllSplitsForSampleKey:sampleKey];
}

- (NSArray *)getAllLibraryObjectsForAttributeName:(NSString *)attributeName
                               WithAttributeValue:(NSString *)attributeValue
                                        FromTable:(NSString *)tableName
{
    return [localStore getAllLibraryObjectsForAttributeName:attributeName
                                         WithAttributeValue:attributeValue
                                                  FromTable:tableName];
}

- (NSArray *)getAllSplitsForSampleKey:(NSString *)sampleKey
                   AndForAttributeName:(NSString *)attributeName
                    WithAttributeValue:(NSString *)attributeValue
{
    return [localStore getAllSplitsForSampleKey:sampleKey
                             AndForAttributeName:attributeName
                              WithAttributeValue:attributeValue];
}

- (NSArray *)getUniqueAttributeValuesForAttributeName:(NSString *)attributeName
                                            FromTable:(NSString *)tableName
{
    return [localStore getUniqueAttributeValuesForAttributeName:attributeName FromTable:tableName];
}

- (NSArray *)getLibraryObjectsWithSqlQuery:(NSString *)sql
                                   OnTable:(NSString *)tableName
{
    return [localStore getLibraryObjectsWithSqlQuery:sql OnTable:tableName];
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
               IntoTable:(NSString *)tableName
{
    if (![localStore putLibraryObject:libraryObject IntoTable:tableName])
        return NO;
    
    Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:[libraryObject key]
                                                            AndWithTableName:tableName
                                                       AndWithSqlCommandType:@"PUT"];
    if (![transactionStore commitTransaction:transaction])
        return NO;
    
    return YES;
}

- (BOOL)updateLibraryObject:(LibraryObject *)libraryObject
                  IntoTable:(NSString *)tableName
{
    if (![localStore updateLibraryObject:libraryObject IntoTable:tableName])
        return NO;
    
    Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:[libraryObject key]
                                                            AndWithTableName:tableName
                                                       AndWithSqlCommandType:@"UPDATE"];
    if (![transactionStore commitTransaction:transaction])
        return NO;
    
    return YES;
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
                         FromTable:(NSString *)tableName
{
    NSArray *splits;
    if ([tableName isEqualToString:[SampleConstants tableName]])
        splits = [localStore getAllSplitsForSampleKey:key];
    
    if (![localStore deleteLibraryObjectWithKey:key FromTable:tableName])
        return NO;
    
    Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:key
                                                            AndWithTableName:tableName
                                                       AndWithSqlCommandType:@"DELETE"];
    if (![transactionStore commitTransaction:transaction])
        return NO;
    
    // Need to add split deletions to transaction table too
    if (splits) {
        for (Split *split in splits) {
            Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:split.key
                                                                    AndWithTableName:[SplitConstants tableName]
                                                               AndWithSqlCommandType:@"DELETE"];
            if (![transactionStore commitTransaction:transaction])
                return NO;
        }
    }
    
    return YES;
}

- (BOOL)deleteAllSplitsForSampleKey:(NSString *)sampleKey
{
    NSArray *splits = [localStore getAllSplitsForSampleKey:sampleKey];
    
    if (![localStore deleteAllSplitsForSampleKey:sampleKey])
        return NO;
    
    for (Split *split in splits) {
        Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:split.key
                                                                AndWithTableName:[SplitConstants tableName]
                                                           AndWithSqlCommandType:@"DELETE"];
        if (![transactionStore commitTransaction:transaction])
            return NO;
    }
    
    return YES;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
                        FromTable:(NSString *)tableName
{
    return [localStore libraryObjectExistsForKey:key FromTable:tableName];
}

- (NSUInteger)countInTable:(NSString *)tableName
{
    return [localStore countInTable:tableName];
}

@end
