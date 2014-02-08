//
//  AbstractImageStoreTests.m
//  ProjectCrystalBlueOSX
//
//  Some tests to make sure that abstract ImageStore classes cannot be directly used.
//
//  Created by Logan Hood on 1/31/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AbstractImageStore.h"
#import "AbstractCloudImageStore.h"

@interface AbstractImageStoreTests : XCTestCase

@end

@implementation AbstractImageStoreTests

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

/// The no-arg init methods should not be allowed.
- (void)testNoArgInit
{
    XCTAssertThrows([[AbstractImageStore alloc] init],
                    @"You should not be allowed to use no-arg init for AbstractImageStore!");
    
    XCTAssertThrows([[AbstractCloudImageStore alloc] init],
                    @"You should not be allowed to use no-arg init for AbstractCloudImageStore!");
}

/// One should not be able to call any methods of the abstract classes.
- (void)testCallMethodsOfAbstractImageStore
{
    AbstractImageStore *store = [[AbstractImageStore alloc] initWithLocalDirectory:@""];
    
    XCTAssertThrows([store getImageForKey:@""], @"getImageForKey should have thrown an exception.");
    XCTAssertThrows([store deleteImageWithKey:@""], @"deleteImageForKey should have thrown an exception.");
    XCTAssertThrows([store imageExistsForKey:@""], @"imageExistsForKey should have thrown an exception.");
    XCTAssertThrows([store putImage:nil forKey:@""], @"putImageForKey should have thrown an exception.");
    XCTAssertThrows([store flushLocalImageData], @"flushLocalImageData should have thrown an exception.");
}

/// One should not be able to call any methods of the abstract classes.
- (void)testCallMethodsOfAbstractCloudImageStore
{
    AbstractCloudImageStore *store = [[AbstractCloudImageStore alloc] initWithLocalDirectory:@""];
    
    XCTAssertThrows([store getImageForKey:@""], @"getImageForKey should have thrown an exception.");
    XCTAssertThrows([store deleteImageWithKey:@""], @"deleteImageForKey should have thrown an exception.");
    XCTAssertThrows([store imageExistsForKey:@""], @"imageExistsForKey should have thrown an exception.");
    XCTAssertThrows([store putImage:nil forKey:@""], @"putImageForKey should have thrown an exception.");
    XCTAssertThrows([store flushLocalImageData], @"flushLocalImageData should have thrown an exception.");
    
    XCTAssertThrows([store synchronizeWithCloud], @"synchronizeWithCloud should have thrown an exception.");
    XCTAssertThrows([store keyIsDirty:@""], @"keyIsDirty should have thrown an exception.");
}

@end
