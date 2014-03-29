//
//  ProcedureFieldValidatorTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/29/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProcedureFieldValidator.h"

@interface ProcedureFieldValidatorTests : XCTestCase

@end

@implementation ProcedureFieldValidatorTests

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

- (void)testValidateInitials
{
    NSString *emptyStr = @"";
    NSString *valid = @"myinitials";
    NSString *valid2 = @"foo2";
    NSString *notValid1 = @",";
    NSString *notValid2 = @"{}";
    NSString *notValid3 = @"|";
    NSString *notValid4 = @"01234567890";

    XCTAssertTrue ([[ProcedureFieldValidator validateInitials:emptyStr]     isValid]);
    XCTAssertTrue ([[ProcedureFieldValidator validateInitials:valid]        isValid]);
    XCTAssertTrue ([[ProcedureFieldValidator validateInitials:valid2]       isValid]);
    XCTAssertFalse([[ProcedureFieldValidator validateInitials:notValid1]    isValid]);
    XCTAssertFalse([[ProcedureFieldValidator validateInitials:notValid2]    isValid]);
    XCTAssertFalse([[ProcedureFieldValidator validateInitials:notValid3]    isValid]);
    XCTAssertFalse([[ProcedureFieldValidator validateInitials:notValid4]    isValid]);
}

@end
