//
//  CSVImportWithValidationTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LibraryObjectCSVReader.h"
#import "LibraryObjectImportController.h"
#import "AbstractLibraryObjectStore.h"
#import "LocalLibraryObjectStore.h"
#import "SourceImportController.h"
#import "SampleImportController.h"
#import "FileSystemUtils.h"
#import "Source.h"
#import "Sample.h"
#import "TestingUtils.h"

@interface CSVImportWithValidationTests : XCTestCase <ImportResultReporter>

@end

@implementation CSVImportWithValidationTests

NSString* localDirectory;
ImportResult* importResult;
AbstractLibraryObjectStore *objectStore;
NSString *dbPath;
#define TEST_DB_NAME @"pcb-test-db"

- (void)setUp
{
    [super setUp];
    importResult = nil;

    localDirectory = [FileSystemUtils testDirectory];
    objectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:localDirectory
                                                       WithDatabaseName:TEST_DB_NAME];

    dbPath = [localDirectory stringByAppendingFormat:@"/%@", TEST_DB_NAME];
}

- (void)tearDown
{
    [FileSystemUtils clearTestDirectory];
    [super tearDown];
}

- (void)testSourcesNoErrors
{
    NSString *testFile = @"sources_ok";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];

    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    LibraryObjectImportController *importController = [[SourceImportController alloc] init];
    [importController setFileReader:reader];
    [importController setImportResultReporter:self];
    [importController setLibraryObjectStore:objectStore];
    [importController setTableName:[SourceConstants tableName]];

    [importController fileSelectorDidOpenFileAtPath:testPath];

    [TestingUtils busyWaitForSeconds:0.5f];

    XCTAssertNotNil(importResult);
    XCTAssertFalse(importResult.hasError);
}

- (void)testSamplesNoErrors
{
    NSString *testFile = @"samples_ok";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];

    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    LibraryObjectImportController *importController = [[SampleImportController alloc] init];
    [importController setFileReader:reader];
    [importController setImportResultReporter:self];
    [importController setLibraryObjectStore:objectStore];
    [importController setTableName:[SampleConstants tableName]];

    [importController fileSelectorDidOpenFileAtPath:testPath];

    [TestingUtils busyWaitForSeconds:0.5f];

    XCTAssertNotNil(importResult);
    XCTAssertFalse(importResult.hasError);
}

- (void)testSourcesNoDates
{
    NSString *testFile = @"sources_missing_dates";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];

    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    LibraryObjectImportController *importController = [[SourceImportController alloc] init];
    [importController setFileReader:reader];
    [importController setImportResultReporter:self];
    [importController setLibraryObjectStore:objectStore];
    [importController setTableName:[SourceConstants tableName]];

    [importController fileSelectorDidOpenFileAtPath:testPath];

    [TestingUtils busyWaitForSeconds:0.5f];

    XCTAssertNotNil(importResult);
    XCTAssertFalse(importResult.hasError);
}

/// For ImportResultReporter protocol.
- (void)displayResults:(ImportResult *)result
{
    importResult = result;
}

@end