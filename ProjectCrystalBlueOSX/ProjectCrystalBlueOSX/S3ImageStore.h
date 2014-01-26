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
#import "ImageStore.h"

@interface S3ImageStore : NSObject <ImageStore>

+(BOOL)synchronizeWithCloud;

+(NSImage *)getImageForKey:(NSString *)key;

+(BOOL)imageExistsForKey:(NSString *)key;

+(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key;

+(BOOL)keyIsDirty:(NSString *)key;

+(void)flushLocalImageStore;

@end
