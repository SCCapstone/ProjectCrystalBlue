//
//  LocalEncryptedCredentialsProvider.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LocalEncryptedCredentialsProvider.h"
#import "AmazonCredentialsEncodable.h"
#import "FileSystemUtils.h"

#define filename @"credentials"

@implementation LocalEncryptedCredentialsProvider

@synthesize filepath;

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Set the default filepath.
        filepath = [[FileSystemUtils localRootDirectory] stringByAppendingPathComponent:filename];
    }
    return self;
}

-(AmazonCredentials *)credentials
{
    if (![self credentialsStoreFileExists]) {
        // TODO - will replace this with the user manually entering the keys.
        AmazonCredentials *hardcoded = [[AmazonCredentials alloc] initWithAccessKey:@"AKIAIAWCA532UPYBPVAA"
                                                                  withSecretKey:@"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"];
        [self storeCredentials:hardcoded withKey:nil];
    }

    return [self retrieveCredentialsWithKey:nil];
}

-(void)refresh {
    [self credentials];
}

-(BOOL)credentialsStoreFileExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

/// Stores credentials in the local storage location,
/// encrypted with the provided key.
-(BOOL)storeCredentials:(AmazonCredentials *)credentials
                withKey:(NSString *)key
{
    AmazonCredentialsEncodable *encodableCredentials = [[AmazonCredentialsEncodable alloc] initFromAmazonCredentials:credentials];
    NSData *credentialsAsData = [NSKeyedArchiver archivedDataWithRootObject:encodableCredentials];

    BOOL writeSuccess = [credentialsAsData writeToFile:filepath
                                            atomically:YES];
    return writeSuccess;
}

/// Retrieve keys from the local storage location.
-(AmazonCredentials *)retrieveCredentialsWithKey:(NSString *)key
{
    NSData *dataFromFile = [NSData dataWithContentsOfFile:filepath];

    AmazonCredentialsEncodable *decodedCredentials = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromFile];
    return [decodedCredentials asAmazonCredentials];
}

@end