//
//  TransactionEqualsAndHashcodeTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Transaction.h"

@interface TransactionEqualsAndHashcodeTests : XCTestCase

@end

@implementation TransactionEqualsAndHashcodeTests

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

/// A LibraryObject should be equal to itself
- (void)testEqualsReflexive
{
    NSNumber *timestamp = [NSNumber numberWithInt:500];
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                             forKeys:[TransactionConstants attributeNames]];
    
    Transaction *a = [[Transaction alloc] initWithTimestamp:timestamp AndWithAttributeDictionary:attributes];
    Transaction *b = [[Transaction alloc] initWithTimestamp:timestamp AndWithAttributeDictionary:attributes];
    
    XCTAssertEqualObjects(a, a, @"a isn't equal to itself!");
    XCTAssertEqual([a hash], [a hash], @"a and a didn't give equal hashcodes!");
    XCTAssertNotEqual(a, b);
    XCTAssertEqualObjects(a, b, @"a and b are initialized with the same key and attributes, but are not equal");
    XCTAssertEqual([a hash], [b hash], @"a and b didn't give equal hashcodes!");
}

/**
 *  The hashcode should only be dependent on fields that will not be changed - i.e. the key.
 */
- (void)testChangeMutableFieldsMaintainsSameHashcode
{
    NSNumber *timestamp = [NSNumber numberWithInt:500];
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                             forKeys:[TransactionConstants attributeNames]];
    
    Transaction *a = [[Transaction alloc] initWithTimestamp:timestamp AndWithAttributeDictionary:attributes];
    NSUInteger hashBefore = [a hash];
    
    for (NSString *attributeKey in a.attributes.allKeys) {
        NSString *attribute = [a.attributes objectForKey:attributeKey];
        attribute = [attribute stringByAppendingString:[[[NSUUID alloc] init] UUIDString]];
        [a.attributes setObject:attribute forKey:attributeKey];
    }
    
    
    NSUInteger hashAfter = [a hash];
    XCTAssertEqual(hashBefore, hashAfter, @"Hash was modified after changing mutable fields!");
}

/**
 *  Objects with different keys are never equal.
 */
- (void)testDifferentKeysNotEqual
{
    NSNumber *aTimestamp = [NSNumber numberWithInt:100];
    NSNumber *bTimestamp = [NSNumber numberWithInt:500];
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                             forKeys:[TransactionConstants attributeNames]];
    
    Transaction *a = [[Transaction alloc] initWithTimestamp:aTimestamp AndWithAttributeDictionary:attributes];
    Transaction *b = [[Transaction alloc] initWithTimestamp:bTimestamp AndWithAttributeDictionary:attributes];
    
    XCTAssertNotEqualObjects(a, b, @"a and b shouldn't be equal if they have different keys");
}

/**
 *  Objects with different attribute key sets (e.g. a Sample and a Split) are not equal.
 */
- (void)testDifferentAttributeKeysNotEqual
{
    NSNumber *timestamp = [NSNumber numberWithInt:100];
    NSDictionary *aAttributes = [[NSDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                             forKeys:[TransactionConstants attributeNames]];
    NSMutableDictionary *bAttributes = [[NSMutableDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                                            forKeys:[TransactionConstants attributeNames]];
    [bAttributes setValue:@"unique value" forKey:TRN_SQL_COMMAND_TYPE];
    
    Transaction *a = [[Transaction alloc] initWithTimestamp:timestamp AndWithAttributeDictionary:aAttributes];
    Transaction *b = [[Transaction alloc] initWithTimestamp:timestamp AndWithAttributeDictionary:bAttributes];
    
    XCTAssertNotEqualObjects(a, b, @"a and b shouldn't be equal if their attributes have different key sets");
}

/**
 *  Objects with different attribute values are not equal
 */
- (void)testDifferentAttributeValuesNotEqual
{
    NSNumber *timestamp = [NSNumber numberWithInt:100];
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[TransactionConstants attributeDefaultValues]
                                                              forKeys:[TransactionConstants attributeNames]];
    
    Transaction *a = [[Transaction alloc] initWithTimestamp:timestamp AndWithAttributeDictionary:attributes];
    
    for (NSString *attributeKey in a.attributes.allKeys) {
        // One by one, we'll create an "other" object and just change a single attribute.
        Transaction *other = [[Transaction alloc] initWithTimestamp:timestamp AndWithAttributeDictionary:attributes];
        XCTAssertEqualObjects(a, other);
        XCTAssertEqual([a hash], [other hash], @"a and other didn't give equal hashcodes!");
        [other.attributes setObject:@"DIFFERENT_VALUE_THAN_ORIGINAL" forKey:attributeKey];
        XCTAssertNotEqualObjects(a, other, @"%@ has a different value in other than it does in a, so they should not be equal", attributeKey);
    }
}

@end
