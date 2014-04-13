//
//  SourceImageUtilsTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SourceImageUtils.h"
#import "Source.h"
#import "SourceConstants.h"
#import "LocalLibraryObjectStore.h"
#import "LocalImageStore.h"
#import "FileSystemUtils.h"

#define DATABASE_NAME @"test_database.db"

@interface SourceImageUtilsTests : XCTestCase

@end

@implementation SourceImageUtilsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    [FileSystemUtils clearTestDirectory];
    [super tearDown];
}

/// Tests the main "addImage/forSource" methods
- (void)testAddImages
{
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                                 WithDatabaseName:DATABASE_NAME];


    AbstractImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:[FileSystemUtils testDirectory]];

    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    NSImage *imageToUpload = [[NSImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToUpload, @"Upload test image seems to have been lost!");

    // Set up the source object to add images to
    NSString *sourceKey = @"SourceKey";
    Source *source = [[Source alloc] initWithKey:sourceKey
                                   AndWithValues:[SourceConstants attributeDefaultValues]];

    BOOL successPutLibObject = [dataStore putLibraryObject:source
                                                 IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(successPutLibObject);

    source = nil;
    source = (Source *)[dataStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];

    // Initially, there should be no images for the source
    NSArray *images;
    NSArray *keys;
    images = [SourceImageUtils imagesForSource:source inImageStore:imageStore];
    XCTAssertTrue(images.count == 0);

    // Add an image
    NSString *imageTag = @"imageTag";
    BOOL successAddImageForSource = [SourceImageUtils addImage:imageToUpload
                                                     forSource:source
                                                   inDataStore:dataStore
                                                  withImageTag:imageTag
                                                intoImageStore:imageStore];
    XCTAssertTrue(successAddImageForSource);

    images = [SourceImageUtils imagesForSource:source
                                  inImageStore:imageStore];
    XCTAssertTrue(images.count == 1);
    if (images.count >= 1) {
        NSImage *actualImage = [images objectAtIndex:0];
        XCTAssertTrue(imageToUpload.size.height == actualImage.size.height);
        XCTAssertTrue(imageToUpload.size.width  == actualImage.size.width);
    } else {
        XCTAssertTrue(false); /* should fail */
    }

    // Check that the image key is correct
    source = nil;
    source = (Source *)[dataStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];

    NSString *expectedKey = [NSString stringWithFormat:@"%@_i000.%@.jpg", sourceKey, imageTag];

    keys = [SourceImageUtils imageKeysForSource:source];
    XCTAssertTrue([expectedKey isEqualToString:[keys objectAtIndex:0]]);

    // clean up data
    [dataStore deleteLibraryObjectWithKey:sourceKey FromTable:[SourceConstants tableName]];
    [imageStore flushLocalImageData];
}

- (void)testRemoveAllImagesForSource
{
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                                 WithDatabaseName:DATABASE_NAME];


    AbstractImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:[FileSystemUtils testDirectory]];

    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    NSImage *imageToUpload = [[NSImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToUpload, @"Upload test image seems to have been lost!");

    // Set up the source object to add images to
    NSString *sourceKey = @"SourceKey";
    Source *source = [[Source alloc] initWithKey:sourceKey
                                   AndWithValues:[SourceConstants attributeDefaultValues]];

    BOOL successPutLibObject = [dataStore putLibraryObject:source
                                                 IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(successPutLibObject);

    // Add some images to the source
    const int imagesToAdd = 5;
    for (int i = 0; i < imagesToAdd; ++i) {
        [SourceImageUtils addImage:imageToUpload
                         forSource:(Source *)[dataStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]]
                       inDataStore:dataStore
                    intoImageStore:imageStore];
    }

    // Retrieving the imageKeys for later.
    NSArray *imageKeys = [SourceImageUtils imageKeysForSource:(Source *)[dataStore getLibraryObjectForKey:sourceKey
                                                                                                FromTable:[SourceConstants tableName]]];
    XCTAssertTrue(imageKeys.count == imagesToAdd);

    // Now remove them
    BOOL returnSuccessValue =
        [SourceImageUtils removeAllImagesForSource:(Source *)[dataStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]]
                                       inDataStore:dataStore
                                      inImageStore:imageStore];
    XCTAssertTrue(returnSuccessValue);

    // Check that the sources database doesn't contain the images
    Source *retrievedSource = (Source *)[dataStore getLibraryObjectForKey:sourceKey
                                                                FromTable:[SourceConstants tableName]];

    NSString *imageDbValue = [retrievedSource.attributes objectForKey:SRC_IMAGES];
    XCTAssertTrue([imageDbValue isEqualToString:@""]);

    // Check that the images were really deleted from the image store
    for (NSString *imageKey in imageKeys) {
        XCTAssertFalse([imageStore imageExistsForKey:imageKey]);
    }

    // clean up data
    [dataStore deleteLibraryObjectWithKey:sourceKey FromTable:[SourceConstants tableName]];
    [imageStore flushLocalImageData];
}

/// Removal of a single image from a source.
- (void)testRemoveSingleImage
{
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                                 WithDatabaseName:DATABASE_NAME];

    AbstractImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:[FileSystemUtils testDirectory]];

    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    NSImage *imageToUpload = [[NSImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToUpload, @"Upload test image seems to have been lost!");

    // Set up the source object to add images to
    NSString *sourceKey = @"SourceKey";
    Source *source = [[Source alloc] initWithKey:sourceKey
                                   AndWithValues:[SourceConstants attributeDefaultValues]];

    BOOL successPutLibObject = [dataStore putLibraryObject:source
                                                 IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(successPutLibObject);

    // Add some images to the source
    const int imagesToAdd = 5;
    for (int i = 0; i < imagesToAdd; ++i) {
        [SourceImageUtils addImage:imageToUpload
                         forSource:(Source *)[dataStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]]
                       inDataStore:dataStore
                    intoImageStore:imageStore];
    }

    NSArray *imageKeys = [SourceImageUtils imageKeysForSource:(Source *)[dataStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]]];
    const int indexToRemove = 2;

    // Now actually remove the image
    NSString *imageKeyToRemove = [imageKeys objectAtIndex:indexToRemove];

    [SourceImageUtils removeImage:imageKeyToRemove
                        forSource:(Source *)[dataStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]]
                      inDataStore:dataStore
                     inImageStore:imageStore];

    // check that the image was removed
    Source *retrievedSource = (Source *)[dataStore getLibraryObjectForKey:sourceKey
                                                                FromTable:[SourceConstants tableName]];
    XCTAssertTrue([SourceImageUtils imageKeysForSource:retrievedSource].count == imagesToAdd - 1);
    XCTAssertFalse([[SourceImageUtils imageKeysForSource:retrievedSource] containsObject:imageKeyToRemove]);

    XCTAssertFalse([imageStore imageExistsForKey:imageKeyToRemove]);

    // clean up data
    [dataStore deleteLibraryObjectWithKey:sourceKey FromTable:[SourceConstants tableName]];
    [imageStore flushLocalImageData];
}

/// Tests the "appendImageKey/toSource" method
- (void)testAppendImageKey
{
    NSUInteger numberOfImages = 102;
    NSString *sourceKey = @"sourceKey";
    NSMutableArray *expectedImageKeys = [[NSMutableArray alloc] initWithCapacity:numberOfImages];

    Source *source = [[Source alloc] initWithKey:sourceKey
                                   AndWithValues:[SourceConstants attributeDefaultValues]];

    for (NSUInteger imageCount = 0; imageCount < numberOfImages; ++imageCount) {
        NSString *imageKey = [NSString stringWithFormat:@"sourceKey_i%03d.jpg", (int)imageCount];
        [expectedImageKeys addObject:imageKey];

        [SourceImageUtils appendImageKey:imageKey toSource:source];
    }

    NSArray *actualImageKeys = [SourceImageUtils imageKeysForSource:source];

    XCTAssertTrue([expectedImageKeys isEqualToArray:actualImageKeys]);
}

/// Tests the "nextUniqueImageNumberForSource" method.
- (void)testUniqueImageNumber
{
    NSString *key = @"sourceKey";
    NSString *result;
    NSString *expected;
    Source *source = [[Source alloc] initWithKey:key
                              AndWithValues:[SourceConstants attributeDefaultValues]];

    expected = @"_i000";
    result = [SourceImageUtils nextUniqueImageNumberForSource:source];
    XCTAssertTrue([expected isEqualToString:result]);

    NSString *initalImageKey = @"sourceKey_i123.TAG.jpg";
    expected = @"_i124";
    [source.attributes setObject:initalImageKey forKey:SRC_IMAGES];
    result = [SourceImageUtils nextUniqueImageNumberForSource:source];
    XCTAssertTrue([expected isEqualToString:result]);
}

/// Tests the "ExtractNumberSuffixFromKeys" helper method.
- (void)testExtractNumberSuffixFromKeys
{
    NSString *key;
    NSInteger result;
    NSInteger expected;

    key = @"SOURCEKEY_i123.jpg";
    expected = 123;
    result = [SourceImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);

    key = @"SOURCEKEY_i123.TAG.jpg";
    expected = 123;
    result = [SourceImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);

    key = @"SOURCEKEY_i004.jpg";
    expected = 4;
    result = [SourceImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);

    key = @"SOURCEKEY_i000.jpg";
    expected = 0;
    result = [SourceImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);

    key = @"SOURCEKEY_i010.jpg";
    expected = 10;
    result = [SourceImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);
}
@end
