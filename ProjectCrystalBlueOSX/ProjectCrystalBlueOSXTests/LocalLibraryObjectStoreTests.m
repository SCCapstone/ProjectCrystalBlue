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
}

- (void)tearDown
{
    [super tearDown];
    
    // Delete the test_database.db file after each test
    NSError *error = nil;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *databasePath = [[documentsDirectory stringByAppendingPathComponent:TEST_DIRECTORY]
                              stringByAppendingPathComponent:DATABASE_NAME];
    [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&error];
    XCTAssertNil(error, @"Error removing database file!");
}

// Verify nil is returned when passing a nonexistent key
- (void)testGetNonexistentLibraryObject
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    NSString *nonexistentKey = @"this-key-doesnt-exist";
    
    LibraryObject *libraryObject = [libraryObjectStore getLibraryObjectForKey:nonexistentKey FromTable:[SourceConstants tableName]];
    XCTAssertNil(libraryObject, @"Object returned should have been nil.");
}

// Verify update fails if object is not in database yet
- (void)testUpdateNonexistentLibraryObject
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Initialize object that does not exist in the database
    NSString *nonexistentKey = @"this-key-doesnt-exist";
    LibraryObject *nonexistentObject = [[Source alloc] initWithKey:nonexistentKey
                                                     AndWithValues:[SourceConstants attributeDefaultValues]];
    
    BOOL isUpdated = [libraryObjectStore updateLibraryObject:nonexistentObject IntoTable:[SourceConstants tableName]];
    XCTAssertFalse(isUpdated, @"There should be no object to update.");
}

// Verify delete fails if there is no key in database
- (void)testDeleteNonexistentLibraryObject
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    NSString *nonexistentKey = @"this-key-doesnt-exist";
    
    BOOL isDeleted = [libraryObjectStore deleteLibraryObjectWithKey:nonexistentKey FromTable:[SourceConstants tableName]];
    XCTAssertFalse(isDeleted, @"There should be no object to delete.");
}

// Verify that we can successfully Put, Get, Update, and Delete both Source and Sample objects
- (void)testPutGetUpdateAndDeleteLibraryObject
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store and make sure they don't already exist
    NSString *sourceKey = @"rock1030";
    Source *sourceObject = [[Source alloc] initWithKey:sourceKey AndWithValues:[SourceConstants attributeDefaultValues]];
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]],
                   @"LocalLibraryObjectStore believes an object with this key already exists.");
    
    NSString *sampleKey = @"rock1030.001";
    Sample *sampleObject = [[Sample alloc] initWithKey:sampleKey AndWithValues:[SampleConstants attributeDefaultValues]];
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sampleKey FromTable:[SampleConstants tableName]],
                   @"LocalLibraryObjectStore believes an object with this key already exists.");
    
    // Put the library objects into the local database
    BOOL putSuccess = [libraryObjectStore putLibraryObject:sourceObject IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(putSuccess, @"LocalLibraryObjectStore failed to put the library object into the database.");
    
    putSuccess = [libraryObjectStore putLibraryObject:sampleObject IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(putSuccess, @"LocalLibraryObjectStore failed to put the library object into the database.");
    
    // Check the added library objects exist in the local database now
    XCTAssertTrue([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]],
                  @"LocalLibraryObjectStore did not find the object.");
    XCTAssertTrue([libraryObjectStore libraryObjectExistsForKey:sampleKey FromTable:[SampleConstants tableName]],
                  @"LocalLibraryObjectStore did not find the object.");
    
    // Try to get the added objects
    LibraryObject *storedSource = [libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(storedSource, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects([storedSource key], [sourceObject key], @"The same object was not returned.");
    
    LibraryObject *storedSample = [libraryObjectStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];
    XCTAssertNotNil(storedSample, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects([storedSample key], [sampleObject key], @"The same object was not returned.");
    
    // Update the objects
    [[sourceObject attributes] setObject:@"really old..." forKey:@"age"];
    BOOL updateSuccess = [libraryObjectStore updateLibraryObject:sourceObject IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(updateSuccess, @"LocalLibraryObjectStore failed to update the specified object.");
    
    [[sampleObject attributes] setObject:@"did so much stuff" forKey:@"tags"];
    updateSuccess = [libraryObjectStore updateLibraryObject:sampleObject IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(updateSuccess, @"LocalLibraryObjectStore failed to update the specified object.");
    
    // Check the objects have been updated in the database
    LibraryObject *updatedSource = [libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(updatedSource, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects([[sourceObject attributes] objectForKey:@"age"], [[updatedSource attributes] objectForKey:@"age"],
                          @"LocalLibraryObjectStore did not update the object properly.");
    
    LibraryObject *updatedSample = [libraryObjectStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];
    XCTAssertEqualObjects([[sampleObject attributes] objectForKey:@"tags"], [[updatedSample attributes] objectForKey:@"tags"],
                          @"LocalLibraryObjectStore did not update the object properly.");
    
    // Delete the added objects
    BOOL deleteSuccess = [libraryObjectStore deleteLibraryObjectWithKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertTrue(deleteSuccess, @"LocalLibraryObjectStore failed to delete the specified object.");
    
    deleteSuccess = [libraryObjectStore deleteLibraryObjectWithKey:sampleKey FromTable:[SampleConstants tableName]];
    XCTAssertTrue(deleteSuccess, @"LocalLibraryObjectStore failed to delete the specified object.");
    
    // Veryify the objects have been deleted
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]],
                   @"LocalLibraryObjectStore still contains the object.");
    XCTAssertNil([libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]],
                 @"LocalLibraryObjectStore should have returned nil.");
    
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sampleKey FromTable:[SampleConstants tableName]],
                   @"LocalLibraryObjectStore still contains find the object.");
    XCTAssertNil([libraryObjectStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]],
                 @"LocalLibraryObjectStore should have returned nil.");
}

@end
