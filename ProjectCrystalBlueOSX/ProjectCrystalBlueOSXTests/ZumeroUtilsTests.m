//
//  ZumeroUtilsTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/3/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZumeroUtils.h"

#define TEST_DATABASE_NAME @"test_zumero_db_that_doesnt_exist"
#define TEST_TABLE_NAME @"test_zumero_table_that_doesnt_exist"
#define TEST_DIRECTORY @"project-crystal-blue-temp-zumerotest"

@interface ZumeroUtilsTests : XCTestCase
{
    ZumeroDB *database;
}

@end

@implementation ZumeroUtilsTests

- (void)setUp
{
    [super setUp];
    
    // Make sure test database exists beforehand.
    database = [ZumeroUtils initializeZumeroDatabaseWithName:TEST_DATABASE_NAME
                                             AndWithDelegate:nil
                                       AndWithLocalDirectory:TEST_DIRECTORY];
}

- (void)tearDown
{
    [super tearDown];
    
    // Remove database file for test next time
    database = nil;
    [self deleteDatabaseFile:TEST_DATABASE_NAME];
}

/// Verify that a new and existing local zumero database can be initialized
- (void)testInitializeZumeroDatabase
{
    // Existing zumero database
    database = [ZumeroUtils initializeZumeroDatabaseWithName:TEST_DATABASE_NAME
                                             AndWithDelegate:nil
                                       AndWithLocalDirectory:TEST_DIRECTORY];
    XCTAssertNotNil(database, @"An error occurred when creating local database.");
    XCTAssertTrue([database exists], @"Database should exist.");
    
    // New zumero database
    ZumeroDB *newDB = [ZumeroUtils initializeZumeroDatabaseWithName:@"SOME_OTHER_DATABASE_NAME"
                                                    AndWithDelegate:nil
                                              AndWithLocalDirectory:TEST_DIRECTORY];
    XCTAssertNotNil(newDB, @"An error occurred when creating local database.");
    XCTAssertTrue([newDB exists], @"Database should exist.");
    
    // Remove database file for test next time
    newDB = nil;
    [self deleteDatabaseFile:@"SOME_OTHER_DATABASE_NAME"];
}

/// Verify that starting and finishing transactions open and close the database correctly
- (void)testZumeroTransactionStates
{
    BOOL ok;
    
    // Starting a transaction
    ok = [ZumeroUtils startZumeroTransactionUsingDatabase:database];
    XCTAssertTrue(ok, @"startZumeroTransactionUsingDatabase: method failed.");
    XCTAssertTrue([database isOpen], @"Zumero database should be open.");
    
    ok = [ZumeroUtils finishZumeroTransactionUsingDatabase:database];
    XCTAssertTrue(ok, @"finishZumeroTransactionUsingDatabase: method failed.");
    XCTAssertFalse([database isOpen], @"Zumero database should not be open.");
}

/// Verify that creating a new and existing table works as expected
- (void)testCreateZumeroTable
{
    NSDictionary *tableFields =
    @{
      @"key": @{@"type": @"text", @"not_null": [NSNumber numberWithBool:YES], @"primary_key": [NSNumber numberWithBool:YES]},
      @"lithology": @{@"type": @"text"}
      };
    BOOL ok;
    
    // New zumero table
    ok = [ZumeroUtils createZumeroTableWithName:TEST_TABLE_NAME AndFields:tableFields UsingDatabase:database];
    XCTAssertTrue(ok, @"createZumeroTableWithName: method failed.");
    [database open:nil];
    XCTAssertTrue([database tableExists:TEST_TABLE_NAME], @"Test table should exist.");
    [database close];
    
    // Existing zumero table
    ok = [ZumeroUtils createZumeroTableWithName:TEST_TABLE_NAME AndFields:tableFields UsingDatabase:database];
    XCTAssertTrue(ok, @"createZumeroTableWithName: method failed.");
    [database open:nil];
    XCTAssertTrue([database tableExists:TEST_TABLE_NAME], @"Test table should exist.");
    [database close];
}

// Verify that existing and non-existing tables check correctly.
- (void)testZumeroTableExists
{
    NSDictionary *tableFields =
    @{
      @"key": @{@"type": @"text", @"not_null": [NSNumber numberWithBool:YES], @"primary_key": [NSNumber numberWithBool:YES]},
      @"lithology": @{@"type": @"text"}
      };
    BOOL exists;
    
    // Non-existent table
    exists = [ZumeroUtils zumeroTableExistsWithName:TEST_TABLE_NAME UsingDatabase:database];
    XCTAssertFalse(exists, @"Zumero table should not exist.");
    
    // Existing table
    [ZumeroUtils createZumeroTableWithName:TEST_TABLE_NAME AndFields:tableFields UsingDatabase:database];
    exists = [ZumeroUtils zumeroTableExistsWithName:TEST_TABLE_NAME UsingDatabase:database];
    XCTAssertTrue(exists, @"Zumero table should exist.");
}

/// Delete database file in the test directory
- (void)deleteDatabaseFile:(NSString *)databaseName
{
    NSError *error = nil;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *databasePath = [[documentsDirectory stringByAppendingPathComponent:TEST_DIRECTORY]
                              stringByAppendingPathComponent:databaseName];
    [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&error];
    XCTAssertNil(error, @"Error removing database file.");
}

@end
