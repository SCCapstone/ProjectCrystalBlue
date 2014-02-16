//
//  PrimitiveProcedureTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AbstractLibraryObjectStore.h"
#import "LocalLibraryObjectStore.h"
#import "PrimitiveProcedures.h"
#import "SampleConstants.h"
#import "Sample.h"

#define TEST_DIR @"pcb-procedures-tests"
#define DATABASE_NAME @"procedures-test-db"
#define TEST_TABLE @"sample-procedures-test-table"

@interface PrimitiveProcedureTests : XCTestCase

@end

@implementation PrimitiveProcedureTests

LocalLibraryObjectStore *testStore;

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

// Simply clone a single sample object.
- (void)testCloneSample
{
    NSString *key = @"A_ROCK.001";
    Sample *s = [[Sample alloc] initWithKey:key
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    [testStore putLibraryObject:s IntoTable:TEST_TABLE];
    
    [PrimitiveProcedures cloneSample:s
                           intoStore:testStore
                      intoTableNamed:TEST_TABLE];
    
    NSString *expectedKey = @"A_ROCK.002";
    LibraryObject *clone = [testStore getLibraryObjectForKey:expectedKey FromTable:TEST_TABLE];
    
    XCTAssertNotNil(clone, @"No sample with expected key %@ was found!", expectedKey);
}



@end
