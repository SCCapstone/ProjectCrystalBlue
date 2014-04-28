//
//  SampleImageUtils.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleImageUtils.h"
#import "S3ImageStore.h"
#import "AbstractLibraryObjectStore.h"
#import "Sample.h"
#import "SampleConstants.h"
#import "FileSystemUtils.h"
#import "PCBLogWrapper.h"

/* 
 *  General format used is:
 *
 *  SAMPLE-KEY_i###.TAG.jpg
 *
 *  Some examples:
 *  "sampleKey_i000.NearOutcrop.jpg"
 *  "sampleKey_i001.MicroscopeSlide.jpg"
 *  "sampleKey_i002.MicroscopeSlide.jpg" (tags don't have to be unique)
 *  "sampleKey_i003.jpg"                 (tags are completely optional)
 */
#define FORMAT_IMAGE_KEY @"%@%@%@%@"
#define FORMAT_IMAGE_NUMBER_SUFFIX @"_i%03d"
#define FORMAT_IMAGE_TAG @".%@"
#define DEFAULT_IMAGE_EXTENSION @".jpg"
#define DEFAULT_IMAGE_TAG @"NoTag"

@implementation SampleImageUtils

+ (AbstractImageStore *)defaultImageStore
{
    static S3ImageStore *sharedInstance = nil;
    if (nil == sharedInstance) {
        sharedInstance = [[S3ImageStore alloc] initWithLocalDirectory:[FileSystemUtils localImagesDirectory]];
    }
    return sharedInstance;
}

+ (NSArray *)imageKeysForSample:(Sample *)sample
{
    NSMutableArray *keys = [[NSMutableArray alloc] init];

    NSString *commaSeparatedImageKeys = [sample.attributes objectForKey:SMP_IMAGES];
    NSScanner *scanner = [[NSScanner alloc] initWithString:commaSeparatedImageKeys];

    while (![scanner isAtEnd])
    {
        NSString *token;
        [scanner scanUpToString:[IMAGE_LIST_DELIMITER copy] intoString:&token];
        if (token) {
            [keys addObject:token];
        }
        // skip delimiter
        [scanner scanString:[IMAGE_LIST_DELIMITER copy] intoString:nil];
    }
    return keys;
}

+ (NSArray *)imagesForSample:(Sample *)sample
                inImageStore:(AbstractImageStore *)imageStore
{
    NSArray *keys = [self.class imageKeysForSample:sample];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:keys.count];

    for (NSString *key in keys) {
        NSImage *image = [imageStore getImageForKey:key];
        if (nil == image) {
            DDLogWarn(@"Nil image returned for key %@!", key);
        } else {
            [images addObject:image];
        }
    }

    return images;
}

+ (BOOL)removeImage:(NSString *)imageKey
          forSample:(Sample *)sample
        inDataStore:(AbstractLibraryObjectStore *)dataStore
       inImageStore:(AbstractImageStore *)imageStore
{
    NSMutableArray *imageKeysForSample;
    imageKeysForSample = [NSMutableArray arrayWithArray:[self.class imageKeysForSample:sample]];

    if (![imageKeysForSample containsObject:imageKey]) {
        return NO;
    }

    [imageKeysForSample removeObject:imageKey];
    NSMutableString *newImagesString = [[NSMutableString alloc] init];

    for (int i = 0; i < imageKeysForSample.count; ++i) {
        if (i == 0) {
            // For the first image, we don't want to separate with a comma.
            [newImagesString appendFormat:@"%@", [imageKeysForSample objectAtIndex:i]];
        } else {
            [newImagesString appendFormat:@"%@%@", IMAGE_LIST_DELIMITER,
                                                   [imageKeysForSample objectAtIndex:i]];
        }
    }

    [sample.attributes setObject:newImagesString forKey:SMP_IMAGES];

    BOOL success = YES;
    success = success && [imageStore deleteImageWithKey:imageKey];
    success = success && [dataStore updateLibraryObject:sample
                                              IntoTable:[SampleConstants tableName]];

    return success;
}

+ (BOOL)removeAllImagesForSample:(Sample *)sample
                     inDataStore:(AbstractLibraryObjectStore *)dataStore
                    inImageStore:(AbstractImageStore *)imageStore
{
    NSArray *imageKeys = [self.class imageKeysForSample:sample];
    BOOL success = YES;
    for (NSString *imageKey in imageKeys) {
        const BOOL deletionSuccess = [imageStore deleteImageWithKey:imageKey];
        if (!deletionSuccess) {
            success = NO;
        }
    }

    [sample.attributes setObject:@"" forKey:SMP_IMAGES];

    const BOOL updateSampleSuccess = [dataStore updateLibraryObject:sample
                                                          IntoTable:[SampleConstants tableName]];
    if (!updateSampleSuccess) {
        success = NO;
    }

    return success;
}

+ (BOOL)addImage:(NSImage *)image
       forSample:(Sample *)sample
     inDataStore:(AbstractLibraryObjectStore *)dataStore
  intoImageStore:(AbstractImageStore *)imageStore
{
    return [self.class addImage:image
                      forSample:sample
                    inDataStore:dataStore
                   withImageTag:DEFAULT_IMAGE_TAG
                 intoImageStore:imageStore];
}

+ (BOOL)addImage:(NSImage *)image
       forSample:(Sample *)sample
     inDataStore:(AbstractLibraryObjectStore *)dataStore
    withImageTag:(NSString *)tag
  intoImageStore:(AbstractImageStore *)imageStore
{
    NSString *sampleKey = sample.key;
    NSString *imageNumber = [self.class nextUniqueImageNumberForSample:sample];
    NSString *formattedTag = [NSString stringWithFormat:FORMAT_IMAGE_TAG, tag];
    NSString *extension = DEFAULT_IMAGE_EXTENSION;

    NSString *key = [NSString stringWithFormat:FORMAT_IMAGE_KEY,
                                               sampleKey,
                                               imageNumber,
                                               formattedTag,
                                               extension];

    [self.class appendImageKey:key
                      toSample:sample];

    BOOL tableUpdated = [dataStore updateLibraryObject:sample
                                             IntoTable:[SampleConstants tableName]];
    BOOL imageUploaded = [imageStore putImage:image forKey:key];

    return (tableUpdated && imageUploaded);
}

// Some "private" helper methods.

/// Appends another image key to a sample. This is applied in-place to the sample object in memory,
/// so the sample still needs to be updated in the appropriate data store.
///
/// Note that this method is NOT idempotent - calling multiple times will cause the same image key
/// to be appended multiple times!
+ (BOOL)appendImageKey:(NSString *)imageKey
              toSample:(Sample *)sample
{
    NSString *keys = [sample.attributes objectForKey:SMP_IMAGES];

    if (keys.length <= 0) {
        [sample.attributes setObject:imageKey forKey:SMP_IMAGES];
        return YES;
    } else {
        NSString *newKeys = [keys stringByAppendingFormat:@"%@%@", IMAGE_LIST_DELIMITER, imageKey];
        [sample.attributes setObject:newKeys forKey:SMP_IMAGES];
        return YES;
    }
}

/// Finds the next valid image number for a provided sample.
/// For example, if "samplekey_i001" already exists, then "_i002" would be returned.
+ (NSString *)nextUniqueImageNumberForSample:(Sample *)sample
{
    NSArray *existingKeys = [self.class imageKeysForSample:sample];

    if (existingKeys.count <= 0) {
        return [NSString stringWithFormat:FORMAT_IMAGE_NUMBER_SUFFIX, 0];
    }

    NSString *mostRecentImageKey = [existingKeys lastObject];
    NSInteger newValue  = [self.class extractNumberSuffixFromKey:mostRecentImageKey] + 1;

    return [NSString stringWithFormat:FORMAT_IMAGE_NUMBER_SUFFIX, (int)newValue];

    return @"";
}

/// Assuming a key with a format that looks something like this:
///     SAMPLEKEY_i123.jpg
///     or
///     SAMPLEKEY_i123.IMAGETAG.jpg
///
/// then "123" will be returned.
///
+ (NSInteger)extractNumberSuffixFromKey:(NSString *)key
{
    NSString *numberSuffix;
    NSScanner *scanner = [[NSScanner alloc] initWithString:key];
    [scanner scanUpToString:[FORMAT_IMAGE_NUMBER_SUFFIX substringToIndex:1] intoString:nil];
    [scanner scanUpToString:@"." intoString:&numberSuffix];

    numberSuffix = [numberSuffix substringFromIndex:2]; // This will drop the _i from the beginning

    return [numberSuffix integerValue];
}

+ (NSString *)extractImageTagFromKey:(NSString *)key
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:key];

    // throw away the first two parts of the key
    [scanner scanUpToString:@"." intoString:nil];
    [scanner scanString:@"."     intoString:nil];

    NSString *imageTag;
    [scanner scanUpToString:@"." intoString:&imageTag];
    return imageTag;
}

@end
