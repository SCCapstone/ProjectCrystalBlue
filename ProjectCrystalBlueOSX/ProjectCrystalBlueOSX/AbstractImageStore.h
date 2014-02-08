//
//  AbstractImageStore.h
//  ProjectCrystalBlueOSX
//
//  Abstract superclass for any class that handles image storage.
//  Each image item must be associated with a unique key.
//
//  Created by Logan Hood on 1/31/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractImageStore : NSObject

-(id)initWithLocalDirectory:(NSString *)directory;

/** Retrieve the image associated with a given key.
 */
-(NSImage *)getImageForKey:(NSString *)key;

/** Delete an image from the ImageStore. Return whether the deletion is successful.
 */
-(BOOL)deleteImageWithKey:(NSString *)key;

/** Checks if the CloudImageStore already has an image for the given key.
 *  For example, this should always be used before assigning a key to a new image.
 */
-(BOOL)imageExistsForKey:(NSString *)key;

/** Add a new image to the CloudImageStore with the given unique key.
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
-(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key;

/** This will delete ALL local image data. No images are available until resynchronizing with the online database.
 *
 *  DO NOT CALL THIS METHOD LIGHTLY.
 *  Resyncing the images will likely take a lot of time. (and will certainly eat up a metric fuckton of bandwidth)
 */
-(void)flushLocalImageData;

/** A default image to be used if no image can be retrieved.
 */
+(NSImage *)defaultImage;

@end
