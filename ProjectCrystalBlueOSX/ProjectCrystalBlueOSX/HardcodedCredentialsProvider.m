//
//  HardcodedCredentialsProvider.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "HardcodedCredentialsProvider.h"

// TEMPORARILY HARD-CODING CREDENTIALS for test purposes.
// This is obviously a huge security issue and cannot be in the Beta version.
@implementation HardcodedCredentialsProvider

-(AmazonCredentials *)credentials {
    AmazonCredentials *login = [[AmazonCredentials alloc] initWithAccessKey:@"AKIAIAWCA532UPYBPVAA"
                                                              withSecretKey:@"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"];
    
    return login;
}

-(void)refresh {
    
}

@end
