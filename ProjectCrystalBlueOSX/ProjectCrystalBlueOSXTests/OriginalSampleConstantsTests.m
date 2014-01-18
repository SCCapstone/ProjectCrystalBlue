//
//  OriginalSampleConstantsTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OriginalSampleConstants.h"

@interface OriginalSampleConstantsTests : XCTestCase

@end

@implementation OriginalSampleConstantsTests

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

- (void)testExample
{
    XCTAssertTrue([[OriginalSampleConstants attributeNames] count] == 1);
    XCTAssertTrue([[OriginalSampleConstants attributeDefaultValues] count] == 1);
    XCTAssertTrue([[[OriginalSampleConstants attributeNames] objectAtIndex:0] isEqualToString:@"Continent"]);
}

@end
