//
//  SimpleDBUtilsTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SimpleDBUtils.h"
#import "HardcodedCredentialsProvider.h"
#import "Transaction.h"
#import "Source.h"

#define TEST_DOMAIN_NAME @"testDomain"

@interface SimpleDBUtilsTests : XCTestCase
{
    AmazonSimpleDBClient *simpleDBClient;
}

@end

@implementation SimpleDBUtilsTests

- (void)setUp
{
    [super setUp];
    
    NSObject<AmazonCredentialsProvider> *credentialsProvider = [[HardcodedCredentialsProvider alloc] init];
    simpleDBClient = [[AmazonSimpleDBClient alloc] initWithCredentialsProvider:credentialsProvider];

    @try {
        SimpleDBListDomainsResponse *listResponse = [simpleDBClient listDomains:[[SimpleDBListDomainsRequest alloc] init]];
        
        // Create test domain
        if (![listResponse.domainNames containsObject:TEST_DOMAIN_NAME]) {
            SimpleDBCreateDomainRequest *createRequest = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:TEST_DOMAIN_NAME];
            [simpleDBClient createDomain:createRequest];
        }
    }
    @catch (NSException *exception) {
        XCTFail(@"Failed to create the test domain. Error: %@", exception);
    }
}

- (void)tearDown
{
    @try {
        // Delete test domain
        SimpleDBDeleteDomainRequest *request = [[SimpleDBDeleteDomainRequest alloc] initWithDomainName:TEST_DOMAIN_NAME];
        [simpleDBClient deleteDomain:request];
    }
    @catch (NSException *exception) {
        XCTFail(@"Failed to clear the test domain. Error: %@", exception);
    }
    
    [super tearDown];
}

- (void)testSimpleDBItemConversions
{
    // Convert transaction object to SimpleDBReplaceableItem
    Transaction *transaction = [[Transaction alloc] initWithLibraryObjectKey:@"rock1030"
                                                            AndWithTableName:@"tableName"
                                                       AndWithSqlCommandType:@"PUT"];
    SimpleDBReplaceableItem *replaceableItem = [SimpleDBUtils convertObjectToSimpleDBItem:transaction];
    XCTAssertNotNil(replaceableItem, @"SimpleDBUtils failed to convert the transaction object.");
    XCTAssertEqual(transaction.attributes.count, replaceableItem.attributes.count, @"SimpleDBItem does not contain the correct number of attributes.");
    
    // Convert SimpleDBReplaceableItem to transaction object
    SimpleDBItem *item = [[SimpleDBItem alloc] initWithName:replaceableItem.name
                                              andAttributes:replaceableItem.attributes];
    Transaction *convertedTransaction = [SimpleDBUtils convertSimpleDBItem:item ToObjectOfClass:[Transaction class]];
    XCTAssertNotNil(convertedTransaction, @"SimpleDBUtils failed to convert the simpleDBItem.");
    XCTAssertEqual(item.attributes.count, convertedTransaction.attributes.count, @"convertedTransaction does not contain the correct number of attributes.");
    
    // Ensure the converted transaction object is equal to the original transaction object
    XCTAssertEqualObjects(convertedTransaction, transaction, @"The two transaction objects are not equal.");
    
    // Convert source object to SimpleDBReplaceableItem
    Source *source = [[Source alloc] initWithKey:@"rock1030"
                                   AndWithValues:[SourceConstants attributeDefaultValues]];
    replaceableItem = [SimpleDBUtils convertObjectToSimpleDBItem:source];
    XCTAssertNotNil(replaceableItem, @"SimpleDBUtils failed to convert the source object.");
    XCTAssertEqual(source.attributes.count, replaceableItem.attributes.count, @"SimpleDBItem does not contain the correct number of attributes.");
    
    // Convert SimpleDBReplaceableItem to transaction object
    item = [[SimpleDBItem alloc] initWithName:replaceableItem.name
                                andAttributes:replaceableItem.attributes];
    Source *convertedSource = [SimpleDBUtils convertSimpleDBItem:item ToObjectOfClass:[Source class]];
    XCTAssertNotNil(convertedSource, @"SimpleDBUtils failed to convert the simpleDBItem.");
    XCTAssertEqual(item.attributes.count, convertedSource.attributes.count, @"convertedSource does not contain the correct number of attributes.");
    
    // Ensure the converted transaction object is equal to the original transaction object
    XCTAssertEqualObjects(convertedSource, source, @"The two source objects are not equal.");
}

- (void)testSelectQuery
{
    [self populateWithTestObjects];
    NSString *query = [NSString stringWithFormat:@"select * from %@ where timestamp >= '100' order by timestamp limit 250", TEST_DOMAIN_NAME];
    NSArray *transactions = [SimpleDBUtils executeSelectQuery:query
                                      WithReturnedObjectClass:[Transaction class]
                                                  UsingClient:simpleDBClient];
    XCTAssertNotNil(transactions, @"The query to SimpleDB was unsuccessful.");
    XCTAssertTrue(transactions.count == 4ul, @"SimpleDB returned the incorrect number of transactions.");
}

- (void)populateWithTestObjects
{
    NSMutableArray *testTransactions = [[NSMutableArray alloc] init];
    
    for (int i=0; i<5; i++) {
        NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                                 forKeys:[TransactionConstants attributeNames]];
        
        Transaction *transaction = [[Transaction alloc] initWithTimestamp:[NSNumber numberWithInt:i*1000]
                                               AndWithAttributeDictionary:attributes];
        [testTransactions addObject:[SimpleDBUtils convertObjectToSimpleDBItem:transaction]];
    }
    
    @try {
        SimpleDBBatchPutAttributesRequest *putRequest = [[SimpleDBBatchPutAttributesRequest alloc] initWithDomainName:TEST_DOMAIN_NAME
                                                                                                             andItems:testTransactions];
        [simpleDBClient batchPutAttributes:putRequest];
    }
    @catch (NSException *exception) {
        XCTFail(@"Failed to populate the test domain with test objects. Error: %@", exception);
    }
}

@end
