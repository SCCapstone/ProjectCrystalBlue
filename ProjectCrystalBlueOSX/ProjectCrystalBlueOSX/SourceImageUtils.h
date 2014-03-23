//
//  SourceImageUtils.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Source;
@class AbstractImageStore;
@class AbstractLibraryObjectStore;

/// Name of the local storage location for images.
static const NSString *LOCAL_IMAGE_DIRECTORY = @"ProjectCrystalBlueImages";

/// Delimiter used to separate image keys in the database.
static const NSString *IMAGE_LIST_DELIMITER = @",";


/// A high-level helper class to provide some common functions on images for sources.
@interface SourceImageUtils : NSObject

/// A shared instance of the default S3 ImageStore.
+ (AbstractImageStore *)defaultImageStore;

/// Returns a list of the image keys that exist for a given source.
+ (NSArray *)imageKeysForSource:(Source *)source;

/// Returns a list of NSImage objects that exist for a given source.
/// Generally, [SourceImageutils defaultImageStore] should be used for the imageStore argument.
+ (NSArray *)imagesForSource:(Source *)source
                inImageStore:(AbstractImageStore *)imageStore;

/// Adds an image for the given source. This both uploads the image and updates the dataStore.
/// Generally, [SourceImageutils defaultImageStore] should be used for the imageStore argument.
+ (BOOL)addImage:(NSImage *)image
       forSource:(Source *)source
     inDataStore:(AbstractLibraryObjectStore *)dataStore
  intoImageStore:(AbstractImageStore *)imageStore;

/// Adds an image with an optional tag. This both uploads the image and updates the dataStore.
/// Generally, [SourceImageutils defaultImageStore] should be used for the imageStore argument.
+ (BOOL)addImage:(NSImage *)image
       forSource:(Source *)source
     inDataStore:(AbstractLibraryObjectStore *)dataStore
    withImageTag:(NSString *)tag
  intoImageStore:(AbstractImageStore *)imageStore;

/// Appends another image key to a source. This is applied in-place to the source object in memory,
/// so the source still needs to be updated in the appropriate data store.
///
/// Generally, this shouldn't be called from external classes. The various "AddImage/ForSource"
/// methods automatically adjust the source.
///
/// Note that this method is NOT idempotent - calling multiple times will cause the same image key
/// to be appended multiple times!
+ (BOOL)appendImageKey:(NSString *)imageKey
              toSource:(Source *)source;

/// Finds the next valid image number for a provided source.
/// For example, if "sourcekey_i001" already exists, then "_i002" would be returned.
+ (NSString *)nextUniqueImageNumberForSource:(Source *)source;

/// Assuming a key with a format that looks something like this:
///     SOURCEKEY_i123.jpg
///     or
///     SOURCEKEY_i123.IMAGETAG.jpg
///
/// then "123" will be returned.
///
+ (NSInteger)extractNumberSuffixFromKey:(NSString *)key;

@end
