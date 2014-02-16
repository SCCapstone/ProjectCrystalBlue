//
//  SimpleDBLibraryObjectStoreTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AbstractCloudLibraryObjectStore.h"
#import "SimpleDBLibraryObjectStore.h"

#define TEST_DIRECTORY @"project-crystal-blue-test-temp"
#define DATABASE_NAME @"test_database.db"

@interface SimpleDBLibraryObjectStoreTests : XCTestCase

@end

@implementation SimpleDBLibraryObjectStoreTests

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

- (void)testExample
{
    AbstractCloudLibraryObjectStore *simpleDBStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                             WithDatabaseName:DATABASE_NAME];
    
}

@end
