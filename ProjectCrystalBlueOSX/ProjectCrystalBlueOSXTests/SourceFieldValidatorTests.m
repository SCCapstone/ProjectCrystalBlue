//
//  SourceFieldValidatorTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SourceFieldValidator.h"
#import "ValidationResponse.h"
#import "LocalLibraryObjectStore.h"
#import "Source.h"

#define TEST_DIRECTORY @"project-crystal-blue-test-temp"
#define DATABASE_NAME @"test_database.db"

@interface SourceFieldValidatorTests : XCTestCase

@end

@implementation SourceFieldValidatorTests

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

- (void)testValidateSourceKey
{
    NSString *validKey = @"This is an valid key 1234";
    NSString *keyNotUnique = @"This already exists";
    NSString *invalidChars1 = @"Underscores_must_not_allowed_in_keys";
    NSString *invalidChars2 = @"Neither.Can.Periods";

    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }
    
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                 WithDatabaseName:DATABASE_NAME];
    
    Source *source = [[Source alloc] initWithKey:keyNotUnique
                                   AndWithValues:[SourceConstants attributeDefaultValues]];
    [dataStore putLibraryObject:source IntoTable:[SourceConstants tableName]];
    

    XCTAssertTrue([[SourceFieldValidator validateSourceKey:validKey WithDataStore:dataStore] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateSourceKey:keyNotUnique WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSourceKey:invalidChars1 WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSourceKey:invalidChars2 WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSourceKey:tooShort WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSourceKey:tooLong WithDataStore:dataStore] isValid]);
}

- (void)testValidateContinent
{
    NSString *valid = @"North America";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateContinent:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateContinent:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateContinent:tooLong] isValid]);
}

- (void)testValidateFormation
{
    NSString *valid = @"Some Formation Somewhere 2";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateFormation:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateFormation:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateFormation:tooLong] isValid]);
}

- (void)testValidateMember
{
    NSString *valid = @"a member 15";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateMember:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateMember:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateMember:tooLong] isValid]);
}

- (void)testValidateGroup
{
    NSString *emptyStr = @"";
    NSString *valid = @"a new start 2222";
    NSString *invalid = @".";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue( [[SourceFieldValidator validateGroup:emptyStr]   isValid]);
    XCTAssertTrue( [[SourceFieldValidator validateGroup:valid]      isValid]);
    XCTAssertFalse([[SourceFieldValidator validateGroup:invalid]    isValid]);
    XCTAssertFalse([[SourceFieldValidator validateGroup:tooLong]    isValid]);
}

- (void)testValidateType
{
    NSString *emptyStr = @"";
    NSString *valid = @"a new start 2222";
    NSString *invalid = @".";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue( [[SourceFieldValidator validateType:emptyStr]   isValid]);
    XCTAssertTrue( [[SourceFieldValidator validateType:valid]      isValid]);
    XCTAssertFalse([[SourceFieldValidator validateType:invalid]    isValid]);
    XCTAssertFalse([[SourceFieldValidator validateType:tooLong]    isValid]);
}

- (void)testValidateDeposystem
{
    NSString *emptyStr = @"";
    NSString *valid = @"a new start 2222";
    NSString *invalid = @".";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue( [[SourceFieldValidator validateDeposystem:emptyStr]   isValid]);
    XCTAssertTrue( [[SourceFieldValidator validateDeposystem:valid]      isValid]);
    XCTAssertFalse([[SourceFieldValidator validateDeposystem:invalid]    isValid]);
    XCTAssertFalse([[SourceFieldValidator validateDeposystem:tooLong]    isValid]);
}

- (void)testValidateRegion
{
    NSString *valid = @"region north 1";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateRegion:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateRegion:invalid]   isValid]);
    XCTAssertFalse([[SourceFieldValidator validateRegion:tooLong]   isValid]);
}

- (void)testValidateSection
{
    NSString *valid = @"section 42 ";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateSection:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateSection:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSection:tooLong] isValid]);
}

- (void)testValidateMeters
{
    NSString *positive = @"99.99";
    NSString *zero = @"0";
    NSString *negative = @"-99.99";
    NSString *invalid = @"12gkjla";

    XCTAssertTrue([[SourceFieldValidator validateMeters:positive] isValid]);
    XCTAssertTrue([[SourceFieldValidator validateMeters:zero] isValid]);
    XCTAssertTrue([[SourceFieldValidator validateMeters:negative] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateMeters:invalid] isValid]);
}

- (void)testValidateLatitude
{
    NSString *positive = @"99.99";
    NSString *zero = @"0";
    NSString *negative = @"-99.99";
    NSString *invalid = @"12gkjla";

    XCTAssertTrue([[SourceFieldValidator validateLatitude:positive] isValid]);
    XCTAssertTrue([[SourceFieldValidator validateLatitude:zero] isValid]);
    XCTAssertTrue([[SourceFieldValidator validateLatitude:negative] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateLatitude:invalid] isValid]);
}

- (void)testValidateLongitude
{
    NSString *positive = @"99.99";
    NSString *zero = @"0";
    NSString *negative = @"-99.99";
    NSString *invalid = @"12gkjla";

    XCTAssertTrue([[SourceFieldValidator validateLongitude:positive] isValid]);
    XCTAssertTrue([[SourceFieldValidator validateLongitude:zero] isValid]);
    XCTAssertTrue([[SourceFieldValidator validateLongitude:negative] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateLongitude:invalid] isValid]);
}

- (void)testValidateAge
{
    NSTimeInterval unixTime = NSTimeIntervalSince1970;
    NSString *unixTimeInString = [NSString stringWithFormat:@"%f", unixTime];

    XCTAssertTrue([[SourceFieldValidator validateAge:unixTimeInString] isValid]);
}

- (void)testValidateDateCollected
{
    NSTimeInterval unixTime = NSTimeIntervalSince1970;
    NSString *unixTimeInString = [NSString stringWithFormat:@"%f", unixTime];

    XCTAssertTrue([[SourceFieldValidator validateDateCollected:unixTimeInString] isValid]);
}

- (void)testValidateNotes
{
    NSString *validNotes = @"These notes are valid";
    NSString *emptyStr = @"";

    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 2001; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateNotes:validNotes] isValid]);
    XCTAssertTrue([[SourceFieldValidator validateNotes:emptyStr] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateNotes:tooLong] isValid]);
}

- (void)testValidateHyperlinks
{
    NSString *validLinks = @"http://www.test.com,http://www.test.com";
    NSString *emptyStr = @"";

    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 2001; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateNotes:validLinks] isValid]);
    XCTAssertTrue([[SourceFieldValidator validateNotes:emptyStr] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateNotes:tooLong] isValid]);
}


@end
