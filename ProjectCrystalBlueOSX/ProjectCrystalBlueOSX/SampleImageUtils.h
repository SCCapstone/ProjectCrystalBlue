//
//  SampleImageUtils.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Sample;
@class AbstractImageStore;
@class AbstractLibraryObjectStore;

/// Delimiter used to separate image keys in the database.
static const NSString *IMAGE_LIST_DELIMITER = @",";


/// A high-level helper class to provide some common functions on images for samples.
@interface SampleImageUtils : NSObject

/// A shared instance of the default S3 ImageStore.
+ (AbstractImageStore *)defaultImageStore;

/// Returns a list of the image keys that exist for a given sample.
+ (NSArray *)imageKeysForSample:(Sample *)sample;

/// Returns a list of NSImage objects that exist for a given sample.
/// Generally, [SampleImageutils defaultImageStore] should be used for the imageStore argument.
+ (NSArray *)imagesForSample:(Sample *)sample
                inImageStore:(AbstractImageStore *)imageStore;

/// Deletes an image with the specified key and sample. This action cannot be undone.
+ (BOOL)removeImage:(NSString *)imageKey
          forSample:(Sample *)sample
        inDataStore:(AbstractLibraryObjectStore *)dataStore
       inImageStore:(AbstractImageStore *)imageStore;

/// Deletes ALL images associated with a sample and clears the images field in the database.
/// This action cannot be undone.
+ (BOOL)removeAllImagesForSample:(Sample *)sample
                     inDataStore:(AbstractLibraryObjectStore *)dataStore
                    inImageStore:(AbstractImageStore *)imageStore;

/// Adds an image for the given sample. This both uploads the image and updates the dataStore.
/// Generally, [SampleImageutils defaultImageStore] should be used for the imageStore argument.
+ (BOOL)addImage:(NSImage *)image
       forSample:(Sample *)sample
     inDataStore:(AbstractLibraryObjectStore *)dataStore
  intoImageStore:(AbstractImageStore *)imageStore;

/// Adds an image with an optional tag. This both uploads the image and updates the dataStore.
/// Generally, [SampleImageutils defaultImageStore] should be used for the imageStore argument.
+ (BOOL)addImage:(NSImage *)image
       forSample:(Sample *)sample
     inDataStore:(AbstractLibraryObjectStore *)dataStore
    withImageTag:(NSString *)tag
  intoImageStore:(AbstractImageStore *)imageStore;

/// Appends another image key to a sample. This is applied in-place to the sample object in memory,
/// so the sample still needs to be updated in the appropriate data store.
///
/// Generally, this shouldn't be called from external classes. The various "AddImage/ForSample"
/// methods automatically adjust the sample.
///
/// Note that this method is NOT idempotent - calling multiple times will cause the same image key
/// to be appended multiple times!
+ (BOOL)appendImageKey:(NSString *)imageKey
              toSample:(Sample *)sample;

/// Finds the next valid image number for a provided sample.
/// For example, if "samplekey_i001" already exists, then "_i002" would be returned.
+ (NSString *)nextUniqueImageNumberForSample:(Sample *)sample;

/// Assuming a key with a format that looks something like this:
///     SAMPLEKEY_i123.jpg
///     or
///     SAMPLEKEY_i123.IMAGETAG.jpg
///
/// then "123" will be returned.
///
+ (NSInteger)extractNumberSuffixFromKey:(NSString *)key;

/// Assuming a key with a format that looks something like this:
///     SAMPLEKEY_i123.IMAGETAG.jpg
///
/// then "IMAGETAG" will be returned.
///
+ (NSString *)extractImageTagFromKey:(NSString *)key;

@end
