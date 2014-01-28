//
//  S3ImageStore.h
//  ProjectCrystalBlueOSX
//
//  Image store implementation using Amazon's Simple Storage Service (S3).
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudImageStore.h"

@interface S3ImageStore : NSObject <CloudImageStore>

/// Does all initialization of the singleton backing this class.
+(void)setUpSingleton;

/** Synchronize any new changes with the S3 database.
 *  This should get any new images that have been created on other devices, as well as
 *  upload any images that have been created on this device.
 *
 *  Returns whether S3 was reachable.
 */
+(BOOL)synchronizeWithCloud;

/** Retrieve the image associated with a given key.
 */
+(NSImage *)getImageForKey:(NSString *)key;

/** Checks if the ImageStore already has an image for the given key.
 *  For example, this should always be used before assigning a key to a new image.
 */
+(BOOL)imageExistsForKey:(NSString *)key;

/** Add a new image to the ImageStore with the given unique key.
 *
 *  The key absolutely positively *MUST* be unique across all devices.
 *
 *  Returns YES if the put operation is successful; NO if it is unsuccessful.
 *  Generally, the only reason this should be unsuccessful is if the key is not unique
 *  or the device disk cannot be written to.
 *
 *  This only guarantees that the image has been added to the LOCAL ImageStore; not necessarily
 *  to the cloud storage location.
 */
+(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key;

/** Removes an image from S3. This is mostly for testing purposes - we probably should never need
 *  to remove images from the ImageStore.
 */
+(BOOL)deleteImageWithKey:(NSString *)key;

/** Check whether the image associated with a given key is "dirty" - i.e. is not synced with the cloud ImageStore.
 *
 *  Returns NO
 *      -if the image associated with that key has already been synced.
 *      -if there is not an image associated with that key.
 *
 *  Returns YES
 *      -if the image was collected while the device was offline, and synchronizeWithCloud has not been called since then.
 */
+(BOOL)keyIsDirty:(NSString *)key;

/** This will delete ALL local image data. No images are available until resynchronizing with the online database.
 *
 *  DO NOT CALL THIS METHOD LIGHTLY.
 *  Resyncing the images will likely take a lot of time. (and will certainly eat up a metric fuckton of bandwidth)
 */
+(void)flushLocalImageStore;

/** A default image that can be shown if no image can be retrieved.
 *
 */
+(NSImage *)defaultImage;

@end
