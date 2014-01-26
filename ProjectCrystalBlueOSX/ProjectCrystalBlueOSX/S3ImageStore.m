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
#import <AWSiOSSDK/S3/AmazonS3Client.h>

NSString *const CLASS_NAME = @"S3ImageStore";
NSString *const BUCKET = @"project-crystal-blue-test";

BOOL singletonInstantiated = NO;
AmazonS3Client *s3Client;

@implementation S3ImageStore

+(void)setUpSingleton
{
    if (singletonInstantiated) {
        return;
    }
    
    // TEMPORARILY HARD-CODING CREDENTIALS for test purposes.
    // This is obviously a huge security issue and cannot be in the Beta version.
    AmazonCredentials *login =
    [[AmazonCredentials alloc] initWithAccessKey:@"AKIAIAWCA532UPYBPVAA"
                                   withSecretKey:@"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"];
    
    s3Client = [[AmazonS3Client alloc] initWithCredentials:login];
    
    // Next, check if our bucket exists
    NSArray *buckets = [s3Client listBuckets];
    NSLog(@"%@: Found %lu buckets", CLASS_NAME, (unsigned long)[buckets count]);
    
    bool bucketExists = NO;
    for (S3Bucket *bucket in buckets) {
        if ([[bucket name] isEqualToString:BUCKET]) {
            bucketExists = YES;
            break;
        }
    }
    if (!bucketExists) {
        NSLog(@"%@: Creating bucket %@", CLASS_NAME, BUCKET);
        [s3Client createBucketWithName:BUCKET];
    }
    
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
