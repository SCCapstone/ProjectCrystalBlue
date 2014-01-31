//
//  LocalImageStoreTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 1/31/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocalImageStore.h"

@interface LocalImageStoreTests : XCTestCase

@end

@implementation LocalImageStoreTests

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

/// Verify that trying to retrieve a nonexistent image returns a nil object
- (void)testNonexistentImageReturnsNil
{
    NSString *nonExistentImageKey = @"NO-ONE-USE-THIS-AS-AN-IMAGE-KEY-PLEASE";
    
    NSImage *retrievedImage = [LocalImageStore getImageForKey:nonExistentImageKey];
    XCTAssertNil(retrievedImage, @"Image data should have been nil!");
}

- (void)testDeleteNonexistentFile
{
    NSString *key = @"NO-ONE-USE-THIS-AS-AN-IMAGE-KEY-PLEASE";
    
    XCTAssertFalse([LocalImageStore deleteImageWithKey:key],
                   @"Deletion should not have been successful for a non-existent file.");
}

/// Verify that we can successfully perform basic image tasks locally: PUT, GET, and DELETE an image
- (void)testSaveGetAndDeleteImage
{
    NSString *testFile = @"big_test_image_4096-4096";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    NSImage *imageToSave = [[NSImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToSave, @"Local test image seems to have been lost!");
    
    // Generate a random key to use for the image
    NSString *key = [[[[NSUUID alloc] init] UUIDString] stringByAppendingString:@".jpg"];
    
    // No image with this key should exist. (Barring considerable statistical improbability)
    XCTAssertFalse([LocalImageStore imageExistsForKey:key],
                   @"The LocalImageStore believes that an image already exists for this key.");
    
    // Perform the upload
    BOOL saveSuccess = [LocalImageStore putImage:imageToSave forKey:key];
    XCTAssertTrue(saveSuccess, @"LocalImageStore indicated that the save was unsuccessful.");
    
    // Since an image exists for the key, we should now expect ImageForKey to return true
    XCTAssertTrue([LocalImageStore imageExistsForKey:key],
                  @"LocalImageStore should know that an image does exist for the key.");
    
    // Let's check that we can get the correct image back.
    NSImage *retrievedImage = [LocalImageStore getImageForKey:key];
    
    XCTAssertNotNil(retrievedImage, @"Image retrieved back from LocalImageStore was nil");
    XCTAssertEqual([retrievedImage size], [imageToSave size]);
    
    // Finally, delete the image to clean up.
    BOOL deleteSuccess = [LocalImageStore deleteImageWithKey:key];
    XCTAssertTrue(deleteSuccess, @"LocalImageStore indicated that deletion was unsuccessful.");
    
    // Verify that the image is not present
    XCTAssertFalse([LocalImageStore imageExistsForKey:key],
                   @"Delete image didn't work - the ImageStore thinks an image exists for the key.");
    XCTAssertNil([LocalImageStore getImageForKey:key],
                 @"Delete image didn't work - the ImageStore returned non-nil image data.");
}

@end