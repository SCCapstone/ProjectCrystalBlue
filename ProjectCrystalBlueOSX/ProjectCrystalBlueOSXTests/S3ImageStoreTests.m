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

/** Verify that we can successfully upload an image to S3.
 *  Then, check that if we download it, we get the right image back.
 */
- (void)testUploadImage
{
    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    NSImage *imageToUpload = [[NSImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToUpload, @"Upload test image seems to have been lost!");
    
    // Generate a random key for upload
    NSString *key = [[[[NSUUID alloc] init] UUIDString] stringByAppendingString:@".jpg"];

    // Perform the upload
    BOOL uploadSuccess = [S3ImageStore putImage:imageToUpload forKey:key];
    XCTAssertTrue(uploadSuccess, @"S3ImageStore indicated that the upload was unsuccessful.");
    
    // Now that we've uploaded the image, let's check that we can get it back.
    NSImage *retrievedImage = [S3ImageStore getImageForKey:key];
    
    XCTAssertNotNil(retrievedImage, @"Image retrieved back from S3 was nil");
    XCTAssertEqual([retrievedImage size], [imageToUpload size]);
    
    // Finally, delete the image to clean up.
    BOOL deleteSuccess = [S3ImageStore deleteImageWithKey:key];
    XCTAssertTrue(deleteSuccess, @"S3ImageStore indicated that deletion was unsuccessful.");
}

@end
