//
//  TransactionStoreTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TransactionStore.h"

#define TEST_DIRECTORY @"project-crystal-blue-test-temp"
#define DATABASE_NAME @"test_database.db"

@interface TransactionStoreTests : XCTestCase

@end

@implementation TransactionStoreTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Delete the test_database.db file after each test
    NSError *error = nil;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *databasePath = [[documentsDirectory stringByAppendingPathComponent:TEST_DIRECTORY]
                              stringByAppendingPathComponent:DATABASE_NAME];
    [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&error];
    XCTAssertNil(error, @"Error removing database file!");
    
    [super tearDown];
}

- (void)testCommitInvalidSqlCommand
{
    TransactionStore *transactionStore = [[TransactionStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                       WithDatabaseName:DATABASE_NAME];
    // Get is not a transaction we want to store
    Transaction *getTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithSqlCommandType:@"GET"];
    XCTAssertFalse([transactionStore commitTransaction:getTransaction], @"TransactionStore should not commit a get sql command.");
    
    // Make sure transaction store is empty
    NSArray *transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned the transaction list.");
    XCTAssertEqual([transactions count], 1ul, @"TransactionStore should only contain last sync time transaction.");
}

- (void)testLastSyncTime
{
    TransactionStore *transactionStore = [[TransactionStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                       WithDatabaseName:DATABASE_NAME];
    // Get last sync time from database
    NSTimeInterval lastSyncTime = [transactionStore timeOfLastSync];
    
    // Make sure the lastSyncTime is before the current time
    NSTimeInterval now = [[[NSDate alloc] init] timeIntervalSince1970];
    XCTAssertTrue(lastSyncTime < now, @"The last sync time should be earlier than the current time.");
    
    // Clear the database (to update the lastSyncTime)
    [transactionStore clearLocalTransactions];
    lastSyncTime = [transactionStore timeOfLastSync];
    
    // Make sure the lastSyncTime is later than now
    XCTAssertTrue(lastSyncTime > now, @"The last sync time should be earlier than the current time.");
}

- (void)testGetCommitAndClearTransactions
{
    TransactionStore *transactionStore = [[TransactionStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                       WithDatabaseName:DATABASE_NAME];
    // Make sure transaction store is empty
    NSArray *transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned the transaction list.");
    XCTAssertEqual([transactions count], 1ul, @"TransactionStore should only contain last sync time transaction.");
    
    // Initialize some transaction objects
    Transaction *putTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithSqlCommandType:@"PUT"];
    Transaction *updateTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithSqlCommandType:@"UPDATE"];
    Transaction *deleteTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithSqlCommandType:@"DELETE"];
    Transaction *getTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithSqlCommandType:@"GET"];
    
    // Commit the transactions to the store
    XCTAssertTrue([transactionStore commitTransaction:putTransaction], @"TransactionStore failed to commit the transaction.");
    XCTAssertTrue([transactionStore commitTransaction:updateTransaction], @"TransactionStore failed to commit the transaction.");
    XCTAssertTrue([transactionStore commitTransaction:deleteTransaction], @"TransactionStore failed to commit the transaction.");
    XCTAssertFalse([transactionStore commitTransaction:getTransaction], @"TransactionStore should not commit a get sql command.");
    
    // Get all the transactions and make sure they exist and they were optimized correctly
    transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned a valid transaction list.");
    XCTAssertEqual([transactions count], 3ul, @"TransactionStore should contain 3 transactions.");
    XCTAssertTrue([transactions containsObject:putTransaction], @"The put transaction should have been returned.");
    XCTAssertFalse([transactions containsObject:updateTransaction], @"The update transaction should have been overwritten by the delete transaction.");
    XCTAssertTrue([transactions containsObject:deleteTransaction], @"The delete transaction should have been returned.");
    XCTAssertFalse([transactions containsObject:getTransaction], @"The get transaction should have never been committed.");
    
    // Clear the TransactionStore
    XCTAssertTrue([transactionStore clearLocalTransactions], @"TransactionStore failed to clear the local transactions.");
    transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned the transaction list.");
    XCTAssertEqual([transactions count], 1ul, @"TransactionStore should only contain last sync time transaction.");
}

@end
