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
#import "AbstractCloudImageStore.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>

@interface S3ImageStore : AbstractCloudImageStore {
    AmazonS3Client *s3Client;
    AbstractImageStore *localStore;
    NSMutableSet *dirtyKeys;
}

@end
