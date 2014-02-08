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
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        
        localQueue = [FMDatabaseQueue databaseQueueWithPath:[localDirectory stringByAppendingPathComponent:databaseName]];
        [self setupTables];
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
            DDLogCError(@"%@: Failed to get library object from database. Error: %@", CLASS_NAME, [localDatabase lastError]);
        
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

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  forKey:(NSString *)key
               IntoTable:(NSString *)tableName
{
    // Setup sql query
    NSString *sql;
    if ([tableName isEqualToString:[SourceConstants tableName]])
        sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, [SourceConstants tableColumns], [SourceConstants tableValueKeys]];
    else
        sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, [SampleConstants tableColumns], [SampleConstants tableValueKeys]];
    
    // FMDB will use the attributes dictionary and tableValueKeys to insert the values
    __block BOOL success = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        success = [localDatabase executeUpdate:sql withParameterDictionary:[libraryObject attributes]];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to put library object into database. Error: %@", CLASS_NAME, [localDatabase lastError]);
    }];
    
    return success;
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
                         FromTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE key='%@'", tableName, key];
    
    // Check library object for key
    __block BOOL isDeleted = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        isDeleted = [localDatabase executeUpdate:sql];
        
        if ([localDatabase hadError])
            DDLogCError(@"%@: Failed to delete library object from database. Error: %@", CLASS_NAME, [localDatabase lastError]);
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
            DDLogCError(@"%@: Failed to get library object from database. Error: %@", CLASS_NAME, [localDatabase lastError]);
        
        // Have the library object's attributes
        else if ([results next])
            objectExists = YES;
        [results close];
    }];
    
    return objectExists;
}

- (BOOL)setupTables
{
    __block BOOL success = NO;
    [localQueue inDeferredTransaction:^(FMDatabase *localDatabase, BOOL *rollback) {
        // Create source table
        success = [localDatabase executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",
                                                [SourceConstants tableName], [SourceConstants tableSchema]]];
        // Create sample table
        success = [localDatabase executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",
                                                [SampleConstants tableName], [SampleConstants tableSchema]]];
        
        if ([localDatabase hadError]) {
            DDLogCError(@"%@: Failed to create source/sample tables. Error: %@", CLASS_NAME, [localDatabase lastError]);
            *rollback = YES;
        }
    }];
    
    return success;
}

@end
