//
//  SimpleDBExample.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/7/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HardcodedCredentialsProvider.h"
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import "SampleConstants.h"

@interface SimpleDBExample : XCTestCase

@end

@implementation SimpleDBExample

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

/**
 *  Example code showing how to use the AmazonSimpleDBClient.
 */

- (void)ignore_testExample
{
    NSObject<AmazonCredentialsProvider> *credentialsProvider = [[HardcodedCredentialsProvider alloc] init];
    AmazonSimpleDBClient *simpleDbClient = [[AmazonSimpleDBClient alloc] initWithCredentialsProvider:credentialsProvider];
    
    NSLog(@"First we list all active 'domains' to confirm there are no domains.");
    NSLog(@"This should be an empty list first.\n");
    // LIST calls are pretty memory/bandwidth intensive so normally we want to minimize these.
    SimpleDBListDomainsRequest *listRequest = [[SimpleDBListDomainsRequest alloc] init];
    SimpleDBListDomainsResponse *listResponse = [simpleDbClient listDomains:listRequest];
    NSLog(@"%@", [listResponse domainNames]);
    
    NSLog(@"Create a domain\n");
    NSString *testDomain = @"TEST_DOMAIN";
    SimpleDBCreateDomainRequest *createRequest = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:testDomain];
    SimpleDBCreateDomainResponse *createResponse = [simpleDbClient createDomain:createRequest];
    if (nil != [createResponse error]) {
        NSLog(@"%@", [createResponse error]);
        XCTFail(@"error creating domain");
    }
    
    NSLog(@"Now when we list the domains, we should see our TEST_DOMAIN in the list.");
    listRequest = [[SimpleDBListDomainsRequest alloc] init];
    listResponse = [simpleDbClient listDomains:listRequest];
    NSLog(@"%@\n", [listResponse domainNames]);
    
    NSLog(@"A SimpleDBItem is analogous to a SQL row");
    NSLog(@"First we need to create an array of Attributes (key-value pairs) for the item.");
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < [[SampleConstants attributeNames] count]; ++i) {
        SimpleDBReplaceableAttribute *keyValuePair;
        keyValuePair = [[SimpleDBReplaceableAttribute alloc] initWithName:[[SampleConstants attributeNames] objectAtIndex:i]
                                                                 andValue:[[SampleConstants attributeDefaultValues] objectAtIndex:i]
                                                               andReplace:YES];
        [attributes addObject:keyValuePair];
    }
    
    NSLog(@"Every SimpleDBItem also needs a name - this is analogous to a primary key\n");
    NSString *itemName = @"Rock0001.001";
    
    SimpleDBPutAttributesRequest *putRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:testDomain
                                                                                            andItemName:itemName
                                                                                          andAttributes:attributes];
    SimpleDBPutAttributesResponse *putResponse = [simpleDbClient putAttributes:putRequest];
    if (nil != [putResponse error]) {
        NSLog(@"%@", [putResponse error]);
        XCTFail(@"error uploading object");
    }
    
    NSLog(@"Now that we've uploaded the item, we should be able to retrieve it from the database.");
    NSLog(@"We'll wait a few seconds just to be sure that the item propagates.\n");
    sleep(2);
    SimpleDBGetAttributesRequest *getRequest = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:testDomain
                                                                                            andItemName:itemName];
    SimpleDBGetAttributesResponse *getResponse = [simpleDbClient getAttributes:getRequest];
    NSArray *responseAttributes = [getResponse attributes];
    
    NSLog(@"Got item with name %@ with %lu attributes:", itemName, (unsigned long)[responseAttributes count]);
    
    for (SimpleDBAttribute *keyValuePair in responseAttributes) {
        NSLog(@"   %@ : %@", [keyValuePair name], [keyValuePair value]);
    }
    
    NSLog(@"Cleaning up by deleting the test domain");
    SimpleDBDeleteDomainRequest *request = [[SimpleDBDeleteDomainRequest alloc] initWithDomainName:testDomain];
    [simpleDbClient deleteDomain:request];
}

@end
