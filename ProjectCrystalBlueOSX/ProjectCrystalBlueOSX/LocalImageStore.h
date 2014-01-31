//
//  LocalImageStore.h
//  ProjectCrystalBlueOSX
//
//  Handles local image storage for a CloudImageStore.
//  This should not be used directly by any class other than a CloudImageStore implementation.
//
//  Created by Logan Hood on 1/28/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalImageStore : NSObject

/** The directory where images are being stored on the device.
 */
+(NSString *)localDirectory;

/** Retrieve the image associated with a given key.
 */
+(NSImage *)getImageForKey:(NSString *)key;

/** Checks if the LocalImageStore already has an image for the given key.
 *  For example, this should always be used before assigning a key to a new image.
 */
+(BOOL)imageExistsForKey:(NSString *)key;

/** Add a new image to the LocalImageStore with the given unique key.
 *
 *  The key absolutely positively *MUST* be unique across all devices.
 *
 *  Returns YES if the put operation is successful; NO if it is unsuccessful.
 *  Generally, the only reason this should be unsuccessful is if the key is not unique
 *  or the device disk cannot be written to.
 *
 *  This only guarantees that the image has been added to a LOCAL image storage; not necessarily
 *  to the cloud storage location.
 */
+(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key;

/** Removes an image from local storage. This is mostly for testing purposes - we probably should never need
 *  to remove images from the ImageStore. This could cause major issues if an image is deleted locally but
 *  still exists on S3.
 */
+(BOOL)deleteImageWithKey:(NSString *)key;

/** This will delete ALL local image data. No images are available until resynchronizing with the online database.
 *
 *  DO NOT CALL THIS METHOD LIGHTLY.
 *  Resyncing the images will likely take a lot of time. (and will certainly eat up a lot of bandwidth)
 */
+(void)flushLocalImageStore;

@end
