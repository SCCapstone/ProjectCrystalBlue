//
//  S3Utils.m
//  ProjectCrystalBlueOSX
//
//  Class to hold some common helper methods.
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "S3Utils.h"

@implementation S3Utils

+(S3Bucket *)findBucketWithName:(NSString *)bucketName
                    usingClient:(AmazonS3Client *)client
{
    NSArray *buckets = [client listBuckets];
    
    for (S3Bucket *bucket in buckets) {
        if ([[bucket name] isEqualToString:bucketName]) {
            return bucket;
        }
    }

    return nil;
}

@end
