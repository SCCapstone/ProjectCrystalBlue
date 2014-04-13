//
//  AmazonCredentialsEncodable.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AmazonCredentials;

/// Wrapper class since AmazonCredentials are not encodable. This shouldn't be used externally,
/// but really only for LocalEncryptedCredentialsProvider.
@interface AmazonCredentialsEncodable : NSObject <NSSecureCoding>

@property NSString *accessKey;
@property NSString *secretKey;

-(instancetype)initFromAmazonCredentials:(AmazonCredentials *)credentials;

-(AmazonCredentials *)asAmazonCredentials;

@end