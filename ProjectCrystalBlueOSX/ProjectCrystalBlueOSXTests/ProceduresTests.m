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
#import "FileSystemUtils.h"
#import "LocalLibraryObjectStore.h"

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
                 initInLocalDirectory:[FileSystemUtils testDirectory]
                 WithDatabaseName:DATABASE_NAME];
}

- (void)tearDown
{
    [FileSystemUtils clearTestDirectory];

    [super tearDown];
}

- (void)testJawCrush
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures jawCrushSplit:s
                  withInitials:initials
                       inStore:testStore];
    
    LibraryObject *retrievedSplit = [testStore getLibraryObjectForKey:originalKey
                                                             FromTable:[SplitConstants tableName]];
    
    NSString *newRecords = [[retrievedSplit attributes] objectForKey:SPL_TAGS];
    NSArray *newRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    ProcedureRecord *expectedJawCrushRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_JAWCRUSH andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [newRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [newRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedJawCrushRecord,                   [newRecordArray objectAtIndex:2]);
}

@end
