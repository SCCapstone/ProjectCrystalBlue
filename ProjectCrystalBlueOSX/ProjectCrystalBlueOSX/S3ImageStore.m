//
//  S3ImageStore.m
//  ProjectCrystalBlueOSX
//
//  Image store implementation using Amazon's Simple Storage Service (S3).
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "S3ImageStore.h"

@implementation S3ImageStore

+(BOOL)synchronizeWithCloud
{
    return NO;
}

+(NSImage *)getImageForKey:(NSString *)key
{
    return nil;
}

+(BOOL)imageExistsForKey:(NSString *)key
{
    return NO;
}

+(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key
{
    return NO;
}

+(BOOL)keyIsDirty:(NSString *)key
{
    return NO;
}

+(void)flushLocalImageStore
{
    
}

@end
