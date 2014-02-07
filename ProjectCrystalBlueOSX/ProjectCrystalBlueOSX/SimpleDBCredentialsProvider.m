//
//  SimpleDBCredentialsProvider.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SimpleDBCredentialsProvider.h"

@implementation SimpleDBCredentialsProvider

-(AmazonCredentials *)credentials
{
    AmazonCredentials *login = [[AmazonCredentials alloc] initWithAccessKey:@"access key here"
                                                              withSecretKey:@"secret key here"];
    return login;
}

-(void)refresh
{
    
}

@end
