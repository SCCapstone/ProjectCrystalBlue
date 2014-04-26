//
//  LibraryObjectEqualsAndHashcodeTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LibraryObject.h"
#import "SplitConstants.h"
#import "SampleConstants.h"

@interface LibraryObjectEqualsAndHashcodeTests : XCTestCase

@end

@implementation LibraryObjectEqualsAndHashcodeTests

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
    NSString *key = [[[NSUUID alloc] init] UUIDString];
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[SplitConstants attributeDefaultValues]
                                                             forKeys:[SplitConstants attributeNames]];
    
    LibraryObject *a = [[LibraryObject alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    LibraryObject *b = [[LibraryObject alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    
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
    NSString *key = [[[NSUUID alloc] init] UUIDString];
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[SplitConstants attributeDefaultValues]
                                                             forKeys:[SplitConstants attributeNames]];
    
    LibraryObject *a = [[LibraryObject alloc] initWithKey:key AndWithAttributeDictionary:attributes];
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
    NSString *aKey = [[[NSUUID alloc] init] UUIDString];
    NSString *bKey = [[[NSUUID alloc] init] UUIDString];
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[SplitConstants attributeDefaultValues]
                                                             forKeys:[SplitConstants attributeNames]];
    
    LibraryObject *a = [[LibraryObject alloc] initWithKey:aKey AndWithAttributeDictionary:attributes];
    LibraryObject *b = [[LibraryObject alloc] initWithKey:bKey AndWithAttributeDictionary:attributes];
    
    XCTAssertNotEqualObjects(a, b, @"a and b shouldn't be equal if they have different keys");
}

/**
 *  Objects with different attribute key sets (e.g. a Sample and a Split) are not equal.
 */
- (void)testDifferentAttributeKeysNotEqual
{
    NSString *key = [[[NSUUID alloc] init] UUIDString];
    NSDictionary *aAttributes = [[NSDictionary alloc] initWithObjects:[SplitConstants attributeDefaultValues]
                                                              forKeys:[SplitConstants attributeNames]];
    
    NSDictionary *bAttributes = [[NSDictionary alloc] initWithObjects:[SampleConstants attributeDefaultValues]
                                                              forKeys:[SampleConstants attributeNames]];
    
    LibraryObject *a = [[LibraryObject alloc] initWithKey:key AndWithAttributeDictionary:aAttributes];
    LibraryObject *b = [[LibraryObject alloc] initWithKey:key AndWithAttributeDictionary:bAttributes];
    
    XCTAssertNotEqualObjects(a, b, @"a and b shouldn't be equal if their attributes have different key sets");
}

/**
 *  Objects with different attribute values are not equal
 */
- (void)testDifferentAttributeValuesNotEqual
{
    NSString *key = [[[NSUUID alloc] init] UUIDString];
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:[SplitConstants attributeDefaultValues]
                                                             forKeys:[SplitConstants attributeNames]];
    
    LibraryObject *a = [[LibraryObject alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    
    for (NSString *attributeKey in a.attributes.allKeys) {
        // One by one, we'll create an "other" object and just change a single attribute.
        LibraryObject *other = [[LibraryObject alloc] initWithKey:key AndWithAttributeDictionary:attributes];
        XCTAssertEqualObjects(a, other);
        XCTAssertEqual([a hash], [other hash], @"a and other didn't give equal hashcodes!");
        [other.attributes setObject:@"DIFFERENT_VALUE_THAN_ORIGINAL" forKey:attributeKey];
        XCTAssertNotEqualObjects(a, other, @"%@ has a different value in other than it does in a, so they should not be equal", attributeKey);
    }
}

@end
