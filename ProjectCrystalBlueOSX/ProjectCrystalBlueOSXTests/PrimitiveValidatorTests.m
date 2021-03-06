//
//  PrimitiveValidatorTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PrimitiveFieldValidator.h"

@interface PrimitiveValidatorTests : XCTestCase

@end

@implementation PrimitiveValidatorTests

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

- (void)testMinAndMax
{
    NSString *empty = @"";
    NSString *twoCharacters = @"ab";

    XCTAssertFalse([PrimitiveFieldValidator validateField:empty
                                       isAtLeastMinLength:1]);

    XCTAssertFalse([PrimitiveFieldValidator validateField:twoCharacters
                                    isNoMoreThanMaxLength:1]);

    XCTAssertTrue([PrimitiveFieldValidator validateField:empty
                                   isNoMoreThanMaxLength:5]);

    XCTAssertTrue([PrimitiveFieldValidator validateField:twoCharacters
                                      isAtLeastMinLength:1]);
}

- (void)testCharacterSetMatching
{
    NSString *alphanumeric = @"12345abcdeABCDE";
    NSString *numerals = @"12345";
    NSString *alphabet = @"abcdeABCDE";
    NSString *alphaNumericWithWhitespace = @"12345 ABCDEFG abcdefgh";

    XCTAssertTrue([PrimitiveFieldValidator validateField:alphanumeric
                                     containsOnlyCharSet:[NSCharacterSet alphanumericCharacterSet]]);

    XCTAssertTrue([PrimitiveFieldValidator validateField:numerals
                                     containsOnlyCharSet:[NSCharacterSet decimalDigitCharacterSet]]);

    XCTAssertTrue([PrimitiveFieldValidator validateField:alphabet
                                     containsOnlyCharSet:[NSCharacterSet letterCharacterSet]]);

    XCTAssertFalse([PrimitiveFieldValidator validateField:alphaNumericWithWhitespace
                                      containsOnlyCharSet:[NSCharacterSet alphanumericCharacterSet]]);

    NSMutableCharacterSet *alphaNumericAndWhitespace = [NSMutableCharacterSet alphanumericCharacterSet];
    [alphaNumericAndWhitespace formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    XCTAssertTrue([PrimitiveFieldValidator validateField:alphaNumericWithWhitespace
                                     containsOnlyCharSet:alphaNumericAndWhitespace]);
}

- (void)testStringWithinListOfValidOptions
{
    NSString *option1 = @"aardvark";
    NSString *option2 = @"bonobo";
    NSString *option3 = @"cheetah";
    NSString *notAnOption = @"dingo";

    NSArray *validOptions = [NSArray arrayWithObjects:option1, option2, option3, nil];

    XCTAssertTrue([PrimitiveFieldValidator validateField:option1
                                      isOneOfValidValues:validOptions]);

    XCTAssertFalse([PrimitiveFieldValidator validateField:notAnOption
                                       isOneOfValidValues:validOptions]);
}

- (void)testDecimalString
{
    NSString *positiveDecimal = @"10.450239";
    NSString *negativeDecimal = @"-5289.39092";
    NSString *integer = @"420";
    NSString *zero = @"0";
    NSString *notValid = @"230adfjgs085208";

    XCTAssertTrue([PrimitiveFieldValidator validateFieldIsDecimal:positiveDecimal]);
    XCTAssertTrue([PrimitiveFieldValidator validateFieldIsDecimal:negativeDecimal]);
    XCTAssertTrue([PrimitiveFieldValidator validateFieldIsDecimal:integer]);
    XCTAssertTrue([PrimitiveFieldValidator validateFieldIsDecimal:zero]);

    XCTAssertFalse([PrimitiveFieldValidator validateFieldIsDecimal:notValid]);
}

- (void)testIntegerString
{
    NSString *positiveNumber = @"12380510";
    NSString *negativeNumber = @"-258032805";
    NSString *invalid = @"xcvbijoijo";
    NSString *zero = @"0";

    XCTAssertTrue([PrimitiveFieldValidator validateFieldIsIntegral:positiveNumber]);
    XCTAssertTrue([PrimitiveFieldValidator validateFieldIsIntegral:negativeNumber]);
    XCTAssertTrue([PrimitiveFieldValidator validateFieldIsIntegral:zero]);

    XCTAssertFalse([PrimitiveFieldValidator validateFieldIsIntegral:invalid]);
}

@end
