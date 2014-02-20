//
//  ProceduresTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Procedures.h"
#import "ProcedureNameConstants.h"
#import "ProcedureRecordParser.h"
#import "ProcedureRecord.h"
#import "AbstractLibraryObjectStore.h"
#import "LocalLibraryObjectStore.h"

#define TEST_DIR @"pcb-procedures-tests"
#define DATABASE_NAME @"procedures-test-db"

@interface ProceduresTests : XCTestCase

@end

@implementation ProceduresTests

AbstractLibraryObjectStore *testStore;

- (void)setUp
{
    [super setUp];
    
    // Set up a test table
    testStore = [[LocalLibraryObjectStore alloc]
                 initInLocalDirectory:TEST_DIR
                 WithDatabaseName:DATABASE_NAME];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    // Remove test store
    NSError *error = nil;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *databasePath = [[documentsDirectory stringByAppendingPathComponent:TEST_DIR]
                              stringByAppendingPathComponent:DATABASE_NAME];
    [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&error];
    XCTAssertNil(error, @"Error removing database file!");
}

- (void)testJawCrush
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures jawCrushSample:s
                  withInitials:initials
                       inStore:testStore];
    
    LibraryObject *retrievedSample = [testStore getLibraryObjectForKey:originalKey
                                                             FromTable:[SampleConstants tableName]];
    
    NSString *newRecords = [[retrievedSample attributes] objectForKey:SMP_TAGS];
    NSArray *newRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    ProcedureRecord *expectedJawCrushRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_JAWCRUSH andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [newRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [newRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedJawCrushRecord,                   [newRecordArray objectAtIndex:2]);
}

@end
