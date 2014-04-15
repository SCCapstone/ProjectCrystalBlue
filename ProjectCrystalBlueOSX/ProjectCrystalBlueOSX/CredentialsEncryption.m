//
//  CredentialsEncryption.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "CredentialsEncryption.h"
#import <Security/SecTransform.h>

@implementation CredentialsEncryption

+ (NSData *)encryptData:(const NSData *)plaintextData
                WithKey:(const NSString *)key
{
    SecKeyRef cryptoKey   = [self.class secKeyRefFromString:key];

    // Create the encrypter with our key
    CFErrorRef error;
    SecTransformRef encrypter = SecEncryptTransformCreate(cryptoKey, &error);

    SecTransformSetAttribute(encrypter, kSecPaddingKey, kSecPaddingPKCS7Key, &error);
    SecTransformSetAttribute(encrypter, kSecTransformInputAttributeName, (__bridge CFTypeRef)(plaintextData), &error);

    NSData *encryptedData = CFBridgingRelease(SecTransformExecute(encrypter, &error));
    return encryptedData;
}

+ (NSData *)decryptData:(const NSData *)encryptedData
                WithKey:(const NSString *)key
{
    SecKeyRef cryptoKey   = [self.class secKeyRefFromString:key];
    CFErrorRef error;
    SecTransformRef decrypter = SecDecryptTransformCreate(cryptoKey, &error);

    SecTransformSetAttribute(decrypter, kSecPaddingKey, kSecPaddingPKCS7Key, &error);
    SecTransformSetAttribute(decrypter, kSecTransformInputAttributeName, CFBridgingRetain(encryptedData), &error);

    NSData *decryptedData = CFBridgingRelease(SecTransformExecute(decrypter, &error));
    return decryptedData;
}

/// Helper method to convert a string into a SecKeyRef.
+ (SecKeyRef)secKeyRefFromString:(const NSString *)key
{
    // First convert our key into a raw byte representation
    const unsigned long keySizeBytes = key.length * sizeof(char);
    void *rawKey = malloc(keySizeBytes);

    NSRange stringRange;
    stringRange.location = 0;
    stringRange.length = key.length;

    [key getBytes:rawKey
        maxLength:keySizeBytes
       usedLength:NULL
         encoding:NSASCIIStringEncoding
          options:NSStringEncodingConversionAllowLossy
            range:stringRange
   remainingRange:NULL];

    // Convert the key into a CFData
    CFDataRef cfCryptoKey = CFDataCreate(kCFAllocatorDefault, rawKey, keySizeBytes);

    // Set up the params
    CFMutableDictionaryRef secKeyParams = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
    CFDictionarySetValue(secKeyParams, kSecAttrKeyType, kSecAttrKeyTypeRC2);

    // Create the key
    CFErrorRef error;
    SecKeyRef cryptoKey = SecKeyCreateFromData(secKeyParams, cfCryptoKey, &error);

    free(rawKey);
    return cryptoKey;
}

@end
