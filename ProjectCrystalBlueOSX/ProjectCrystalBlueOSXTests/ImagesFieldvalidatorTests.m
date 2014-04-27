//
//  ImagesFieldvalidatorTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/29/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ImagesFieldValidator.h"

@interface ImagesFieldvalidatorTests : XCTestCase

@end

@implementation ImagesFieldvalidatorTests

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

- (void)testValidateImageTag
{
    NSString *emptyStr = @"";
    NSString *valid = @"myinitials";
    NSString *valid2 = @"foo2";
    NSString *singleQuote = @"'";
    NSString *notValid2 = @".";
    NSString *notValid3 = @"_";
    NSMutableString *tooLong = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 31; ++i) {
        [tooLong appendString:@"a"];
    }

    XCTAssertTrue ([[ImagesFieldValidator validateImageTag:emptyStr]     isValid]);
    XCTAssertTrue ([[ImagesFieldValidator validateImageTag:valid]        isValid]);
    XCTAssertTrue ([[ImagesFieldValidator validateImageTag:valid2]       isValid]);
    XCTAssertFalse([[ImagesFieldValidator validateImageTag:singleQuote]  isValid]);
    XCTAssertFalse([[ImagesFieldValidator validateImageTag:notValid2]    isValid]);
    XCTAssertFalse([[ImagesFieldValidator validateImageTag:notValid3]    isValid]);
    XCTAssertFalse([[ImagesFieldValidator validateImageTag:tooLong]      isValid]);
}

@end
