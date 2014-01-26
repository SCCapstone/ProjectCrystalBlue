//
//  S3UtilsTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "S3Utils.h"

@interface S3UtilsTests : XCTestCase

@end

@implementation S3UtilsTests

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

- (void)testImageMIMETypes
{
    XCTAssertTrue([S3Utils contentTypeIsImage:@"image/jpeg"]);
    XCTAssertTrue([S3Utils contentTypeIsImage:@"image/png"]);
    XCTAssertTrue([S3Utils contentTypeIsImage:@"image/gif"]);
    XCTAssertFalse([S3Utils contentTypeIsImage:@"image/lolvirus"]);
    XCTAssertFalse([S3Utils contentTypeIsImage:@"binary/roflmaovirus"]);
}

@end
