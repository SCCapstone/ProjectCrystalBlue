//
//  LocalEncryptedCredentialsProvider.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/AmazonCredentialsProvider.h>
@class CredentialsInputWindowController;

/// Securely stores credentials in a local file.
@interface LocalEncryptedCredentialsProvider : NSObject <AmazonCredentialsProvider>

/// Filepath to the credentials file.
/// By default, the file is stored at "~/Library/Application Support/CrystalBlue/credentials".
/// Only change this property if we need to store the credentials file in a different location
/// (e.g. for testing).
@property NSString *filepath;

/// For a session, we can keep the local key in memory.
@property NSString *localKey;

+(LocalEncryptedCredentialsProvider *)sharedInstance;

-(BOOL)storeCredentials:(AmazonCredentials *)credentials
                withKey:(NSString *)key;

-(AmazonCredentials *)retrieveCredentialsWithKey:(NSString *)key;

-(BOOL)credentialsStoreFileExists;

@end