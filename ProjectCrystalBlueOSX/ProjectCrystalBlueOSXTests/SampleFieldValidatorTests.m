//
//  SampleFieldValidatorTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SampleFieldValidator.h"
#import "ValidationResponse.h"
#import "LocalLibraryObjectStore.h"
#import "FileSystemUtils.h"
#import "Sample.h"

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
    [FileSystemUtils clearTestDirectory];
    [super tearDown];
}

- (void)testValidateSampleKey
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
    
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                                 WithDatabaseName:DATABASE_NAME];
    
    Sample *sample = [[Sample alloc] initWithKey:keyNotUnique
                                   AndWithValues:[SampleConstants attributeDefaultValues]];
    [dataStore putLibraryObject:sample IntoTable:[SampleConstants tableName]];
    

    XCTAssertTrue([[SampleFieldValidator validateSampleKey:validKey WithDataStore:dataStore] isValid]);

    XCTAssertFalse([[SampleFieldValidator validateSampleKey:keyNotUnique WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateSampleKey:invalidChars1 WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateSampleKey:invalidChars2 WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateSampleKey:tooShort WithDataStore:dataStore] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateSampleKey:tooLong WithDataStore:dataStore] isValid]);
}

- (void)testValidateContinent
{
    NSString *valid = @"North America";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SampleFieldValidator validateContinent:valid] isValid]);

    XCTAssertFalse([[SampleFieldValidator validateContinent:invalid] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateContinent:tooLong] isValid]);
}

- (void)testValidateFormation
{
    NSString *valid = @"Some Formation Somewhere 2";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SampleFieldValidator validateFormation:valid] isValid]);

    XCTAssertFalse([[SampleFieldValidator validateFormation:invalid] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateFormation:tooLong] isValid]);
}

- (void)testValidateMember
{
    NSString *valid = @"a member 15";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SampleFieldValidator validateMember:valid] isValid]);

    XCTAssertFalse([[SampleFieldValidator validateMember:invalid] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateMember:tooLong] isValid]);
}

- (void)testValidateGroup
{
    NSString *emptyStr = @"";
    NSString *valid = @"a new start 2222";
    NSString *punctuation = @"._-/";
    NSString *singleQuote = @"'";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue( [[SampleFieldValidator validateGroup:emptyStr]       isValid]);
    XCTAssertTrue( [[SampleFieldValidator validateGroup:valid]          isValid]);
    XCTAssertTrue( [[SampleFieldValidator validateGroup:punctuation]    isValid]);
    XCTAssertFalse([[SampleFieldValidator validateGroup:singleQuote]    isValid]);
    XCTAssertFalse([[SampleFieldValidator validateGroup:tooLong]        isValid]);
}

- (void)testValidateType
{
    NSString *emptyStr = @"";
    NSString *valid = @"a new start 2222";
    NSString *punctuation = @"._-/";
    NSString *singleQuote = @"'";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue( [[SampleFieldValidator validateType:emptyStr]        isValid]);
    XCTAssertTrue( [[SampleFieldValidator validateType:valid]           isValid]);
    XCTAssertTrue( [[SampleFieldValidator validateType:punctuation]     isValid]);
    XCTAssertFalse([[SampleFieldValidator validateType:singleQuote]     isValid]);
    XCTAssertFalse([[SampleFieldValidator validateType:tooLong]         isValid]);
}

- (void)testValidateDeposystem
{
    NSString *emptyStr = @"";
    NSString *valid = @"a new start 2222";
    NSString *alsoValid = @"N/A";
    NSString *singleQuote = @"SingleQuote'";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue( [[SampleFieldValidator validateDeposystem:emptyStr]   isValid]);
    XCTAssertTrue( [[SampleFieldValidator validateDeposystem:valid]      isValid]);
    XCTAssertTrue( [[SampleFieldValidator validateDeposystem:alsoValid]  isValid]);
    XCTAssertFalse([[SampleFieldValidator validateDeposystem:tooLong]    isValid]);
    XCTAssertFalse([[SampleFieldValidator validateDeposystem:singleQuote]isValid]);
}

- (void)testValidateRegion
{
    NSString *valid = @"region north 1";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SampleFieldValidator validateRegion:valid] isValid]);

    XCTAssertFalse([[SampleFieldValidator validateRegion:invalid]   isValid]);
    XCTAssertFalse([[SampleFieldValidator validateRegion:tooLong]   isValid]);
}

- (void)testValidateSection
{
    NSString *valid = @"section 42 ";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SampleFieldValidator validateSection:valid] isValid]);

    XCTAssertFalse([[SampleFieldValidator validateSection:invalid] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateSection:tooLong] isValid]);
}

- (void)testValidateMeters
{
    NSString *positive = @"99.99";
    NSString *zero = @"0";
    NSString *negative = @"-99.99";
    NSString *invalid = @"12gkjla";

    XCTAssertTrue([[SampleFieldValidator validateMeters:positive] isValid]);
    XCTAssertTrue([[SampleFieldValidator validateMeters:zero] isValid]);
    XCTAssertTrue([[SampleFieldValidator validateMeters:negative] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateMeters:invalid] isValid]);
}

- (void)testValidateLatitude
{
    NSString *positive = @"99.99";
    NSString *zero = @"0";
    NSString *negative = @"-99.99";
    NSString *invalid = @"12gkjla";

    XCTAssertTrue([[SampleFieldValidator validateLatitude:positive] isValid]);
    XCTAssertTrue([[SampleFieldValidator validateLatitude:zero] isValid]);
    XCTAssertTrue([[SampleFieldValidator validateLatitude:negative] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateLatitude:invalid] isValid]);
}

- (void)testValidateLongitude
{
    NSString *positive = @"99.99";
    NSString *zero = @"0";
    NSString *negative = @"-99.99";
    NSString *invalid = @"12gkjla";

    XCTAssertTrue([[SampleFieldValidator validateLongitude:positive] isValid]);
    XCTAssertTrue([[SampleFieldValidator validateLongitude:zero] isValid]);
    XCTAssertTrue([[SampleFieldValidator validateLongitude:negative] isValid]);
    XCTAssertFalse([[SampleFieldValidator validateLongitude:invalid] isValid]);
}

- (void)testValidateAge
{
    NSTimeInterval unixTime = NSTimeIntervalSince1970;
    NSString *unixTimeInString = [NSString stringWithFormat:@"%f", unixTime];

    XCTAssertTrue([[SampleFieldValidator validateAge:unixTimeInString] isValid]);
}

- (void)testValidateDateCollected
{
    NSTimeInterval unixTime = NSTimeIntervalSince1970;
    NSString *unixTimeInString = [NSString stringWithFormat:@"%f", unixTime];

    XCTAssertTrue([[SampleFieldValidator validateDateCollected:unixTimeInString] isValid]);
}

- (void)testValidateNotes
{
    NSString *validNotes = @"These notes are valid";
    NSString *emptyStr = @"";

    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 2001; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SampleFieldValidator validateNotes:validNotes] isValid]);
    XCTAssertTrue([[SampleFieldValidator validateNotes:emptyStr] isValid]);

    XCTAssertFalse([[SampleFieldValidator validateNotes:tooLong] isValid]);
}

- (void)testValidateHyperlinks
{
    NSString *validLinks = @"http://www.test.com,http://www.test.com";
    NSString *emptyStr = @"";

    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 2001; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SampleFieldValidator validateHyperlinks:validLinks] isValid]);
    XCTAssertTrue([[SampleFieldValidator validateHyperlinks:emptyStr] isValid]);

    XCTAssertFalse([[SampleFieldValidator validateHyperlinks:tooLong] isValid]);
}


@end
