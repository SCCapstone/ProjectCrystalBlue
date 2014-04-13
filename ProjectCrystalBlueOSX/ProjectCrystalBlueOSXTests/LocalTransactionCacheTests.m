//
//  LocalTransactionCacheTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocalTransactionCache.h"
#import "FileSystemUtils.h"

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
    [FileSystemUtils clearTestDirectory];
    [super tearDown];
}

/// Check that we can add transactions to the file.
- (void)testAddIndividualtransactions
{
    int TRANSACTION_COUNT = 100;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // Check that the file gets created correctly.
    LocalTransactionCache *transactions = [[LocalTransactionCache alloc] initInDirectory:[FileSystemUtils testDirectory]
                                                                           withFileName:FILE_NAME];
    NSString *expectedFilePath = [[FileSystemUtils testDirectory] stringByAppendingFormat:@"/%@", [transactions fileName]];
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
    LocalTransactionCache *otherTransactions = [[LocalTransactionCache alloc] initInDirectory:[FileSystemUtils testDirectory]
                                                                                 withFileName:FILE_NAME];
    
    XCTAssertEqual([otherTransactions count], [transactions count]);
    
    for (int i = 0; i < TRANSACTION_COUNT; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%4d", i];
        XCTAssertTrue([otherTransactions contains:key]);
    }

}

/// Check that we can remove transactions from the file.
- (void)testAddAndRemoveIndividualtransactions
{
    // Please use an even number for this test to avoid rounding issues when dividing the count in half.
    int TRANSACTION_COUNT = 100;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check that the file gets created correctly.
    LocalTransactionCache *cache = [[LocalTransactionCache alloc] initInDirectory:[FileSystemUtils testDirectory]
                                                                     withFileName:FILE_NAME];
    NSString *expectedFilePath = [[FileSystemUtils testDirectory] stringByAppendingFormat:@"/%@", [cache fileName]];
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
    LocalTransactionCache *other = [[LocalTransactionCache alloc] initInDirectory:[FileSystemUtils testDirectory]
                                                                     withFileName:FILE_NAME];
    XCTAssertEqual([other count], [cache count]);
    
    for (NSString *key in [cache allTransactions]) {
        XCTAssertTrue([other contains:key]);
    }
}

/**
 *  Similar to testAddIndividualTransactions, but adds a huge number of keys.
 *  This has been tested up to 10 million lol
 */
- (void)testAddingAndLoadingLotsOfTransactions
{
    int TRANSACTION_COUNT = 5000;
    
    // Build the set of keys to add
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for (int i = 0; i < TRANSACTION_COUNT; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY_%9d", i];
        [keys addObject:key];
    }
    
    LocalTransactionCache *firstCache = [[LocalTransactionCache alloc] initInDirectory:[FileSystemUtils testDirectory]
                                                                                withFileName:FILE_NAME];
    [firstCache addAll:keys];
    XCTAssertEqual([firstCache count], (unsigned long) TRANSACTION_COUNT);
    
    // We'll initialize another DirtyKeySet. It should contain the same members if it loads the file correctly.
    LocalTransactionCache *other = [[LocalTransactionCache alloc] initInDirectory:[FileSystemUtils testDirectory]
                                                                     withFileName:FILE_NAME];
    XCTAssertEqual([other count], [firstCache count]);
    
    for (NSString *key in [firstCache allTransactions]) {
        XCTAssertTrue([other contains:key]);
    }
}

/**
 *  Verifies that the transactions ordering is correct when saving and re-loading.
 */
- (void)testTransactionOrder
{
    int TRANSACTION_COUNT = 50;
    
    LocalTransactionCache *transactionCache = [[LocalTransactionCache alloc] initInDirectory:[FileSystemUtils testDirectory]
                                                                            withFileName:FILE_NAME];
    
    // We will use a mix of AddAll and individual adds.
    NSMutableArray *transactionArray1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < TRANSACTION_COUNT; ++i) {
        [transactionArray1 addObject:[NSString stringWithFormat:@"TRANSACTION%3d", i]];
    }
    [transactionCache addAll:transactionArray1];
    
    for (int i = TRANSACTION_COUNT; i < TRANSACTION_COUNT * 2; ++i) {
        [transactionCache add:[NSString stringWithFormat:@"TRANSACTION%3d", i]];
    }
    
    NSMutableArray *transactionArray2 = [[NSMutableArray alloc] init];
    for (int i = TRANSACTION_COUNT * 2; i < TRANSACTION_COUNT * 3; ++i) {
        [transactionArray2 addObject:[NSString stringWithFormat:@"TRANSACTION%3d", i]];
    }
    [transactionCache addAll:transactionArray2];
    
    // Check that elements are in the correct order
    NSOrderedSet *orderedSet = [transactionCache allTransactionsInOrder];
    for (int i = 0; i < TRANSACTION_COUNT * 3; ++i) {
        NSString *expectedValue = [NSString stringWithFormat:@"TRANSACTION%3d", i];
        XCTAssertTrue([[orderedSet objectAtIndex:i] isEqualToString:expectedValue]);
    }
    
    // Now we'll make a new transaction cache, created by reading from the file.
    transactionCache = nil;
    orderedSet = nil;
    
    transactionCache = [[LocalTransactionCache alloc] initInDirectory:[FileSystemUtils testDirectory]
                                                         withFileName:FILE_NAME];
    
    // Check that elements are in the correct order after reading from the file
    orderedSet = [transactionCache allTransactionsInOrder];
    for (int i = 0; i < TRANSACTION_COUNT * 3; ++i) {
        NSString *expectedValue = [NSString stringWithFormat:@"TRANSACTION%3d", i];
        XCTAssertTrue([[orderedSet objectAtIndex:i] isEqualToString:expectedValue]);
    }
}

@end
