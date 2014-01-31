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

#define CLASS_NAME @"S3ImageStore"
#define BUCKET_NAME @"project-crystal-blue-test"
#define JPEG_COMPRESSION 0.90f

@implementation S3ImageStore

-(id)initWithLocalDirectory:(NSString *)directory
{
    self = [super initWithLocalDirectory:directory];
    
    if (self) {
        // TEMPORARILY HARD-CODING CREDENTIALS for test purposes.
        // This is obviously a huge security issue and cannot be in the Beta version.
        AmazonCredentials *login = [[AmazonCredentials alloc] initWithAccessKey:@"AKIAIAWCA532UPYBPVAA"
                                                                  withSecretKey:@"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"];
        
        s3Client = [[AmazonS3Client alloc] initWithCredentials:login];
        
        @try {
            // Check if our bucket exists
            S3Bucket *bucket = [S3Utils findBucketWithName:BUCKET_NAME
                                               usingClient:s3Client];
            
            if (!bucket) {
                NSLog(@"%@: Creating bucket %@", CLASS_NAME, BUCKET_NAME);
                [s3Client createBucketWithName:BUCKET_NAME];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Could not completely set up the %@ singleton - probably because the device could not connect to S3.", CLASS_NAME);
            NSLog(@"Exception: %@ \n   with reason: %@", [exception name], [exception reason]);
        }
    }
    
    return self;
}

-(BOOL)synchronizeWithCloud
{
    return NO;
}

-(NSImage *)getImageForKey:(NSString *)key
{
    NSLog(@"%@: Retrieving image for key %@", CLASS_NAME, key);
    
    S3GetObjectRequest *request = [[S3GetObjectRequest alloc] initWithKey:key
                                                               withBucket:BUCKET_NAME];
    NSImage *image;
    @try {
        NSLog(@"%@: Sending request for image to S3", CLASS_NAME);
        S3GetObjectResponse *response = [s3Client getObject:request];
        
        if ([response error]) {
            NSLog(@"%@: %@", CLASS_NAME, [response error]);
            image = [self.class defaultImage];
        } else if (![S3Utils contentTypeIsImage:[response contentType]]) {
            NSLog(@"%@: rejecting the object for key %@ because the MIME content type was not a valid image: %@",
                  CLASS_NAME, key, [response contentType]);
            image = [self.class defaultImage];
        } else {
            NSLog(@"%@: Image successfully retrieved!", CLASS_NAME);
            image = [[NSImage alloc] initWithData:[response body]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@: Exception was thrown.", CLASS_NAME);
        NSLog(@"Exception: %@ ; Reason %@", [exception name], [exception reason]);
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
    
    NSLog(@"%@: Uploading image for key %@", CLASS_NAME, key);
    
    NSData *imageJPEGData = [ImageUtils JPEGDataFromImage:image withCompression:JPEG_COMPRESSION];
    
    // Set up and set the request.
    S3PutObjectRequest *request = [[S3PutObjectRequest alloc] initWithKey:key inBucket:BUCKET_NAME];
    [request setData:imageJPEGData];
    [request setContentType:@"image/jpeg"];
    
    S3PutObjectResponse *response = [s3Client putObject:request];
    if ([response error]) {
        NSLog(@"%@: %@", CLASS_NAME, [response error]);
        return NO;
    } else {
        NSLog(@"%@: Successfully uploaded image for key %@ to S3!", CLASS_NAME, key);
        return YES;
    }
}

-(BOOL)deleteImageWithKey:(NSString *)key
{
    S3DeleteObjectRequest *request = [[S3DeleteObjectRequest alloc] init];
    [request setKey:key];
    [request setBucket:BUCKET_NAME];
    
    S3DeleteObjectResponse *response = [s3Client deleteObject:request];
    if ([response error]) {
        NSLog(@"%@: %@", CLASS_NAME, [response error]);
        return NO;
    } else {
        NSLog(@"%@: Successfully deleted image for key %@ from S3!", CLASS_NAME, key);
        return YES;
    }
}

-(BOOL)keyIsDirty:(NSString *)key
{
    return NO;
}

-(void)flushLocalImageStore
{
    
}

@end
