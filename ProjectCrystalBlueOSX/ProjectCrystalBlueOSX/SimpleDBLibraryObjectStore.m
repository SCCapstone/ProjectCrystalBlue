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
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import "HardcodedCredentialsProvider.h"
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
        
        NSObject<AmazonCredentialsProvider> *credentialsProvider = [[HardcodedCredentialsProvider alloc] init];
        simpleDBClient = [[AmazonSimpleDBClient alloc] initWithCredentialsProvider:credentialsProvider];
        
//        if (![self setupDomains])
//            return nil;
    }
    
    return self;
}

- (BOOL)synchronizeWithCloud
{
    // Get remote history since last update
    NSTimeInterval lastSyncTime = [transactionStore timeOfLastSync];
    NSString *query = [NSString stringWithFormat:@"select * from %@ where timestamp >= '%f' order by timestamp limit 250", [TransactionConstants tableName], lastSyncTime];
    NSArray *remoteTransactions = [SimpleDBUtils executeSelectQuery:query
                                            WithReturnedObjectClass:[Transaction class]
                                                        UsingClient:simpleDBClient];
    if (!remoteTransactions)
        return NO;
    
    // Upload local changes to remote database
    @try {
        NSArray *localTransactions = [SimpleDBUtils convertObjectArrayToSimpleDBItemArray:[transactionStore getAllTransactions]];
        NSInteger remainingItems = localTransactions.count;
        int count = 0;
        
        while (remainingItems > 0) {
            NSMutableArray *putItems = [[localTransactions subarrayWithRange:NSMakeRange(count*25, MIN(remainingItems, 25))] mutableCopy];
            
            SimpleDBBatchPutAttributesRequest *batchPutRequest = [[SimpleDBBatchPutAttributesRequest alloc] initWithDomainName:[TransactionConstants tableName]
                                                                                                                 andItems:putItems];
            [simpleDBClient batchPutAttributes:batchPutRequest];
            
            remainingItems = remainingItems - 25;
            count++;
        }
        
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@: Failed to upload local transactions to the remote database. Error: %@", NSStringFromClass(self.class), exception);
        return NO;
    }
    
    // Get changed objects from remote database
    @try {
        NSArray *unsyncedTransactions = [SimpleDBUtils convertObjectArrayToSimpleDBItemArray:[transactionStore resolveConflicts:remoteTransactions]];
        
        for (Transaction *unsyncedTransaction in unsyncedTransactions) {
            NSString *tableName = [unsyncedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_TABLE];
            NSString *sqlCommandType = [unsyncedTransaction.attributes objectForKey:TRN_SQL_COMMAND_TYPE];
            SimpleDBGetAttributesRequest *getRequest = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:tableName
                                                                                                    andItemName:[unsyncedTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
            SimpleDBGetAttributesResponse *getResponse = [simpleDBClient getAttributes:getRequest];
            LibraryObject *libraryObject = [SimpleDBUtils convertSimpleDBAttributes:getResponse.attributes
                                                                    ToObjectOfClass:[tableName isEqualToString:[SourceConstants tableName]] ? [Source class] : [Sample class]];
            
            if ([sqlCommandType isEqualToString:@"PUT"])
                [localStore putLibraryObject:libraryObject IntoTable:tableName];
            else if ([sqlCommandType isEqualToString:@"UPDATE"])
                [localStore updateLibraryObject:libraryObject IntoTable:tableName];
            else if ([sqlCommandType isEqualToString:@"DELETE"])
                [localStore deleteLibraryObjectWithKey:libraryObject.key FromTable:tableName];
        }
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@: Failed while putting local transactions to the remote database. Error: %@", NSStringFromClass(self.class), exception);
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

- (NSArray *)getAllSamplesForSource:(Source *)source
{
    return [localStore getAllSamplesForSource:source];
}

- (NSArray *)executeSqlQuery:(NSString *)sql
                     OnTable:(NSString *)tableName
{
    return [localStore executeSqlQuery:sql OnTable:tableName];
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
    if (![localStore deleteLibraryObjectWithKey:key FromTable:tableName])
        return NO;
    
    Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:key
                                                            AndWithTableName:tableName
                                                       AndWithSqlCommandType:@"DELETE"];
    if (![transactionStore commitTransaction:transaction])
        return NO;
    
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
