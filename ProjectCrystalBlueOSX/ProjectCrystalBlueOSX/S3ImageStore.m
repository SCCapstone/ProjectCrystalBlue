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
#import "S3Utils.h"
#import "ImageUtils.h"
#import "LocalImageStore.h"
#import "HardcodedCredentialsProvider.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"S3ImageStore"
#define BUCKET_NAME @"project-crystal-blue-test"
#define JPEG_COMPRESSION 0.90f

@implementation S3ImageStore

-(id)initWithLocalDirectory:(NSString *)directory
{
    self = [super initWithLocalDirectory:directory];
    
    if (self) {
        localStore = [[LocalImageStore alloc] initWithLocalDirectory:directory];
        dirtyKeys = [[DirtyKeySet alloc] initInDirectory:directory];
        
        NSObject<AmazonCredentialsProvider> *credentialsProvider = [[HardcodedCredentialsProvider alloc] init];
        s3Client = [[AmazonS3Client alloc] initWithCredentialsProvider:credentialsProvider];
        
        @try {
            // Check if our bucket exists
            S3Bucket *bucket = [S3Utils findBucketWithName:BUCKET_NAME
                                               usingClient:s3Client];
            
            if (!bucket) {
                DDLogInfo(@"%@: Creating bucket %@", CLASS_NAME, BUCKET_NAME);
                [s3Client createBucketWithName:BUCKET_NAME];
            }
        }
        @catch (NSException *exception) {
            DDLogInfo(@"%@: Could not init S3Client - probably because the device could not connect to S3.", CLASS_NAME);
            DDLogDebug(@"%@: Exception: %@ with reason: %@", CLASS_NAME, [exception name], [exception reason]);
        }
    }
    
    return self;
}

-(BOOL)synchronizeWithCloud
{
    if ([[dirtyKeys allKeys] count] == (unsigned long)0) {
        return YES;
    } else {
        return NO;
    }
}

-(NSImage *)getImageForKey:(NSString *)key
{
    DDLogInfo(@"%@: Retrieving image for key %@", CLASS_NAME, key);
    
    // First check the local image database
    if ([localStore imageExistsForKey:key]) {
        DDLogDebug(@"%@: Image found in the local ImageStore", CLASS_NAME);
        return [localStore getImageForKey:key];
    }
    
    // Otherwise, try to retrieve image from S3.
    S3GetObjectRequest *request = [[S3GetObjectRequest alloc] initWithKey:key
                                                               withBucket:BUCKET_NAME];
    NSImage *image;
    @try {
        DDLogDebug(@"%@: Sending request for image to S3", CLASS_NAME);
        S3GetObjectResponse *response = [s3Client getObject:request];
        
        if ([response error]) {
            DDLogInfo(@"%@: %@", CLASS_NAME, [response error]);
            image = [self.class defaultImage];
        } else if (![S3Utils contentTypeIsImage:[response contentType]]) {
            DDLogError(@"%@: rejecting the object for key %@ because the MIME content type was not a valid image: %@",
                  CLASS_NAME, key, [response contentType]);
            image = [self.class defaultImage];
        } else {
            DDLogDebug(@"%@: Image successfully retrieved from S3!", CLASS_NAME);
            image = [[NSImage alloc] initWithData:[response body]];
            // Store this retrieved image in the local store.
            [localStore putImage:image forKey:key];
        }
    }
    @catch (NSException *exception) {
        DDLogError(@"%@: Exception: %@ ; Reason %@", CLASS_NAME, [exception name], [exception reason]);
        image = [self.class defaultImage];
    }
    @finally {
        return image;
    }
}

-(BOOL)imageExistsForKey:(NSString *)key
{
    return NO;
}

-(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key
{
    DDLogInfo(@"%@: Putting image for key %@", CLASS_NAME, key);
    
    // Add the image locally.
    [localStore putImage:image forKey:key];
    
    DDLogInfo(@"%@: Uploading image for key %@", CLASS_NAME, key);
    
    NSData *imageJPEGData = [ImageUtils JPEGDataFromImage:image withCompression:JPEG_COMPRESSION];
    
    // Set up and set the request.
    S3PutObjectRequest *request = [[S3PutObjectRequest alloc] initWithKey:key inBucket:BUCKET_NAME];
    [request setData:imageJPEGData];
    [request setContentType:@"image/jpeg"];
    
    @try {
        S3PutObjectResponse *response = [s3Client putObject:request];
        if ([response error]) {
            DDLogError(@"%@: %@", CLASS_NAME, [response error]);
            return NO;
        } else {
            DDLogDebug(@"%@: Successfully uploaded image for key %@ to S3!", CLASS_NAME, key);
            return YES;
        }
    }
    @catch (NSException *exception) {
        DDLogInfo(@"%@: Couldn't upload image to S3 because of an exception. Probably the client is offline.", CLASS_NAME);
        DDLogDebug(@"%@: Exception: %@ ; Reason %@", CLASS_NAME, [exception name], [exception reason]);
        [dirtyKeys add:key];
    }
}

-(BOOL)deleteImageWithKey:(NSString *)key
{
    S3DeleteObjectRequest *request = [[S3DeleteObjectRequest alloc] init];
    [request setKey:key];
    [request setBucket:BUCKET_NAME];
    
    S3DeleteObjectResponse *response = [s3Client deleteObject:request];
    if ([response error]) {
        DDLogError(@"%@: %@", CLASS_NAME, [response error]);
        return NO;
    } else {
        DDLogInfo(@"%@: Successfully deleted image for key %@ from S3!", CLASS_NAME, key);
        
        // Now delete the image locally.
        [localStore deleteImageWithKey:key];
        return YES;
    }
}

-(BOOL)keyIsDirty:(NSString *)key
{
    if (![self imageExistsForKey:key]) {
        return NO;
    }
    
    return [dirtyKeys contains:key];
}

-(void)flushLocalImageStore
{
    [localStore flushLocalImageData];
}

@end
