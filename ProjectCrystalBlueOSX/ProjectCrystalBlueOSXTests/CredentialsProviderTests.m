//
//  CredentialsProviderTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocalEncryptedCredentialsProvider.h"
#import "AmazonCredentialsEncodable.h"

@interface CredentialsProviderTests : XCTestCase

@end

@implementation CredentialsProviderTests {
    AmazonCredentials *testCredentials;
    NSString *localKey;
}

- (void)setUp
{
    [super setUp];
    NSString *accessKey = @"DummyAccessKey1234567890";
    NSString *secretKey = @"SuperSecretDummyKey0987654321";
    testCredentials = [[AmazonCredentials alloc] initWithAccessKey:accessKey
                                                                        withSecretKey:secretKey];

    localKey = @"abcd123";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEncodeDecodeAmazonCredentialsEncodable
{
    AmazonCredentialsEncodable *credentials = [[AmazonCredentialsEncodable alloc] initFromAmazonCredentials:testCredentials];
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:credentials];
    AmazonCredentialsEncodable *decodedCredentials = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    AmazonCredentials *actual = [decodedCredentials asAmazonCredentials];

    XCTAssertTrue([actual.accessKey isEqualToString:testCredentials.accessKey]);
    XCTAssertTrue([actual.secretKey isEqualToString:testCredentials.secretKey]);
}

- (void)testReadAndWriteToFile
{
    LocalEncryptedCredentialsProvider *credentialsProvider = [[LocalEncryptedCredentialsProvider alloc] init];
    [credentialsProvider storeCredentials:testCredentials withKey:localKey];
    AmazonCredentials *actual = [credentialsProvider retrieveCredentialsWithKey:localKey];

    XCTAssertTrue([actual.accessKey isEqualToString:testCredentials.accessKey]);
    XCTAssertTrue([actual.secretKey isEqualToString:testCredentials.secretKey]);
}

@end
