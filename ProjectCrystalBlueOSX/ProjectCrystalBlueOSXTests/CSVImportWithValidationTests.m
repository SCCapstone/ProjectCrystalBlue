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
#import "Source.h"
#import "Sample.h"

@interface CSVImportWithValidationTests : XCTestCase <ImportResultReporter>

@end

@implementation CSVImportWithValidationTests

NSString* localDirectory;
ImportResult* importResult;
AbstractLibraryObjectStore *objectStore;
NSString *dbPath;
#define TEST_DIRECTORY @"csv-test-directory"
#define TEST_DB_NAME @"pcb-test-db"

- (void)setUp
{
    [super setUp];
    importResult = nil;
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    localDirectory = [documentDirectory stringByAppendingFormat:@"/%@", TEST_DIRECTORY];

    [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];

    objectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                       WithDatabaseName:TEST_DB_NAME];

    dbPath = [localDirectory stringByAppendingFormat:@"/%@", TEST_DB_NAME];
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:localDirectory error:nil];
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

    [importController fileSelector:nil didOpenFileAtPath:testPath];

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

    [importController fileSelector:nil didOpenFileAtPath:testPath];

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

    [importController fileSelector:nil didOpenFileAtPath:testPath];

    XCTAssertNotNil(importResult);
    XCTAssertFalse(importResult.hasError);
}

/// For ImportResultReporter protocol.
- (void)displayResults:(ImportResult *)result
{
    importResult = result;
}

@end
