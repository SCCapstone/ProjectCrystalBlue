//
//  FileSystemUtilsTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FileSystemUtils.h"

@interface FileSystemUtilsTests : XCTestCase

@end

@implementation FileSystemUtilsTests

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

- (void)testRootDirectoryExists
{
    NSString *path = [FileSystemUtils localRootDirectory];
    BOOL isDirectory = NO;
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDirectory]);
    XCTAssertTrue(isDirectory);
}

- (void)testImagesDirectoryExists
{
    NSString *path = [FileSystemUtils localImagesDirectory];
    BOOL isDirectory = NO;
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDirectory]);
    XCTAssertTrue(isDirectory);
}

- (void)testDataDirectoryExists
{
    NSString *path = [FileSystemUtils localDataDirectory];
    BOOL isDirectory = NO;
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDirectory]);
    XCTAssertTrue(isDirectory);
}

- (void)testCreateAndDeleteTempDirectory
{
    NSString *path = [FileSystemUtils testDirectory];
    BOOL isDirectory = NO;
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDirectory]);
    XCTAssertTrue(isDirectory);

    XCTAssertTrue([FileSystemUtils clearTestDirectory]);
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:path
                                                        isDirectory:NULL]);
}

@end
