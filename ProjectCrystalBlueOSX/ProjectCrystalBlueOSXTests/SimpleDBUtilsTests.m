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
    
    // Make sure deletion propogates before more tests could be run
    sleep(2);
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
    Transaction *convertedTransaction = [SimpleDBUtils convertSimpleDBAttributes:item.attributes ToObjectOfClass:[Transaction class]];
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
    Source *convertedSource = [SimpleDBUtils convertSimpleDBAttributes:item.attributes ToObjectOfClass:[Source class]];
    XCTAssertNotNil(convertedSource, @"SimpleDBUtils failed to convert the simpleDBItem.");
    XCTAssertEqual(item.attributes.count, convertedSource.attributes.count, @"convertedSource does not contain the correct number of attributes.");
    
    // Ensure the converted transaction object is equal to the original transaction object
    XCTAssertEqualObjects(convertedSource, source, @"The two source objects are not equal.");
}

- (void)testPutSelectDelete
{
    // Populate database with test objects
    NSArray *testObjects = [self getTestObjectsWithCapacity:5];
    BOOL putSuccess = [SimpleDBUtils executeBatchPut:testObjects
                                      WithDomainName:TEST_DOMAIN_NAME
                                         UsingClient:simpleDBClient];
    XCTAssertTrue(putSuccess, @"SimpleDBUtils failed to put the test objects to the remote database.");
    
    // Wait for put to complete
    sleep(1);
    
    // Make sure objects have been put
    NSString *query = [NSString stringWithFormat:@"select * from %@ where timestamp >= '200' order by timestamp limit 250", TEST_DOMAIN_NAME];
    NSArray *transactions = [SimpleDBUtils executeSelectQuery:query
                                      WithReturnedObjectClass:[Transaction class]
                                                  UsingClient:simpleDBClient];
    XCTAssertNotNil(transactions, @"The query to SimpleDB was unsuccessful.");
    XCTAssertTrue(transactions.count == 4ul, @"SimpleDB returned the incorrect number of transactions.");
    
    // Delete test objects
    NSMutableArray *objectNames = [[NSMutableArray alloc] initWithCapacity:testObjects.count];
    for (Transaction *transaction in testObjects) {
        [objectNames addObject:[transaction.timestamp stringValue]];
    }
    BOOL deleteSuccess = [SimpleDBUtils executeBatchDelete:objectNames
                                            WithDomainName:TEST_DOMAIN_NAME
                                               UsingClient:simpleDBClient];
    XCTAssertTrue(deleteSuccess, @"SimpleDBUtils failed to delete the objects from the remote database.");
    
    // Wait for delete to complete
    sleep(1);
    
    // Make sure objects have been deleted
    query = [NSString stringWithFormat:@"select * from %@", TEST_DOMAIN_NAME];
    transactions = [SimpleDBUtils executeSelectQuery:query
                                      WithReturnedObjectClass:[Transaction class]
                                                  UsingClient:simpleDBClient];
    XCTAssertNotNil(transactions, @"The query to SimpleDB was unsuccessful.");
    XCTAssertTrue(transactions.count == 0ul, @"SimpleDB returned the incorrect number of transactions.");
}

- (void)testPutGet
{
    // Populate database with test objects
    NSArray *testObjects = [self getTestObjectsWithCapacity:5];
    BOOL putSuccess = [SimpleDBUtils executeBatchPut:testObjects
                                      WithDomainName:TEST_DOMAIN_NAME
                                         UsingClient:simpleDBClient];
    XCTAssertTrue(putSuccess, @"SimpleDBUtils failed to put the test objects to the remote database.");
    
    // Wait for put to complete
    sleep(1);
    
    for (Transaction *transaction in testObjects) {
        Transaction *remoteTransaction = (Transaction *)[SimpleDBUtils executeGetWithItemName:[transaction.timestamp stringValue]
                                                                            AndWithDomainName:TEST_DOMAIN_NAME
                                                                                  UsingClient:simpleDBClient
                                                                              ToObjectOfClass:[Transaction class]];
        XCTAssertNotNil(remoteTransaction, @"SimpleDBUtils failed to get the remote transaction.");
        XCTAssertEqualObjects(transaction, remoteTransaction, @"Retrieved object is not equal to the committed object.");
    }
}

- (void)testLargeBatchPutDelete
{
    // Populate database with test objects
    NSArray *testObjects = [self getTestObjectsWithCapacity:250];
    BOOL putSuccess = [SimpleDBUtils executeBatchPut:testObjects
                                      WithDomainName:TEST_DOMAIN_NAME
                                         UsingClient:simpleDBClient];
    XCTAssertTrue(putSuccess, @"SimpleDBUtils failed to put the test objects to the remote database.");
    
    // Wait for put to complete
    sleep(1);
    
    // Make sure objects have been put
    NSString *query = [NSString stringWithFormat:@"select * from %@ limit 250", TEST_DOMAIN_NAME];
    NSArray *transactions = [SimpleDBUtils executeSelectQuery:query
                                      WithReturnedObjectClass:[Transaction class]
                                                  UsingClient:simpleDBClient];
    XCTAssertNotNil(transactions, @"The query to SimpleDB was unsuccessful.");
    XCTAssertTrue(transactions.count == 250ul, @"SimpleDB returned the incorrect number of transactions.");
    
    // Delete test objects
    NSMutableArray *objectNames = [[NSMutableArray alloc] initWithCapacity:testObjects.count];
    for (Transaction *transaction in testObjects) {
        [objectNames addObject:[transaction.timestamp stringValue]];
    }
    BOOL deleteSuccess = [SimpleDBUtils executeBatchDelete:objectNames
                                            WithDomainName:TEST_DOMAIN_NAME
                                               UsingClient:simpleDBClient];
    XCTAssertTrue(deleteSuccess, @"SimpleDBUtils failed to delete the objects from the remote database.");
    
    // Wait for delete to complete
    sleep(1);
    
    // Make sure objects have been deleted
    query = [NSString stringWithFormat:@"select * from %@", TEST_DOMAIN_NAME];
    transactions = [SimpleDBUtils executeSelectQuery:query
                             WithReturnedObjectClass:[Transaction class]
                                         UsingClient:simpleDBClient];
    XCTAssertNotNil(transactions, @"The query to SimpleDB was unsuccessful.");
    XCTAssertTrue(transactions.count == 0ul, @"SimpleDB returned the incorrect number of transactions.");
}

- (NSArray *)getTestObjectsWithCapacity:(NSUInteger)capacity
{
    NSMutableArray *testTransactions = [[NSMutableArray alloc] init];
    
    for (int i=1; i<capacity+1; i++) {
        NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                                 forKeys:[TransactionConstants attributeNames]];
        
        [testTransactions addObject:[[Transaction alloc] initWithTimestamp:[NSNumber numberWithInt:i*1000]
                                                AndWithAttributeDictionary:attributes]];
    }
    
    return testTransactions;
}

@end
