//
//  LocalEncryptedCredentialsProvider.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/AmazonCredentialsProvider.h>

/// Securely stores credentials in a local file.
@interface LocalEncryptedCredentialsProvider : NSObject <AmazonCredentialsProvider>

-(BOOL)storeCredentials:(AmazonCredentials *)credentials
                withKey:(NSString *)key;

-(AmazonCredentials *)retrieveCredentialsWithKey:(NSString *)key;

@end
