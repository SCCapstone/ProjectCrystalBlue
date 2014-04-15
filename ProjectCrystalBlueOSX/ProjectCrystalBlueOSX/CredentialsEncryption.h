//
//  CredentialsEncryption.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredentialsEncryption : NSObject

+ (NSData *)encryptData:(const NSData *)plaintextData
                WithKey:(const NSString *)key;

+ (NSData *)decryptData:(const NSData *)encryptedData
                WithKey:(const NSString *)key;

@end
