//
//  LocalEncryptedCredentialsProvider.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LocalEncryptedCredentialsProvider.h"
#import "AmazonCredentialsEncodable.h"
#import "CredentialsInputWindowController.h"
#import "FileSystemUtils.h"

#define filename @"credentials"

@implementation LocalEncryptedCredentialsProvider

@synthesize filepath;
@synthesize localKey;

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
    return [self retrieveCredentialsWithKey:localKey];
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
    // Store the localKey
    localKey = key;

    AmazonCredentialsEncodable *encodableCredentials = [[AmazonCredentialsEncodable alloc] initFromAmazonCredentials:credentials];
    NSData *credentialsAsData = [NSKeyedArchiver archivedDataWithRootObject:encodableCredentials];

    BOOL writeSuccess = [credentialsAsData writeToFile:filepath
                                            atomically:YES];
    return writeSuccess;
}

/// Retrieve keys from the local storage location.
-(AmazonCredentials *)retrieveCredentialsWithKey:(NSString *)key
{
    if (![self credentialsStoreFileExists]) {
        return [[AmazonCredentials alloc] initWithAccessKey:@"dummy"
                                              withSecretKey:@"dummy"];
    }

    localKey = key;
    NSData *dataFromFile = [NSData dataWithContentsOfFile:filepath];

    AmazonCredentialsEncodable *decodedCredentials = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromFile];
    return [decodedCredentials asAmazonCredentials];
}

+(LocalEncryptedCredentialsProvider *)sharedInstance {
    static LocalEncryptedCredentialsProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end