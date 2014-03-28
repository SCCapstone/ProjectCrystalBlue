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
    NSString *invalidChars1 = @"Underscores_must_not_allowed_in_keys";
    NSString *invalidChars2 = @"Neither.Can.Periods";

    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateSourceKey:validKey] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateSourceKey:invalidChars1] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSourceKey:invalidChars2] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSourceKey:tooShort] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSourceKey:tooLong] isValid]);
}

- (void)testValidateContinent
{
    NSString *valid = @"North America";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateContinent:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateContinent:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateContinent:tooShort] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateContinent:tooLong] isValid]);
}

- (void)testValidateType
{
    // TO-DO
    XCTAssertTrue(NO);
}

- (void)testValidateDeposystem
{
    // TO-DO
    XCTAssertTrue(NO);
}

- (void)testValidateGroup
{
    // TO-DO
    XCTAssertTrue(NO);
}

- (void)testValidateFormation
{
    NSString *valid = @"Some Formation Somewhere 2";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateFormation:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateFormation:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateFormation:tooShort] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateFormation:tooLong] isValid]);
}

- (void)testValidateMember
{
    NSString *valid = @"a member 15";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateMember:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateMember:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateMember:tooShort] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateMember:tooLong] isValid]);
}

- (void)testValidateRegion
{
    NSString *valid = @"region north 1";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateRegion:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateRegion:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateRegion:tooShort] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateRegion:tooLong] isValid]);
}

- (void)testValidateSection
{
    NSString *valid = @"section 42 ";
    NSString *invalid = @"#@*(@$&(4892374892734'''/./'.'/";
    NSString *tooShort = @"";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 91; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue([[SourceFieldValidator validateSection:valid] isValid]);

    XCTAssertFalse([[SourceFieldValidator validateSection:invalid] isValid]);
    XCTAssertFalse([[SourceFieldValidator validateSection:tooShort] isValid]);
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

- (void)testValidateAgeMethod
{
    // TO-DO
    XCTAssertTrue(NO);
}

- (void)testValidateAgeDatatype
{
    // TO-DO
    XCTAssertTrue(NO);
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
