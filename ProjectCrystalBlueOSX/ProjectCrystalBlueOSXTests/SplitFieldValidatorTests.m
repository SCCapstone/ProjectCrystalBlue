//
//  SplitFieldValidatorTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SplitFieldValidator.h"
#import "ValidationResponse.h"
#import "LocalLibraryObjectStore.h"
#import "FileSystemUtils.h"
#import "Split.h"

#define DATABASE_NAME @"test_database.db"

@interface SplitFieldValidatorTests : XCTestCase

@end

@implementation SplitFieldValidatorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    [FileSystemUtils clearTestDirectory];
    [super tearDown];
}

- (void)testCurrentLocation
{
    NSString *valid = @"Basement #12.02";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SplitFieldValidator validateCurrentLocation:valid] isValid]);
    XCTAssertFalse([[SplitFieldValidator validateCurrentLocation:tooLong] isValid]);
}

- (void)testValidateSplitKey
{
    NSString *valid = @"my sample.001";
    NSString *keyNotUnique = @"This key already exists.001";
    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }
    
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                                 WithDatabaseName:DATABASE_NAME];
    
    Split *split = [[Split alloc] initWithKey:keyNotUnique
                                   AndWithValues:[SplitConstants attributeDefaultValues]];
    [dataStore putLibraryObject:split IntoTable:[SplitConstants tableName]];

    XCTAssertTrue([[SplitFieldValidator validateSplitKey:valid WithDataStore:dataStore] isValid]);
    
    XCTAssertFalse([[SplitFieldValidator validateSplitKey:keyNotUnique WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SplitFieldValidator validateSplitKey:tooShort WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SplitFieldValidator validateSplitKey:tooLong WithDataStore:dataStore] isValid]);
}

@end
