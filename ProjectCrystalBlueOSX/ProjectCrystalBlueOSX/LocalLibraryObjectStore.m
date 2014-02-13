//
//  LocalLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LocalLibraryObjectStore.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "Source.h"
#import "Sample.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"LocalLibraryObjectStore"

@interface LocalLibraryObjectStore()
{
    FMDatabaseQueue *localQueue;
}

- (BOOL)setupTables;

@end


@implementation LocalLibraryObjectStore

- (id)initInLocalDirectory:(NSString *)directory
          WithDatabaseName:(NSString *)databaseName
{
    self = [super initInLocalDirectory:directory WithDatabaseName:databaseName];
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
        
        // Setup tables, if fail, try again after 2 seconds
        if (![self setupTables]) {
            sleep(2);
            [self setupTables];
        }
    }
    return self;
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE key='%@'", tableName, key];
    
    // Get library object with key
    __block NSDictionary *resultDictionary = nil;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to get library object from local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
        
        // Have the library object's attributes
        else if ([results next])
            resultDictionary = [results resultDictionary];
        [results close];
    }];
    
    if (!resultDictionary)
        return nil;
    
    // Create a new Source or Sample object
    if ([tableName isEqualToString:[SourceConstants tableName]])
        return [[Source alloc] initWithKey:key AndWithAttributeDictionary:resultDictionary];
    else
        return [[Sample alloc] initWithKey:key AndWithAttributeDictionary:resultDictionary];
}

- (NSArray *)getAllLibraryObjectsFromTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    NSMutableArray *libraryObjects = [[NSMutableArray alloc] init];
    
    // Get all library objects from table
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if ([localDatabase hadError]) {
            DDLogCError(@"%@: Failed to get all library objects from local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
            [results close];
            return;
        }
        
        // Add all the results to the libraryObjects array
        while ([results next]) {
            NSString *key = [[results resultDictionary] objectForKey:@"key"];
            if ([tableName isEqualToString:[SourceConstants tableName]])
                [libraryObjects addObject:[[Source alloc] initWithKey:key AndWithAttributeDictionary:[results resultDictionary]]];
            else
                [libraryObjects addObject:[[Sample alloc] initWithKey:key AndWithAttributeDictionary:[results resultDictionary]]];
        }
        [results close];
    }];
    
    return libraryObjects;
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
               IntoTable:(NSString *)tableName
{
    // Setup sql query
    NSString *sql;
    if ([tableName isEqualToString:[SourceConstants tableName]])
        sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
               tableName, [SourceConstants tableColumns], [SourceConstants tableValueKeys]];
    else
        sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
               tableName, [SampleConstants tableColumns], [SampleConstants tableValueKeys]];
    
    // FMDB will use the attributes dictionary and tableValueKeys to insert the values
    __block BOOL success = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        success = [localDatabase executeUpdate:sql withParameterDictionary:[libraryObject attributes]];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to put library object into local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
    }];
    
    return success;
}

- (BOOL)updateLibraryObject:(LibraryObject *)libraryObject
                  IntoTable:(NSString *)tableName
{
    LibraryObject *oldObject = [self getLibraryObjectForKey:[libraryObject key] FromTable:tableName];
    if (!oldObject) {
        DDLogCError(@"%@: Cannot update non-existent object!", CLASS_NAME);
        return NO;
    }
    
    NSArray *attrKeys = [[libraryObject attributes] allKeys];
    NSString *setSql;
    
    // Build the sql command, only update attributes that have changed
    for (int i=0; i<[attrKeys count]; i++) {
        NSString *attrValue = [[libraryObject attributes] objectForKey:[attrKeys objectAtIndex:i]];
        NSString *oldAttrValue = [[oldObject attributes] objectForKey:[attrKeys objectAtIndex:i]];
        
        if (![attrValue isEqualToString:oldAttrValue]) {
            if (!setSql)
                setSql = [NSString stringWithFormat:@"SET %@='%@'", [attrKeys objectAtIndex:i], attrValue];
            else
                setSql = [setSql stringByAppendingString:[NSString stringWithFormat:@", %@='%@'",
                                                          [attrKeys objectAtIndex:i], attrValue]];
        }
    }
    
    // No attributes have changed
    if (!setSql) {
        DDLogCInfo(@"%@: There were no attributes to update.", CLASS_NAME);
        return YES;
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ %@ WHERE key='%@'", tableName, setSql, [libraryObject key]];
    
    // Update the library object
    __block BOOL isUpdated = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        isUpdated = [localDatabase executeUpdate:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to update library object in local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
    }];
    
    return isUpdated;
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
                         FromTable:(NSString *)tableName
{
    if (![self libraryObjectExistsForKey:key FromTable:tableName]) {
        DDLogCError(@"%@: Library object attempting to delete does not exist in the local database", CLASS_NAME);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE key='%@'", tableName, key];
    
    // Check library object for key
    __block BOOL isDeleted = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        isDeleted = [localDatabase executeUpdate:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to delete library object from local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
    }];
    
    return isDeleted;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
                        FromTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE key='%@'", tableName, key];
    
    // Check library object for key
    __block BOOL objectExists = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to get library object from local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
        
        // Have the library object's attributes
        else if ([results next])
            objectExists = YES;
        [results close];
    }];
    
    return objectExists;
}

- (NSInteger)countInTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) FROM %@", tableName];
    
    // Get the number of rows in table
    __block NSInteger count = 0;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        FMResultSet *results = [localDatabase executeQuery:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to get count from local database. Error: %@", CLASS_NAME, [localDatabase lastError]);
        
        // Have the library object's attributes
        else if ([results next])
            count = [[[results resultDictionary] objectForKey:@"count(*)"] integerValue];
        [results close];
    }];
    
    return count;
}

- (BOOL)setupTables
{
    __block BOOL sourceSuccess = NO;
    __block BOOL sampleSuccess = NO;
    [localQueue inDeferredTransaction:^(FMDatabase *localDatabase, BOOL *rollback) {
        // Create source table
        sourceSuccess = [localDatabase executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",
                                                      [SourceConstants tableName], [SourceConstants tableSchema]]];
        if ([localDatabase hadError]) {
            DDLogCError(@"%@: Failed to create the source table. Error: %@", CLASS_NAME, [localDatabase lastError]);
            *rollback = YES;
            return;
        }
        
        // Create sample table
        sampleSuccess = [localDatabase executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",
                                                      [SampleConstants tableName], [SampleConstants tableSchema]]];
        if ([localDatabase hadError]) {
            DDLogCError(@"%@: Failed to create the sample table. Error: %@", CLASS_NAME, [localDatabase lastError]);
            *rollback = YES;
            return;
        }
    }];
    
    return (sourceSuccess && sampleSuccess);
}

@end
