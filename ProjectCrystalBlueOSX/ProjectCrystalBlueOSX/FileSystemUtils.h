//
//  FileSystemUtils.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A singleton class containing various filesystem helper functions and constants.
@interface FileSystemUtils : NSObject

/**
 *  The full filepath to the primary root directory for storing data associated with the
 *  Project Crystal Blue application.
 */
+ (NSString *)localRootDirectory;

/**
 *  The full filepath to the images directory.
 */
+ (NSString *)localImagesDirectory;

/**
 *  The full filepath to the data directory (for storing the local SQLite database, for example).
 */
+ (NSString *)localDataDirectory;

/**
 *  The full filepath to the test directory (scratch directory for unit tests, etc.).
 */
+ (NSString *)testDirectory;

/**
 *  Removes all data from the test directory. This should be called after every unit test that
 *  accesses the file system.
 */
+ (BOOL)clearTestDirectory;

@end
