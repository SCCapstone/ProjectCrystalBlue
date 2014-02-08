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
        
    }
    return self;
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)table
{
    __block NSDictionary *resultDictionary = nil;
    [localQueue inDatabase:^(FMDatabase *localDatabase){
        FMResultSet *results = [localDatabase executeQueryWithFormat:@"SELECT * FROM %@ WHERE key=%@", table, key];
        if ([results next])
            resultDictionary = [results resultDictionary];
        [results close];
    }];
    
    if (!resultDictionary)
        return nil;
    
    LibraryObject *libraryObject = nil;
    if ([table isEqualToString:[SourceConstants sourceTableName]]) {
        libraryObject = [[Source alloc] initWithKey:key AndWithValues:nil];
    }
    else {
        libraryObject = [[Sample alloc] initWithKey:key AndWithValues:nil];
    }
    
    return libraryObject;
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  forKey:(NSString *)key
               IntoTable:(NSString *)table
{
    __block BOOL success = NO;
    [localQueue inDatabase:^(FMDatabase *localDatabase) {
        success = [localDatabase executeUpdateWithFormat:@"INSERT INTO %@ (key,value1,value2) VALUES (%@,%@,%@)",
                   table, key, @"this", @"works"];
    }];
    
    return success;
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
                         FromTable:(NSString *)table
{
    return NO;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
                        FromTable:(NSString *)table
{
    return NO;
}

@end
