//
//  SourceImageUtils.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceImageUtils.h"
#import "S3ImageStore.h"
#import "AbstractLibraryObjectStore.h"
#import "Source.h"
#import "SourceConstants.h"
#import "FileSystemUtils.h"
#import "DDLog.h"
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/* 
 *  General format used is:
 *
 *  SOURCE-KEY_i###.TAG.jpg
 *
 *  Some examples:
 *  "sourceKey_i000.NearOutcrop.jpg"
 *  "sourceKey_i001.MicroscopeSlide.jpg"
 *  "sourceKey_i002.MicroscopeSlide.jpg" (tags don't have to be unique)
 *  "sourceKey_i003.jpg"                 (tags are completely optional)
 */
#define FORMAT_IMAGE_KEY @"%@%@%@%@"
#define FORMAT_IMAGE_NUMBER_SUFFIX @"_i%03d"
#define FORMAT_IMAGE_TAG @".%@"
#define DEFAULT_IMAGE_EXTENSION @".jpg"
#define DEFAULT_IMAGE_TAG @"NoTag"

@implementation SourceImageUtils

+ (AbstractImageStore *)defaultImageStore
{
    return [[S3ImageStore alloc] initWithLocalDirectory:[FileSystemUtils localImagesDirectory]];
}

+ (NSArray *)imageKeysForSource:(Source *)source
{
    NSMutableArray *keys = [[NSMutableArray alloc] init];

    NSString *commaSeparatedImageKeys = [source.attributes objectForKey:SRC_IMAGES];
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

+ (NSArray *)imagesForSource:(Source *)source
                inImageStore:(AbstractImageStore *)imageStore
{
    NSArray *keys = [self.class imageKeysForSource:source];
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
          forSource:(Source *)source
        inDataStore:(AbstractLibraryObjectStore *)dataStore
       inImageStore:(AbstractImageStore *)imageStore
{
    NSMutableArray *imageKeysForSource;
    imageKeysForSource = [NSMutableArray arrayWithArray:[self.class imageKeysForSource:source]];

    if (![imageKeysForSource containsObject:imageKey]) {
        return NO;
    }

    [imageKeysForSource removeObject:imageKey];
    NSMutableString *newImagesString = [[NSMutableString alloc] init];

    for (int i = 0; i < imageKeysForSource.count; ++i) {
        if (i == 0) {
            // For the first image, we don't want to separate with a comma.
            [newImagesString appendFormat:@"%@", [imageKeysForSource objectAtIndex:i]];
        } else {
            [newImagesString appendFormat:@"%@%@", IMAGE_LIST_DELIMITER,
                                                   [imageKeysForSource objectAtIndex:i]];
        }
    }

    [source.attributes setObject:newImagesString forKey:SRC_IMAGES];

    BOOL success = YES;
    success = success && [imageStore deleteImageWithKey:imageKey];
    success = success && [dataStore updateLibraryObject:source
                                              IntoTable:[SourceConstants tableName]];

    return success;
}

+ (BOOL)removeAllImagesForSource:(Source *)source
                     inDataStore:(AbstractLibraryObjectStore *)dataStore
                    inImageStore:(AbstractImageStore *)imageStore
{
    NSArray *imageKeys = [self.class imageKeysForSource:source];
    BOOL success = YES;
    for (NSString *imageKey in imageKeys) {
        const BOOL deletionSuccess = [imageStore deleteImageWithKey:imageKey];
        if (!deletionSuccess) {
            success = NO;
        }
    }

    [source.attributes setObject:@"" forKey:SRC_IMAGES];

    const BOOL updateSourceSuccess = [dataStore updateLibraryObject:source
                                                          IntoTable:[SourceConstants tableName]];
    if (!updateSourceSuccess) {
        success = NO;
    }

    return success;
}

+ (BOOL)addImage:(NSImage *)image
       forSource:(Source *)source
     inDataStore:(AbstractLibraryObjectStore *)dataStore
  intoImageStore:(AbstractImageStore *)imageStore
{
    return [self.class addImage:image
                      forSource:source
                    inDataStore:dataStore
                   withImageTag:DEFAULT_IMAGE_TAG
                 intoImageStore:imageStore];
}

+ (BOOL)addImage:(NSImage *)image
       forSource:(Source *)source
     inDataStore:(AbstractLibraryObjectStore *)dataStore
    withImageTag:(NSString *)tag
  intoImageStore:(AbstractImageStore *)imageStore
{
    NSString *sourceKey = source.key;
    NSString *imageNumber = [self.class nextUniqueImageNumberForSource:source];
    NSString *formattedTag = [NSString stringWithFormat:FORMAT_IMAGE_TAG, tag];
    NSString *extension = DEFAULT_IMAGE_EXTENSION;

    NSString *key = [NSString stringWithFormat:FORMAT_IMAGE_KEY,
                                               sourceKey,
                                               imageNumber,
                                               formattedTag,
                                               extension];

    [self.class appendImageKey:key
                      toSource:source];

    BOOL tableUpdated = [dataStore updateLibraryObject:source
                                             IntoTable:[SourceConstants tableName]];
    BOOL imageUploaded = [imageStore putImage:image forKey:key];

    return (tableUpdated && imageUploaded);
}

// Some "private" helper methods.

/// Appends another image key to a source. This is applied in-place to the source object in memory,
/// so the source still needs to be updated in the appropriate data store.
///
/// Note that this method is NOT idempotent - calling multiple times will cause the same image key
/// to be appended multiple times!
+ (BOOL)appendImageKey:(NSString *)imageKey
              toSource:(Source *)source
{
    NSString *keys = [source.attributes objectForKey:SRC_IMAGES];

    if (keys.length <= 0) {
        [source.attributes setObject:imageKey forKey:SRC_IMAGES];
        return YES;
    } else {
        NSString *newKeys = [keys stringByAppendingFormat:@"%@%@", IMAGE_LIST_DELIMITER, imageKey];
        [source.attributes setObject:newKeys forKey:SRC_IMAGES];
        return YES;
    }
}

/// Finds the next valid image number for a provided source.
/// For example, if "sourcekey_i001" already exists, then "_i002" would be returned.
+ (NSString *)nextUniqueImageNumberForSource:(Source *)source
{
    NSArray *existingKeys = [self.class imageKeysForSource:source];

    if (existingKeys.count <= 0) {
        return [NSString stringWithFormat:FORMAT_IMAGE_NUMBER_SUFFIX, 0];
    }

    NSString *mostRecentImageKey = [existingKeys lastObject];
    NSInteger newValue  = [self.class extractNumberSuffixFromKey:mostRecentImageKey] + 1;

    return [NSString stringWithFormat:FORMAT_IMAGE_NUMBER_SUFFIX, (int)newValue];

    return @"";
}

/// Assuming a key with a format that looks something like this:
///     SOURCEKEY_i123.jpg
///     or
///     SOURCEKEY_i123.IMAGETAG.jpg
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
