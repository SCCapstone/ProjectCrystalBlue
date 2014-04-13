//
//  LocalEncryptedCredentialsProvider.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LocalEncryptedCredentialsProvider.h"
#import "AmazonCredentialsEncodable.h"

#define filename @"credentials"

@implementation LocalEncryptedCredentialsProvider

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
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *localDirectory = [documentDirectory stringByAppendingFormat:@"/%@", @"PCB_temp"];

    [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];

    NSString *fullLocalPath = [localDirectory stringByAppendingFormat:@"/%@", filename];
    return [[NSFileManager defaultManager] fileExistsAtPath:fullLocalPath];
}

/// Stores credentials in the local storage location,
/// encrypted with the provided key.
-(BOOL)storeCredentials:(AmazonCredentials *)credentials
                withKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *localDirectory = [documentDirectory stringByAppendingFormat:@"/%@", @"PCB_temp"];

    [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];

    NSString *fullLocalPath = [localDirectory stringByAppendingFormat:@"/%@", filename];
    AmazonCredentialsEncodable *encodableCredentials = [[AmazonCredentialsEncodable alloc] initFromAmazonCredentials:credentials];
    NSData *credentialsAsData = [NSKeyedArchiver archivedDataWithRootObject:encodableCredentials];

    BOOL writeSuccess = [credentialsAsData writeToFile:fullLocalPath atomically:YES];
    return writeSuccess;
}

/// Retrieve keys from the local storage location.
-(AmazonCredentials *)retrieveCredentialsWithKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *localDirectory = [documentDirectory stringByAppendingFormat:@"/%@", @"PCB_temp"];

    [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];


    NSString *fullLocalPath = [localDirectory stringByAppendingFormat:@"/%@", filename];
    NSData *dataFromFile = [NSData dataWithContentsOfFile:fullLocalPath];

    AmazonCredentialsEncodable *decodedCredentials = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromFile];
    return [decodedCredentials asAmazonCredentials];
}

@end