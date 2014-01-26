//
//  S3Utils.h
//  ProjectCrystalBlueOSX
//
//  Class to hold some common helper methods.
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import <AWSiOSSDK/S3/S3Bucket.h>

@interface S3Utils : NSObject

/** Uses the provided S3Client to find a bucket with the given name.
 *  Returns nil if such a bucket cannot be found.
 */
+(S3Bucket *)findBucketWithName:(NSString *)bucketName
                    usingClient:(AmazonS3Client *)client;

@end