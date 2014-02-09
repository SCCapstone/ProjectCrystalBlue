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
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import "HardcodedCredentialsProvider.h"
#import "LocalTransactionCache.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"SimpleDBLibraryObjectStore"

@interface SimpleDBLibraryObjectStore()
{
    AmazonSimpleDBClient *simpleDBClient;
    AbstractLibraryObjectStore *localStore;
    LocalTransactionCache *dirtyKeys;
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
        dirtyKeys = [[LocalTransactionCache alloc] initInDirectory:directory
                                                      withFileName:@""];
        
        NSObject<AmazonCredentialsProvider> *credentialsProvider = [[HardcodedCredentialsProvider alloc] init];
        simpleDBClient = [[AmazonSimpleDBClient alloc] initWithCredentialsProvider:credentialsProvider];
    }
    
    return self;
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)tableName
{
    return [super getLibraryObjectForKey:key FromTable:tableName];
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
               IntoTable:(NSString *)tableName
{
    return [super putLibraryObject:libraryObject IntoTable:tableName];
}

- (BOOL)updateLibraryObject:(LibraryObject *)libraryObject
                  IntoTable:(NSString *)tableName
{
    return [super updateLibraryObject:libraryObject IntoTable:tableName];
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
                         FromTable:(NSString *)tableName
{
    return [super deleteLibraryObjectWithKey:key FromTable:tableName];
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
                        FromTable:(NSString *)tableName
{
    return [super libraryObjectExistsForKey:key FromTable:tableName];
}

- (BOOL)synchronizeWithCloud
{
    return NO;
}

- (BOOL)keyIsDirty:(NSString *)key
{
    return NO;
}

@end
