//
//  CredentialsEncryptionTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CredentialsEncryption.h"
#import "AmazonCredentialsEncodable.h"

@interface CredentialsEncryptionTests : XCTestCase

@end

@implementation CredentialsEncryptionTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEncryptAndDecryptString
{
    const unsigned long numberOfTests = 5;

    for (unsigned long i = 0; i < numberOfTests; ++i) {
        // Generate a random key
        const NSString *key = [[[NSUUID alloc] init] UUIDString];

        // Generate random information to be encrypted
        const NSString *stringToEncode = [[[NSUUID alloc] init] UUIDString];

        // Turn the string into data
        const NSData *dataToEncrypt = [NSKeyedArchiver archivedDataWithRootObject:stringToEncode];

        // Encrypt it
        const NSData *encryptedData = [CredentialsEncryption encryptData:dataToEncrypt
                                                                 WithKey:key];

        // Decrypt it
        const NSData *decryptedData = [CredentialsEncryption decryptData:encryptedData
                                                                 WithKey:key];

        // We expect this to be the same as the data the we sent to be encrypted in the first place.
        XCTAssertTrue([dataToEncrypt isEqualTo:decryptedData]);

        // We should also be able to retrieve the string that we originally entered.
        const NSString *decryptedString = [NSKeyedUnarchiver unarchiveObjectWithData:[decryptedData copy]];
        XCTAssertTrue([decryptedString isEqualToString:[stringToEncode copy]]);
    }
}

- (void)testEncryptAndDecryptAmazonCredentials
{
    const unsigned long numberOfTests = 3;

    for (unsigned long i = 0; i < numberOfTests; ++i) {
        // Generate a random key
        const NSString *key = [[[NSUUID alloc] init] UUIDString];

        // Generate random information to be encrypted
        AmazonCredentialsEncodable *credentialsToEncode = [[AmazonCredentialsEncodable alloc] init];
        [credentialsToEncode setSecretKey:[[[NSUUID alloc] init] UUIDString]];
        [credentialsToEncode setAccessKey:[[[NSUUID alloc] init] UUIDString]];

        // Turn the string into data
        const NSData *dataToEncrypt = [NSKeyedArchiver archivedDataWithRootObject:credentialsToEncode];

        // Encrypt it
        const NSData *encryptedData = [CredentialsEncryption encryptData:dataToEncrypt
                                                                 WithKey:key];

        // Decrypt it
        const NSData *decryptedData = [CredentialsEncryption decryptData:encryptedData
                                                                 WithKey:key];

        // We expect this to be the same as the data the we sent to be encrypted in the first place.
        XCTAssertTrue([dataToEncrypt isEqualTo:decryptedData]);

        // We should also be able to retrieve the string that we originally entered.
        const AmazonCredentialsEncodable *decryptedCredentials = [NSKeyedUnarchiver unarchiveObjectWithData:[decryptedData copy]];
        XCTAssertTrue([decryptedCredentials.secretKey isEqualToString:credentialsToEncode.secretKey]);
        XCTAssertTrue([decryptedCredentials.accessKey isEqualToString:credentialsToEncode.accessKey]);
    }
}

@end
