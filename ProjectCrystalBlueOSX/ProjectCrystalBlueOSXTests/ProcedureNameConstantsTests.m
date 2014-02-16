//
//  ProcedureNameConstantsTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProcedureNameConstants.h"

@interface ProcedureNameConstantsTests : XCTestCase

@end

@implementation ProcedureNameConstantsTests

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

- (void)testSetsAreCorrectSize
{
    NSUInteger numberOfProcedureNames = [[ProcedureNameConstants allProcedureNames] count];
    NSUInteger numberOfProcedureTags =  [[ProcedureNameConstants allProcedureTags] count];
    
    XCTAssertEqual(numberOfProcedureNames, numberOfProcedureTags,
                   @"Tags (%lu) and Names (%lu) should have same count!", numberOfProcedureNames, numberOfProcedureTags);
}

@end
