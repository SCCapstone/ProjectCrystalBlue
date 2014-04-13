//
//  AmazonCredentialsEncodable.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AmazonCredentialsEncodable.h"
#import <AWSiOSSDK/AmazonCredentials.h>

#define K_ACCESS_KEY @"accessKey"
#define K_SECRET_KEY @"secretKey"

@implementation AmazonCredentialsEncodable

-(instancetype)initFromAmazonCredentials:(AmazonCredentials *)credentials
{
    self = [super init];
    if (self) {
        self.accessKey = credentials.accessKey;
        self.secretKey = credentials.secretKey;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *decodedAccessKey = [aDecoder decodeObjectOfClass:[NSString class]
                                                        forKey:K_ACCESS_KEY];
    NSString *decodedSecretkey = [aDecoder decodeObjectOfClass:[NSString class]
                                                        forKey:K_SECRET_KEY];
    self = [self init];
    [self setAccessKey:decodedAccessKey];
    [self setSecretKey:decodedSecretkey];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.accessKey forKey:K_ACCESS_KEY];
    [aCoder encodeObject:self.secretKey forKey:K_SECRET_KEY];
}

-(AmazonCredentials *)asAmazonCredentials
{
    return [[AmazonCredentials alloc] initWithAccessKey:self.accessKey
                                          withSecretKey:self.secretKey];
}

+(BOOL)supportsSecureCoding
{
    return [NSString supportsSecureCoding];
}

@end
