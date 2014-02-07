//
//  LocalTransactionCacheTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocalTransactionCache.h"

#define TEST_DIRECTORY @"project-crystal-blue-local-trnsctn-cache-test-dir"
#define FILE_NAME @"transaction_cache.txt"

@interface LocalTransactionCacheTests : XCTestCase

@end

@implementation LocalTransactionCacheTests

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

/// Check that we can add transactions to the file.
- (void)testAddIndividualtransactions
{
    int TRANSACTION_COUNT = 100;
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *fullPath = [documentDirectory stringByAppendingFormat:@"/%@", TEST_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:fullPath
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:nil];
    
    // Check that the file gets created correctly.
    LocalTransactionCache *transactions = [[LocalTransactionCache alloc] initInDirectory:TEST_DIRECTORY
                                                                           withFileName:FILE_NAME];
    NSString *expectedFilePath = [fullPath stringByAppendingFormat:@"/%@", [transactions fileName]];
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePath]);
    XCTAssertTrue([transactions count] == 0);
    
    // Add a few items
    for (int i = 0; i < TRANSACTION_COUNT; ++i) {
        NSString *transaction = [NSString stringWithFormat:@"KEY_%4d", i];
        [transactions add:transaction];
        XCTAssertTrue([transactions contains:transaction]);
    }
    
    XCTAssertEqual([transactions count], (unsigned long)TRANSACTION_COUNT);
    
    /// We'll initialize another LocalTransactionCache. It should contain the same members if it loads the file correctly.
    LocalTransactionCache *otherTransactions = [[LocalTransactionCache alloc] initInDirectory:TEST_DIRECTORY
                                                                                 withFileName:FILE_NAME];
    
    XCTAssertEqual([otherTransactions count], [transactions count]);
    
    for (int i = 0; i < TRANSACTION_COUNT; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%4d", i];
        XCTAssertTrue([otherTransactions contains:key]);
    }
    
    // Clean-up
    [fileManager removeItemAtPath:expectedFilePath error:nil];
    [fileManager removeItemAtPath:fullPath error:nil];
}

/// Check that we can remove transactions from the file.
- (void)testAddAndRemoveIndividualtransactions
{
    // Please use an even number for this test to avoid rounding issues when dividing the count in half.
    int TRANSACTION_COUNT = 100;
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *fullPath = [documentDirectory stringByAppendingFormat:@"/%@", TEST_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:fullPath
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:nil];
    
    // Check that the file gets created correctly.
    LocalTransactionCache *cache = [[LocalTransactionCache alloc] initInDirectory:TEST_DIRECTORY
                                                                           withFileName:FILE_NAME];
    NSString *expectedFilePath = [fullPath stringByAppendingFormat:@"/%@", [cache fileName]];
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePath]);
    XCTAssertTrue([cache count] == 0);
    
    // Add a few items
    for (int i = 0; i < TRANSACTION_COUNT; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%4d", i];
        [cache add:key];
    }
    
    // Remove the even numbered ones
    for (int i = 0; i < TRANSACTION_COUNT; i+=2) {
        NSString *key = [NSString stringWithFormat:@"KEY_%4d", i];
        [cache remove:key];
        XCTAssertFalse([cache contains:key]);
    }
    
    XCTAssertEqual([cache count], (unsigned long)(TRANSACTION_COUNT / 2));
    
    // We'll initialize another LocalTransactionCache. It should contain the same members if it loads the file correctly.
    LocalTransactionCache *other = [[LocalTransactionCache alloc] initInDirectory:TEST_DIRECTORY
                                                                     withFileName:FILE_NAME];
    XCTAssertEqual([other count], [cache count]);
    
    for (NSString *key in [cache allTransactions]) {
        XCTAssertTrue([other contains:key]);
    }
    
    // Clean-up
    [fileManager removeItemAtPath:expectedFilePath error:nil];
    [fileManager removeItemAtPath:fullPath error:nil];
}

/**
 *  Similar to testAddIndividualTransactions, but adds a huge number of keys.
 *  This has been tested up to 10 million lol
 */
- (void)testAddingAndLoadingLotsOfTransactions
{
    int TRANSACTION_COUNT = 5000;
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *fullPath = [documentDirectory stringByAppendingFormat:@"/%@", TEST_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:fullPath
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:nil];
    
    // Build the set of keys to add
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for (int i = 0; i < TRANSACTION_COUNT; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%9d", i];
        [keys addObject:key];
    }
    
    LocalTransactionCache *firstCache = [[LocalTransactionCache alloc] initInDirectory:TEST_DIRECTORY
                                                                                withFileName:FILE_NAME];
    [firstCache addAll:keys];
    XCTAssertEqual([firstCache count], (unsigned long) TRANSACTION_COUNT);
    
    // We'll initialize another DirtyKeySet. It should contain the same members if it loads the file correctly.
    LocalTransactionCache *other = [[LocalTransactionCache alloc] initInDirectory:TEST_DIRECTORY
                                                                     withFileName:FILE_NAME];
    XCTAssertEqual([other count], [firstCache count]);
    
    for (NSString *key in [firstCache allTransactions]) {
        XCTAssertTrue([other contains:key]);
    }
    
    // Clean-up
    NSString *expectedFilePath = [fullPath stringByAppendingFormat:@"/%@", [firstCache fileName]];
    [fileManager removeItemAtPath:expectedFilePath error:nil];
    [fileManager removeItemAtPath:fullPath error:nil];
}

@end
