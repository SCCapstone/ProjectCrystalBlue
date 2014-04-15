//
//  FileSystemUtils.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "FileSystemUtils.h"

#define APP_SUPPORT_DIR @"Application Support"
#define APP_NAME @"CrystalBlue"
#define IMAGES @"Images"
#define DATASTORE @"Data"
#define TMP @"Temp"

@implementation FileSystemUtils

+ (NSString *)localRootDirectory
{
    NSFileManager *defFileManager = [NSFileManager defaultManager];

    NSArray *libURLs = [defFileManager URLsForDirectory:NSLibraryDirectory
                                              inDomains:NSUserDomainMask];
    NSURL *libraryURL = [libURLs objectAtIndex:0];
    NSURL *appSupportURL = [libraryURL URLByAppendingPathComponent:APP_SUPPORT_DIR
                                                       isDirectory:YES];
    NSURL *rootDirectoryURL = [appSupportURL URLByAppendingPathComponent:APP_NAME
                                                             isDirectory:YES];

    [defFileManager createDirectoryAtURL:rootDirectoryURL
             withIntermediateDirectories:YES
                              attributes:nil
                                   error:nil];

    return [rootDirectoryURL path];
}

+ (NSString *)localImagesDirectory
{
    NSString *rootDir = [self.class localRootDirectory];
    NSString *imagesDir = [rootDir stringByAppendingPathComponent:IMAGES];

    [[NSFileManager defaultManager] createDirectoryAtPath:imagesDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];

    return imagesDir;
}

/**
 *  The full filepath to the data directory (for storing the local SQLite database, for example).
 */
+ (NSString *)localDataDirectory
{
    NSString *rootDir = [self.class localRootDirectory];
    NSString *dataDir = [rootDir stringByAppendingPathComponent:DATASTORE];

    [[NSFileManager defaultManager] createDirectoryAtPath:dataDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];

    return dataDir;
}

/**
 *  The full filepath to the test directory (scratch directory for unit tests, etc.).
 */
+ (NSString *)testDirectory
{
    NSString *rootDir = [self.class localRootDirectory];
    NSString *testDir = [rootDir stringByAppendingPathComponent:TMP];

    [[NSFileManager defaultManager] createDirectoryAtPath:testDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];

    return testDir;
}

/**
 *  Removes all data from the test directory. This should be called after every unit test that
 *  accesses the file system.
 */
+ (BOOL)clearTestDirectory
{
    return [[NSFileManager defaultManager] removeItemAtPath:[self.class testDirectory] error:nil];
}

@end
