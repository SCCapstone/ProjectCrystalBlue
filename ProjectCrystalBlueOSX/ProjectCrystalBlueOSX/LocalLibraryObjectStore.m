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
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"LocalLibraryObjectStore"

@interface LocalLibraryObjectStore()
{
    //FMDatabase *localDatabase;
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
        
        //localDatabase = [FMDatabase databaseWithPath:[localDirectory stringByAppendingPathComponent:databaseName]];
        localQueue = [FMDatabaseQueue databaseQueueWithPath:[localDirectory stringByAppendingPathComponent:databaseName]];
    }
    return self;
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
{
    return nil;
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  forKey:(NSString *)key
{
    return NO;
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
{
    return NO;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
{
    return NO;
}

@end
