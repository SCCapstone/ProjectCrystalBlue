//
//  S3ImageStore.m
//  ProjectCrystalBlueOSX
//
//  Image store implementation backed by Amazon's Simple Storage Service (S3).
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "S3ImageStore.h"

BOOL singletonInstantiated = NO;

@implementation S3ImageStore

+(void)setUpSingleton
{
    singletonInstantiated = YES;
}

+(BOOL)synchronizeWithCloud
{
    if (!singletonInstantiated) {
        [self.class setUpSingleton];
    }
    return NO;
}

+(NSImage *)getImageForKey:(NSString *)key
{
    if (!singletonInstantiated) {
        [self.class setUpSingleton];
    }
    return [self.class defaultImage];
}

+(BOOL)imageExistsForKey:(NSString *)key
{
    if (!singletonInstantiated) {
        [self.class setUpSingleton];
    }
    return NO;
}

+(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key
{
    if (!singletonInstantiated) {
        [self.class setUpSingleton];
    }
    return NO;
}

+(BOOL)keyIsDirty:(NSString *)key
{
    if (!singletonInstantiated) {
        [self.class setUpSingleton];
    }
    return NO;
}

+(void)flushLocalImageStore
{
    if (!singletonInstantiated) {
        [self.class setUpSingleton];
    }
    
}

+(NSImage *)defaultImage
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"no_image" ofType:@"png"];
    NSImage *defImage = [[NSImage alloc] initWithContentsOfFile:path];
    return defImage;
}

@end
