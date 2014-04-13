//
//  TransactionStoreTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TransactionStore.h"
#import "FileSystemUtils.h"

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
    [FileSystemUtils clearTestDirectory];
    
    [super tearDown];
}

- (void)testCommitInvalidSqlCommand
{
    TransactionStore *transactionStore = [[TransactionStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                       WithDatabaseName:DATABASE_NAME];
    // Get is not a transaction we want to store
    Transaction *getTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"GET"];
    XCTAssertFalse([transactionStore commitTransaction:getTransaction], @"TransactionStore should not commit a get sql command.");
    
    // Make sure transaction store is empty
    NSArray *transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned an empty transaction list.");
    XCTAssertEqual([transactions count], 0ul, @"TransactionStore should be empty.");
}

- (void)testLastSyncTime
{
    TransactionStore *transactionStore = [[TransactionStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
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

- (void)testGetTransactionFromKey
{
    TransactionStore *transactionStore = [[TransactionStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                       WithDatabaseName:DATABASE_NAME];
    // Initialize some transaction objects
    Transaction *putTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"PUT"];
    XCTAssertTrue([transactionStore commitTransaction:putTransaction], @"TransactionStore failed to commit the transaction.");
    
    Transaction *retrievedTransaction = [transactionStore getTransactionWithLibraryObjectKey:[putTransaction.attributes objectForKey:TRN_LIBRARY_OBJECT_KEY]];
    XCTAssertNotNil(retrievedTransaction, @"TransactionStore failed to retrieve the transaction.");
    XCTAssertEqualObjects(putTransaction, retrievedTransaction, @"The two objects are not equal!");
}

- (void)testOptimizeTransaction
{
    TransactionStore *transactionStore = [[TransactionStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                       WithDatabaseName:DATABASE_NAME];
    // Initialize some transaction objects
    Transaction *putTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"PUT"];
    Transaction *updateTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"UPDATE"];
    Transaction *updateTransaction2 = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"UPDATE"];
    Transaction *deleteTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"DELETE"];
    
    // PUT + UPDATE -> PUT
    XCTAssertTrue([transactionStore commitTransaction:putTransaction], @"TransactionStore failed to commit the transaction.");
    XCTAssertTrue([transactionStore commitTransaction:updateTransaction], @"TransactionStore failed to commit the transaction.");
    NSArray *transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned a valid transaction list.");
    XCTAssertEqual([transactions count], 1ul, @"TransactionStore should contain 1 transaction.");
    XCTAssertTrue([transactions containsObject:putTransaction], @"The put transaction should have been returned.");
    
    // PUT + DELETE -> None
    XCTAssertTrue([transactionStore commitTransaction:deleteTransaction], @"TransactionStore failed to commit the transaction.");
    transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned a valid transaction list.");
    XCTAssertEqual([transactions count], 0ul, @"TransactionStore should contain 1 transaction.");
    
    // UPDATE1 + UPDATE2 -> UPDATE2
    XCTAssertTrue([transactionStore commitTransaction:updateTransaction], @"TransactionStore failed to commit the transaction.");
    XCTAssertTrue([transactionStore commitTransaction:updateTransaction2], @"TransactionStore failed to commit the transaction.");
    transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned a valid transaction list.");
    XCTAssertEqual([transactions count], 1ul, @"TransactionStore should contain 1 transaction.");
    XCTAssertTrue([transactions containsObject:updateTransaction2], @"The update2 transaction should have been returned.");
    
    // UPDATE2 + DELETE -> DELETE
    XCTAssertTrue([transactionStore commitTransaction:deleteTransaction], @"TransactionStore failed to commit the transaction.");
    transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned a valid transaction list.");
    XCTAssertEqual([transactions count], 1ul, @"TransactionStore should contain 1 transaction.");
    XCTAssertTrue([transactions containsObject:deleteTransaction], @"The delete transaction should have been returned.");
}

- (void)testGetCommitAndClearTransactions
{
    TransactionStore *transactionStore = [[TransactionStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                       WithDatabaseName:DATABASE_NAME];
    // Make sure transaction store is empty
    NSArray *transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned an empty transaction list.");
    XCTAssertEqual([transactions count], 0ul, @"TransactionStore should be empty.");
    
    // Initialize some transaction objects
    Transaction *putTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"PUT"];
    Transaction *updateTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"UPDATE"];
    Transaction *deleteTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"DELETE"];
    Transaction *getTransaction = [[Transaction alloc] initWithLibraryObjectKey:@"uniqueKey" AndWithTableName:@"tableName" AndWithSqlCommandType:@"GET"];
    
    // Commit the transactions to the store
    XCTAssertTrue([transactionStore commitTransaction:putTransaction], @"TransactionStore failed to commit the transaction.");
    XCTAssertTrue([transactionStore commitTransaction:updateTransaction], @"TransactionStore failed to commit the transaction.");
    XCTAssertTrue([transactionStore commitTransaction:deleteTransaction], @"TransactionStore failed to commit the transaction.");
    XCTAssertFalse([transactionStore commitTransaction:getTransaction], @"TransactionStore should not commit a get sql command.");
    
    // Get all the transactions and make sure they exist and they were optimized correctly
    transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned a valid transaction list.");
    XCTAssertEqual([transactions count], 0ul, @"TransactionStore should contain 2 transactions.");
    
    // Clear the TransactionStore
    XCTAssertTrue([transactionStore clearLocalTransactions], @"TransactionStore failed to clear the local transactions.");
    transactions = [transactionStore getAllTransactions];
    XCTAssertNotNil(transactions, @"TransactionStore should have returned an empty transaction list.");
    XCTAssertEqual([transactions count], 0ul, @"TransactionStore should be empty.");
}

@end
