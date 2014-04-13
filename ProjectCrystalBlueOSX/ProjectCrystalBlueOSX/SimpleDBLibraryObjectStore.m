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
#import "Source.h"
#import "Sample.h"
#import "ConflictResolution.h"
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import "LocalEncryptedCredentialsProvider.h"
#import "SimpleDBUtils.h"
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
        
        id<AmazonCredentialsProvider> credentialsProvider = [[LocalEncryptedCredentialsProvider alloc] init];
        simpleDBClient = [[AmazonSimpleDBClient alloc] initWithCredentialsProvider:credentialsProvider];
        
        [self setupDomains];
    }
    
    return self;
}

- (BOOL)synchronizeWithCloud
{
    // Get remote history since last update
    DDLogCInfo(@"%@: Getting remote history since last update.", NSStringFromClass(self.class));
    NSTimeInterval lastSyncTime = [transactionStore timeOfLastSync];
    NSString *query = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' order by %@ limit 250", [TransactionConstants tableName], TRN_TIMESTAMP, lastSyncTime, TRN_TIMESTAMP];
    NSArray *remoteTransactions = [SimpleDBUtils executeSelectQuery:query
                                            WithReturnedObjectClass:[Transaction class]
                                                        UsingClient:simpleDBClient];
    if (!remoteTransactions)
        return NO;
    
    // Initialize some arrays and get ConflictResolution objects
    DDLogCInfo(@"%@: Resolving conflicts.", NSStringFromClass(self.class));
    NSArray *resolvedConflicts = [transactionStore resolveConflicts:remoteTransactions];
    NSMutableArray *unsyncedTransactions = [[NSMutableArray alloc] init];
    NSMutableArray *unsyncedSourcePuts = [[NSMutableArray alloc] init];
    NSMutableArray *unsyncedSamplePuts = [[NSMutableArray alloc] init];
    NSMutableArray *unsyncedSourceDeletes = [[NSMutableArray alloc] init];
    NSMutableArray *unsyncedSampleDeletes = [[NSMutableArray alloc] init];
    
    // For each conflict where local is more recent, add to appropriate array
    DDLogCInfo(@"%@: Preparing resolved conflicts for remote syncing.", NSStringFromClass(self.class));
    for (ConflictResolution *resolvedConflict in resolvedConflicts) {
        if (resolvedConflict.isLocalMoreRecent) {
            // Reset transaction to current time
            Transaction *resolvedTransaction = resolvedConflict.transaction;
            [resolvedTransaction resetTimestamp];
            
            // Delete transaction
            if ([[resolvedTransaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE] isEqualToString:@"DELETE"]) {
                if ([[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE] isEqualToString:[SourceConstants tableName]])
                    [unsyncedSourceDeletes addObject:[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
                else
                    [unsyncedSampleDeletes addObject:[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
            }
            // Put/Update transaction
            else {
                // Get library object associated with transaction
                LibraryObject *resolvedObject = [localStore getLibraryObjectForKey:[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]
                                                                         FromTable:[resolvedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE]];
                // Add it to Source/Sample array to be sent to remote
                if ([resolvedObject isMemberOfClass:[Source class]])
                    [unsyncedSourcePuts addObject:resolvedObject];
                else
                    [unsyncedSamplePuts addObject:resolvedObject];
            }
            // Add transaction to be sent to remote
            [unsyncedTransactions addObject:resolvedTransaction];
        }
    }
    
    // Add remaining 'dirty' transactions/objects to unsynced arrays
    DDLogCInfo(@"%@: Adding remaining dirty transactions to data to be synced.", NSStringFromClass(self.class));
    NSArray *unsyncedLocalTransactions = [transactionStore getAllTransactions];
    for (Transaction *localTransaction in unsyncedLocalTransactions) {
        // Reset localTransactions to current time
        [localTransaction resetTimestamp];
        
        // Delete transaction
        if ([[localTransaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE] isEqualToString:@"DELETE"]) {
            if ([[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE] isEqualToString:[SourceConstants tableName]])
                [unsyncedSourceDeletes addObject:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
            else
                [unsyncedSampleDeletes addObject:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
        }
        // Put/Update transaction
        else {
            // Get library object associated with transaction
            LibraryObject *resolvedObject = [localStore getLibraryObjectForKey:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]
                                                                     FromTable:[localTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE]];
            // Add it to Source/Sample array to be sent to remote
            if ([resolvedObject isMemberOfClass:[Source class]])
                [unsyncedSourcePuts addObject:resolvedObject];
            else
                [unsyncedSamplePuts addObject:resolvedObject];
        }
        
        // Add transaction to be sent to remote
        [unsyncedTransactions addObject:localTransaction];
        
    }
    
    // Put unsynced objects in remote database
    DDLogCInfo(@"%@: Batch put unsynced sources.", NSStringFromClass(self.class));
    [SimpleDBUtils executeBatchPut:unsyncedSourcePuts WithDomainName:[SourceConstants tableName] UsingClient:simpleDBClient];
    DDLogCInfo(@"%@: Batch put unsynced samples.", NSStringFromClass(self.class));
    [SimpleDBUtils executeBatchPut:unsyncedSamplePuts WithDomainName:[SampleConstants tableName] UsingClient:simpleDBClient];
    
    // Delete unsynced objects in remote database
    DDLogCInfo(@"%@: Batch delete unsynced sources.", NSStringFromClass(self.class));
    [SimpleDBUtils executeBatchDelete:unsyncedSourceDeletes WithDomainName:[SourceConstants tableName] UsingClient:simpleDBClient];
    DDLogCInfo(@"%@: Batch delete unsynced samples.", NSStringFromClass(self.class));
    [SimpleDBUtils executeBatchDelete:unsyncedSampleDeletes WithDomainName:[SampleConstants tableName] UsingClient:simpleDBClient];
    
    // Put unsycned transaction in remote database
    DDLogCInfo(@"%@: Batch put unsynced transactions.", NSStringFromClass(self.class));
    [SimpleDBUtils executeBatchPut:unsyncedTransactions WithDomainName:[TransactionConstants tableName] UsingClient:simpleDBClient];
    
    // Get changed objects from remote database
    DDLogCInfo(@"%@: Adding remotely changed objects to local database", NSStringFromClass(self.class));
    @try {
        for (ConflictResolution *resolvedConflict in resolvedConflicts) {
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
                                                                                         ToObjectOfClass:[tableName isEqualToString:[SourceConstants tableName]] ? [Source class] : [Sample class]];
                    if ([sqlCommandType isEqualToString:@"PUT"])
                        [localStore putLibraryObject:remoteObject IntoTable:tableName];
                    else if ([sqlCommandType isEqualToString:@"UPDATE"])
                        [localStore updateLibraryObject:remoteObject IntoTable:tableName];
                }
            }
        }
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@: Failed while get changed library object from remote database. Error: %@", NSStringFromClass(self.class), exception);
        return NO;
    }
    
    [transactionStore clearLocalTransactions];
    return YES;
}

- (BOOL)setupDomains
{
    @try {
        SimpleDBListDomainsResponse *listResponse = [simpleDBClient listDomains:[[SimpleDBListDomainsRequest alloc] init]];
        SimpleDBCreateDomainRequest *createRequest;
        
        // Source domain
        if (![listResponse.domainNames containsObject:[SourceConstants tableName]]) {
            createRequest = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:[SourceConstants tableName]];
            [simpleDBClient createDomain:createRequest];
        }
        
        // Sample domain
        if (![listResponse.domainNames containsObject:[SampleConstants tableName]]) {
            createRequest = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:[SampleConstants tableName]];
            [simpleDBClient createDomain:createRequest];
        }
        
        // Transaction domain
        if (![listResponse.domainNames containsObject:[TransactionConstants tableName]]) {
            createRequest = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:[TransactionConstants tableName]];
            [simpleDBClient createDomain:createRequest];
        }
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@: Failed to create the domains. Error: %@", NSStringFromClass(self.class), exception);
        return NO;
    }
    
    DDLogCInfo(@"%@: Setup the remote domains.", NSStringFromClass(self.class));
    return YES;
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

- (NSArray *)getAllSamplesForSourceKey:(NSString *)sourceKey
{
    return [localStore getAllSamplesForSourceKey:sourceKey];
}

- (NSArray *)getAllLibraryObjectsForAttributeName:(NSString *)attributeName
                               WithAttributeValue:(NSString *)attributeValue
                                        FromTable:(NSString *)tableName
{
    return [localStore getAllLibraryObjectsForAttributeName:attributeName
                                         WithAttributeValue:attributeValue
                                                  FromTable:tableName];
}

- (NSArray *)getAllSamplesForSourceKey:(NSString *)sourceKey
                   AndForAttributeName:(NSString *)attributeName
                    WithAttributeValue:(NSString *)attributeValue
{
    return [localStore getAllSamplesForSourceKey:sourceKey
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
    NSArray *samples;
    if ([tableName isEqualToString:[SourceConstants tableName]])
        samples = [localStore getAllSamplesForSourceKey:key];
    
    if (![localStore deleteLibraryObjectWithKey:key FromTable:tableName])
        return NO;
    
    Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:key
                                                            AndWithTableName:tableName
                                                       AndWithSqlCommandType:@"DELETE"];
    if (![transactionStore commitTransaction:transaction])
        return NO;
    
    // Need to add sample deletions to transaction table too
    if (samples) {
        for (Sample *sample in samples) {
            Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:sample.key
                                                                    AndWithTableName:[SampleConstants tableName]
                                                               AndWithSqlCommandType:@"DELETE"];
            if (![transactionStore commitTransaction:transaction])
                return NO;
        }
    }
    
    return YES;
}

- (BOOL)deleteAllSamplesForSourceKey:(NSString *)sourceKey
{
    NSArray *samples = [localStore getAllSamplesForSourceKey:sourceKey];
    
    if (![localStore deleteAllSamplesForSourceKey:sourceKey])
        return NO;
    
    for (Sample *sample in samples) {
        Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:sample.key
                                                                AndWithTableName:[SampleConstants tableName]
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
