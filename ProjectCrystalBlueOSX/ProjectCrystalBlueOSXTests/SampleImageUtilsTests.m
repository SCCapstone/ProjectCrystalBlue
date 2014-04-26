//
//  SampleImageUtilsTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SampleImageUtils.h"
#import "Sample.h"
#import "SampleConstants.h"
#import "LocalLibraryObjectStore.h"
#import "LocalImageStore.h"
#import "FileSystemUtils.h"

#define DATABASE_NAME @"test_database.db"

@interface SampleImageUtilsTests : XCTestCase

@end

@implementation SampleImageUtilsTests

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

/// Tests the main "addImage/forSample" methods
- (void)testAddImages
{
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                                 WithDatabaseName:DATABASE_NAME];


    AbstractImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:[FileSystemUtils testDirectory]];

    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    NSImage *imageToUpload = [[NSImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToUpload, @"Upload test image seems to have been lost!");

    // Set up the sample object to add images to
    NSString *sampleKey = @"SampleKey";
    Sample *sample = [[Sample alloc] initWithKey:sampleKey
                                   AndWithValues:[SampleConstants attributeDefaultValues]];

    BOOL successPutLibObject = [dataStore putLibraryObject:sample
                                                 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(successPutLibObject);

    sample = nil;
    sample = (Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];

    // Initially, there should be no images for the sample
    NSArray *images;
    NSArray *keys;
    images = [SampleImageUtils imagesForSample:sample inImageStore:imageStore];
    XCTAssertTrue(images.count == 0);

    // Add an image
    NSString *imageTag = @"imageTag";
    BOOL successAddImageForSample = [SampleImageUtils addImage:imageToUpload
                                                     forSample:sample
                                                   inDataStore:dataStore
                                                  withImageTag:imageTag
                                                intoImageStore:imageStore];
    XCTAssertTrue(successAddImageForSample);

    images = [SampleImageUtils imagesForSample:sample
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
    sample = nil;
    sample = (Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];

    NSString *expectedKey = [NSString stringWithFormat:@"%@_i000.%@.jpg", sampleKey, imageTag];

    keys = [SampleImageUtils imageKeysForSample:sample];
    XCTAssertTrue([expectedKey isEqualToString:[keys objectAtIndex:0]]);

    // clean up data
    [dataStore deleteLibraryObjectWithKey:sampleKey FromTable:[SampleConstants tableName]];
    [imageStore flushLocalImageData];
}

- (void)testRemoveAllImagesForSample
{
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                                 WithDatabaseName:DATABASE_NAME];


    AbstractImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:[FileSystemUtils testDirectory]];

    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    NSImage *imageToUpload = [[NSImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToUpload, @"Upload test image seems to have been lost!");

    // Set up the sample object to add images to
    NSString *sampleKey = @"SampleKey";
    Sample *sample = [[Sample alloc] initWithKey:sampleKey
                                   AndWithValues:[SampleConstants attributeDefaultValues]];

    BOOL successPutLibObject = [dataStore putLibraryObject:sample
                                                 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(successPutLibObject);

    // Add some images to the sample
    const int imagesToAdd = 5;
    for (int i = 0; i < imagesToAdd; ++i) {
        [SampleImageUtils addImage:imageToUpload
                         forSample:(Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]]
                       inDataStore:dataStore
                    intoImageStore:imageStore];
    }

    // Retrieving the imageKeys for later.
    NSArray *imageKeys = [SampleImageUtils imageKeysForSample:(Sample *)[dataStore getLibraryObjectForKey:sampleKey
                                                                                                FromTable:[SampleConstants tableName]]];
    XCTAssertTrue(imageKeys.count == imagesToAdd);

    // Now remove them
    BOOL returnSuccessValue =
        [SampleImageUtils removeAllImagesForSample:(Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]]
                                       inDataStore:dataStore
                                      inImageStore:imageStore];
    XCTAssertTrue(returnSuccessValue);

    // Check that the samples database doesn't contain the images
    Sample *retrievedSample = (Sample *)[dataStore getLibraryObjectForKey:sampleKey
                                                                FromTable:[SampleConstants tableName]];

    NSString *imageDbValue = [retrievedSample.attributes objectForKey:SMP_IMAGES];
    XCTAssertTrue([imageDbValue isEqualToString:@""]);

    // Check that the images were really deleted from the image store
    for (NSString *imageKey in imageKeys) {
        XCTAssertFalse([imageStore imageExistsForKey:imageKey]);
    }

    // clean up data
    [dataStore deleteLibraryObjectWithKey:sampleKey FromTable:[SampleConstants tableName]];
    [imageStore flushLocalImageData];
}

/// Removal of a single image from a sample.
- (void)testRemoveSingleImage
{
    AbstractLibraryObjectStore *dataStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                                                 WithDatabaseName:DATABASE_NAME];

    AbstractImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:[FileSystemUtils testDirectory]];

    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    NSImage *imageToUpload = [[NSImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToUpload, @"Upload test image seems to have been lost!");

    // Set up the sample object to add images to
    NSString *sampleKey = @"SampleKey";
    Sample *sample = [[Sample alloc] initWithKey:sampleKey
                                   AndWithValues:[SampleConstants attributeDefaultValues]];

    BOOL successPutLibObject = [dataStore putLibraryObject:sample
                                                 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(successPutLibObject);

    // Add some images to the sample
    const int imagesToAdd = 5;
    for (int i = 0; i < imagesToAdd; ++i) {
        [SampleImageUtils addImage:imageToUpload
                         forSample:(Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]]
                       inDataStore:dataStore
                    intoImageStore:imageStore];
    }

    NSArray *imageKeys = [SampleImageUtils imageKeysForSample:(Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]]];
    const int indexToRemove = 2;

    // Now actually remove the image
    NSString *imageKeyToRemove = [imageKeys objectAtIndex:indexToRemove];

    [SampleImageUtils removeImage:imageKeyToRemove
                        forSample:(Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]]
                      inDataStore:dataStore
                     inImageStore:imageStore];

    // check that the image was removed
    Sample *retrievedSample = (Sample *)[dataStore getLibraryObjectForKey:sampleKey
                                                                FromTable:[SampleConstants tableName]];
    XCTAssertTrue([SampleImageUtils imageKeysForSample:retrievedSample].count == imagesToAdd - 1);
    XCTAssertFalse([[SampleImageUtils imageKeysForSample:retrievedSample] containsObject:imageKeyToRemove]);

    XCTAssertFalse([imageStore imageExistsForKey:imageKeyToRemove]);

    // clean up data
    [dataStore deleteLibraryObjectWithKey:sampleKey FromTable:[SampleConstants tableName]];
    [imageStore flushLocalImageData];
}

/// Tests the "appendImageKey/toSample" method
- (void)testAppendImageKey
{
    NSUInteger numberOfImages = 102;
    NSString *sampleKey = @"sampleKey";
    NSMutableArray *expectedImageKeys = [[NSMutableArray alloc] initWithCapacity:numberOfImages];

    Sample *sample = [[Sample alloc] initWithKey:sampleKey
                                   AndWithValues:[SampleConstants attributeDefaultValues]];

    for (NSUInteger imageCount = 0; imageCount < numberOfImages; ++imageCount) {
        NSString *imageKey = [NSString stringWithFormat:@"sampleKey_i%03d.jpg", (int)imageCount];
        [expectedImageKeys addObject:imageKey];

        [SampleImageUtils appendImageKey:imageKey toSample:sample];
    }

    NSArray *actualImageKeys = [SampleImageUtils imageKeysForSample:sample];

    XCTAssertTrue([expectedImageKeys isEqualToArray:actualImageKeys]);
}

/// Tests the "nextUniqueImageNumberForSample" method.
- (void)testUniqueImageNumber
{
    NSString *key = @"sampleKey";
    NSString *result;
    NSString *expected;
    Sample *sample = [[Sample alloc] initWithKey:key
                              AndWithValues:[SampleConstants attributeDefaultValues]];

    expected = @"_i000";
    result = [SampleImageUtils nextUniqueImageNumberForSample:sample];
    XCTAssertTrue([expected isEqualToString:result]);

    NSString *initalImageKey = @"sampleKey_i123.TAG.jpg";
    expected = @"_i124";
    [sample.attributes setObject:initalImageKey forKey:SMP_IMAGES];
    result = [SampleImageUtils nextUniqueImageNumberForSample:sample];
    XCTAssertTrue([expected isEqualToString:result]);
}

/// Tests the "ExtractNumberSuffixFromKeys" helper method.
- (void)testExtractNumberSuffixFromKeys
{
    NSString *key;
    NSInteger result;
    NSInteger expected;

    key = @"SAMPLEKEY_i123.jpg";
    expected = 123;
    result = [SampleImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);

    key = @"SAMPLEKEY_i123.TAG.jpg";
    expected = 123;
    result = [SampleImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);

    key = @"SAMPLEKEY_i004.jpg";
    expected = 4;
    result = [SampleImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);

    key = @"SAMPLEKEY_i000.jpg";
    expected = 0;
    result = [SampleImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);

    key = @"SAMPLEKEY_i010.jpg";
    expected = 10;
    result = [SampleImageUtils extractNumberSuffixFromKey:key];
    XCTAssertTrue(expected == result);
}

- (void)testExtractTagFromKeys
{
    NSString *key;
    NSString *result;
    NSString *expected;

    expected = @"ImageTagHere";
    key = [NSString stringWithFormat:@"SAMPLEKEY_i100.%@.jpg", expected];
    result = [SampleImageUtils extractImageTagFromKey:key];
    XCTAssertTrue([expected isEqualToString:result]);
}

@end
