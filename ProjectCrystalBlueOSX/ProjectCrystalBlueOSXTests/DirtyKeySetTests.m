//
//  DirtyKeySetTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DirtyKeySet.h"

#define TEST_DIRECTORY @"project-crystal-blue-dirty-key-test-dir"

@interface DirtyKeySetTests : XCTestCase

@end

@implementation DirtyKeySetTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

/// Check that we can add keys to the file.
- (void)testAddIndividualKeys
{
    int KEYS_TO_TEST = 100;
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *fullPath = [documentDirectory stringByAppendingFormat:@"/%@", TEST_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:fullPath
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:nil];
    
    // Check that the file gets created correctly.
    DirtyKeySet *dirtyKeySet = [[DirtyKeySet alloc] initInDirectory:TEST_DIRECTORY];
    NSString *expectedFilePath = [fullPath stringByAppendingFormat:@"/%@", [DirtyKeySet fileName]];
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePath]);
    XCTAssertTrue([dirtyKeySet  count] == 0);
    
    // Add a few items
    for (int i = 0; i < KEYS_TO_TEST; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%4d", i];
        [dirtyKeySet add:key];
        XCTAssertTrue([dirtyKeySet contains:key]);
    }
    
    XCTAssertEqual([dirtyKeySet count], (unsigned long)KEYS_TO_TEST);
    
    /// We'll initialize another DirtyKeySet. It should contain the same members if it loads the file correctly.
    DirtyKeySet *other = [[DirtyKeySet alloc] initInDirectory:TEST_DIRECTORY];
    
    XCTAssertEqual([other  count], [dirtyKeySet count]);
    
    for (int i = 0; i < KEYS_TO_TEST; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%4d", i];
        XCTAssertTrue([other contains:key]);
    }
    
    // Clean-up
    [fileManager removeItemAtPath:expectedFilePath error:nil];
    [fileManager removeItemAtPath:fullPath error:nil];
}

/// Check that we can remove keys from the file.
- (void)testAddAndRemoveIndividualKeys
{
    // Please use an even number for this test to avoid rounding issues when dividing the count in half.
    int KEYS_TO_TEST = 100;
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *fullPath = [documentDirectory stringByAppendingFormat:@"/%@", TEST_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:fullPath
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:nil];
    
    // Check that the file gets created correctly.
    DirtyKeySet *dirtyKeySet = [[DirtyKeySet alloc] initInDirectory:TEST_DIRECTORY];
    NSString *expectedFilePath = [fullPath stringByAppendingFormat:@"/%@", [DirtyKeySet fileName]];
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePath]);
    XCTAssertTrue([dirtyKeySet  count] == 0);
    
    // Add a few items
    for (int i = 0; i < KEYS_TO_TEST; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%4d", i];
        [dirtyKeySet add:key];
    }
    
    // Remove the even numbered ones
    for (int i = 0; i < KEYS_TO_TEST; i+=2) {
        NSString *key = [NSString stringWithFormat:@"KEY_%4d", i];
        [dirtyKeySet remove:key];
        XCTAssertFalse([dirtyKeySet contains:key]);
    }
    
    XCTAssertEqual([dirtyKeySet count], (unsigned long)(KEYS_TO_TEST / 2));
    
    // We'll initialize another DirtyKeySet. It should contain the same members if it loads the file correctly.
    DirtyKeySet *other = [[DirtyKeySet alloc] initInDirectory:TEST_DIRECTORY];
    
    XCTAssertEqual([other count], [dirtyKeySet count]);
    
    for (NSString *key in [dirtyKeySet allKeys]) {
        XCTAssertTrue([other contains:key]);
    }
    
    // Clean-up
    [fileManager removeItemAtPath:expectedFilePath error:nil];
    [fileManager removeItemAtPath:fullPath error:nil];
}

/**
 *  Similar to testAddIndividualKeys, but adds a huge number of keys.
 *  This has been tested up to 10 million lol
 */
- (void)testAddingAndLoadingLotsOfKeys
{
    int KEYS_TO_TEST = 5000;
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *fullPath = [documentDirectory stringByAppendingFormat:@"/%@", TEST_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:fullPath
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:nil];
    
    // Build the set of keys to add
    NSMutableSet *keys = [[NSMutableSet alloc] init];
    for (int i = 0; i < KEYS_TO_TEST; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%9d", i];
        [keys addObject:key];
    }
    
    DirtyKeySet *firstDirtyKeySet = [[DirtyKeySet alloc] initInDirectory:TEST_DIRECTORY];
    [firstDirtyKeySet addAll:keys];
    XCTAssertEqual([firstDirtyKeySet count], (unsigned long) KEYS_TO_TEST);
    
    // We'll initialize another DirtyKeySet. It should contain the same members if it loads the file correctly.
    DirtyKeySet *other = [[DirtyKeySet alloc] initInDirectory:TEST_DIRECTORY];
    
    XCTAssertEqual([other count], [firstDirtyKeySet count]);
    
    for (NSString *key in [firstDirtyKeySet allKeys]) {
        XCTAssertTrue([other contains:key]);
    }
    
    // Clean-up
    NSString *expectedFilePath = [fullPath stringByAppendingFormat:@"/%@", [DirtyKeySet fileName]];
    [fileManager removeItemAtPath:expectedFilePath error:nil];
    [fileManager removeItemAtPath:fullPath error:nil];
}

@end
