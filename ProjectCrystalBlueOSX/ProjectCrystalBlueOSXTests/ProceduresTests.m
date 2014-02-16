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
#import "ProcedureTagDecoder.h"
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    NSString *originalTags = @"TAG01, TAG02";
    NSArray *originalTagArray = [ProcedureTagDecoder tagArrayFromCommaSeparatedTagString:originalTags];
    
    [s.attributes setValue:originalTags forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures jawCrushSample:s
                       inStore:testStore];
    
    LibraryObject *retrievedSample = [testStore getLibraryObjectForKey:originalKey
                                                             FromTable:[SampleConstants tableName]];
    
    NSString *newTags = [[retrievedSample attributes] objectForKey:SMP_TAGS];
    NSArray *newTagArray = [ProcedureTagDecoder tagArrayFromCommaSeparatedTagString:newTags];
    
    XCTAssertEqualObjects([originalTagArray objectAtIndex:0],  [newTagArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalTagArray objectAtIndex:1],  [newTagArray objectAtIndex:1]);
    XCTAssertEqualObjects(PROC_TAG_JAWCRUSH,                   [newTagArray objectAtIndex:2]);
}

@end
