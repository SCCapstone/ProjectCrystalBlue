//
//  S3ImageStoreTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ImageStore.h"
#import "S3ImageStore.h"

@interface S3ImageStoreTests : XCTestCase

@end

@implementation S3ImageStoreTests

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

/// Verify that default image can be retrieved
- (void)testDefaultImage
{
    XCTAssertNotNil([S3ImageStore defaultImage]);
}

/// Verify that a default image is retrieved for an image that does not exist.
- (void)testNonexistantImageReturnsDefaultImage
{
    [S3ImageStore setUpSingleton];
    NSString *nonexistantImage = @"NO-ONE-USE-THIS-AS-A-KEY-PLEASE";
    
    XCTAssertFalse([S3ImageStore imageExistsForKey:nonexistantImage]);

    NSImage *resultDefaultImage = [S3ImageStore getImageForKey:nonexistantImage];
    XCTAssertNotNil(resultDefaultImage);
}

/** Verify that a real image can be actually accessed.
 *  Because the "image-not-found" image is 256x256, make sure the test image is not 256x256.
 */
- (void)testAccessRealImage
{
    NSString *testImageKey = @"UNIT_TEST_IMAGE_8x8.png";
    NSImage *image = [S3ImageStore getImageForKey:testImageKey];
    XCTAssertNotNil(image);
    XCTAssertEqual([image size].width, (CGFloat)8);
    XCTAssertEqual([image size].height, (CGFloat)8);
}

@end
