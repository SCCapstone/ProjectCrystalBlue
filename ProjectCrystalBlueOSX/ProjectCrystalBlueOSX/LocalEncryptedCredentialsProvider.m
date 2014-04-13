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
    return nil;
}

-(void)refresh {

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

/// Attempts to retrieve keys from the local storage location.
/// Returns nil if keys cannot be obtained.
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