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
        
        //if (![self setupDomains])
        //    return nil;
    }
    
    return self;
}

- (BOOL)synchronizeWithCloud
{
    // Get remote history since last update
    
    
    // Compare remote with local.  For each transaction, conflicting key? Resolve conflicts
    
    // Push modified local history and corresponding library objects
    
    return NO;
}

- (BOOL)setupDomains
{
    @try {
        SimpleDBListDomainsResponse *listResponse = [simpleDBClient listDomains:[[SimpleDBListDomainsRequest alloc] init]];
        SimpleDBCreateDomainRequest *createRequest;
        SimpleDBCreateDomainResponse *createResponse;
        
        // Source domain
        if (![listResponse.domainNames containsObject:[SourceConstants tableName]]) {
            createRequest = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:[SourceConstants tableName]];
            createResponse = [simpleDBClient createDomain:createRequest];
        }
        
        // Sample domain
        if (![listResponse.domainNames containsObject:[SampleConstants tableName]]) {
            createRequest = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:[SampleConstants tableName]];
            createResponse = [simpleDBClient createDomain:createRequest];
        }
        
        // Transaction domain
        if (![listResponse.domainNames containsObject:[TransactionConstants tableName]]) {
            createRequest = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:[TransactionConstants tableName]];
            createResponse = [simpleDBClient createDomain:createRequest];
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

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
               IntoTable:(NSString *)tableName
{
    if (![localStore putLibraryObject:libraryObject IntoTable:tableName])
        return NO;
    
    Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:[libraryObject key]
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
