//
//  HardcodedCredentialsProvider.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/AmazonCredentialsProvider.h>

// TEMPORARILY HARD-CODING CREDENTIALS for test purposes.
// This is obviously a huge security issue and cannot be in the Beta version.
@interface HardcodedCredentialsProvider : NSObject <AmazonCredentialsProvider>

-(AmazonCredentials *)credentials;

@end