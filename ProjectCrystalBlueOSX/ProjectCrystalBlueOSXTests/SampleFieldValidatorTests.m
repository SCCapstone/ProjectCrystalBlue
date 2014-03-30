//
//  SampleFieldValidatorTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SampleFieldValidator.h"
#import "ValidationResponse.h"
#import "LocalLibraryObjectStore.h"
#import "Sample.h"

#define TEST_DIRECTORY @"project-crystal-blue-test-temp"
#define DATABASE_NAME @"test_database.db"

@interface SampleFieldValidatorTests : XCTestCase

@end

@implementation SampleFieldValidatorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCurrentLocation
{
    NSString *valid = @"Basement #12.02";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SampleFieldValidator validateCurrentLocation:valid] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateCurrentLocation:tooLong] isValid]);
}

- (void)testValidateSampleKey
{
    NSString *valid = @"my source.001";
    NSString *keyNotUnique = @"This key already exists.001";
    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }
    
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                 WithDatabaseName:DATABASE_NAME];
    
    Sample *sample = [[Sample alloc] initWithKey:keyNotUnique
                                   AndWithValues:[SampleConstants attributeDefaultValues]];
    [dataStore putLibraryObject:sample IntoTable:[SampleConstants tableName]];

    XCTAssertTrue([[SampleFieldValidator validateSampleKey:valid WithDataStore:dataStore] isValid]);
    
    XCTAssertFalse([[SampleFieldValidator validateSampleKey:keyNotUnique WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateSampleKey:tooShort WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateSampleKey:tooLong WithDataStore:dataStore] isValid]);
}

@end
