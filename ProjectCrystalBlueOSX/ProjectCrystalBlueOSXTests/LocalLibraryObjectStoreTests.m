//
//  LocalLibraryObjectStoreTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/7/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AbstractLibraryObjectStore.h"
#import "LocalLibraryObjectStore.h"
#import "LibraryObject.h"
#import "Source.h"
#import "Sample.h"

#define TEST_DIRECTORY @"project-crystal-blue-test-temp"
#define DATABASE_NAME @"test_database.db"

@interface LocalLibraryObjectStoreTests : XCTestCase

@end

@implementation LocalLibraryObjectStoreTests

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

- (void)testLibraryObjectPutGetAndDelete
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    
    BOOL putSuccess = [libraryObjectStore putLibraryObject:nil forKey:@"nobody-use-this-test-key" IntoTable:TABLE_NAME];
    XCTAssertTrue(putSuccess, @"LocalLibraryStore did not successfully save the library object.");
    
    LibraryObject *libraryObject = [libraryObjectStore getLibraryObjectForKey:@"nobody-use-this-test-key" FromTable:TABLE_NAME];
}

@end
