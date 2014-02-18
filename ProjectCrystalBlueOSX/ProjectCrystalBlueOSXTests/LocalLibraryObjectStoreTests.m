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

// Veryify failure on nonexistent table
- (void)testNonexistentTable
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    NSString *nonexistentKey = @"this-key-doesnt-exist";
    
    LibraryObject *libraryObject = [libraryObjectStore getLibraryObjectForKey:nonexistentKey FromTable:@"This table doesn't exist!"];
    XCTAssertNil(libraryObject, @"Object returned should have been nil.");
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
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]], @"LocalLibraryObjectStore believes an object with this key already exists.");
    
    NSString *sampleKey = @"rock1030.001";
    Sample *sampleObject = [[Sample alloc] initWithKey:sampleKey AndWithValues:[SampleConstants attributeDefaultValues]];
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sampleKey FromTable:[SampleConstants tableName]], @"LocalLibraryObjectStore believes an object with this key already exists.");
    
    // Put the library objects into the local database
    BOOL putSuccess = [libraryObjectStore putLibraryObject:sourceObject IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(putSuccess, @"LocalLibraryObjectStore failed to put the library object into the database.");
    
    putSuccess = [libraryObjectStore putLibraryObject:sampleObject IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(putSuccess, @"LocalLibraryObjectStore failed to put the library object into the database.");
    
    // Check the added library objects exist in the local database now
    XCTAssertTrue([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]], @"LocalLibraryObjectStore did not find the object.");
    XCTAssertTrue([libraryObjectStore libraryObjectExistsForKey:sampleKey FromTable:[SampleConstants tableName]], @"LocalLibraryObjectStore did not find the object.");
    
    // Try to get the added objects
    LibraryObject *storedSource = [libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(storedSource, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects([storedSource key], [sourceObject key], @"The same object was not returned.");
    
    LibraryObject *storedSample = [libraryObjectStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];
    XCTAssertNotNil(storedSample, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects([storedSample key], [sampleObject key], @"The same object was not returned.");
    
    // Update the objects
    [[sourceObject attributes] setObject:@"really old..." forKey:SRC_AGE];
    BOOL updateSuccess = [libraryObjectStore updateLibraryObject:sourceObject IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(updateSuccess, @"LocalLibraryObjectStore failed to update the specified object.");
    
    [[sampleObject attributes] setObject:@"did so much stuff" forKey:SMP_TAGS];
    updateSuccess = [libraryObjectStore updateLibraryObject:sampleObject IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(updateSuccess, @"LocalLibraryObjectStore failed to update the specified object.");
    
    // Check the objects have been updated in the database
    LibraryObject *updatedSource = [libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(updatedSource, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects([[sourceObject attributes] objectForKey:SRC_AGE], [[updatedSource attributes] objectForKey:SRC_AGE], @"LocalLibraryObjectStore did not update the object properly.");
    
    LibraryObject *updatedSample = [libraryObjectStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];
    XCTAssertEqualObjects([[sampleObject attributes] objectForKey:SMP_TAGS], [[updatedSample attributes] objectForKey:SMP_TAGS], @"LocalLibraryObjectStore did not update the object properly.");
    
    // Delete the added objects
    BOOL deleteSuccess = [libraryObjectStore deleteLibraryObjectWithKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertTrue(deleteSuccess, @"LocalLibraryObjectStore failed to delete the specified object.");
    
    deleteSuccess = [libraryObjectStore deleteLibraryObjectWithKey:sampleKey FromTable:[SampleConstants tableName]];
    XCTAssertTrue(deleteSuccess, @"LocalLibraryObjectStore failed to delete the specified object.");
    
    // Veryify the objects have been deleted
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]], @"LocalLibraryObjectStore still contains the object.");
    XCTAssertNil([libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]], @"LocalLibraryObjectStore should have returned nil.");
    
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sampleKey FromTable:[SampleConstants tableName]], @"LocalLibraryObjectStore still contains find the object.");
    XCTAssertNil([libraryObjectStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]], @"LocalLibraryObjectStore should have returned nil.");
}

/// Verify all library objects from table are returned
- (void)testGetAllLibraryObjects
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store and make sure they don't already exist
    NSString *sourceKey1 = @"rock1030";
    Source *sourceObject1 = [[Source alloc] initWithKey:sourceKey1 AndWithValues:[SourceConstants attributeDefaultValues]];
    BOOL putSuccess = [libraryObjectStore putLibraryObject:sourceObject1 IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    NSString *sourceKey2 = @"rock1031";
    Source *sourceObject2 = [[Source alloc] initWithKey:sourceKey2 AndWithValues:[SourceConstants attributeDefaultValues]];
    putSuccess = [libraryObjectStore putLibraryObject:sourceObject2 IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    // Get all of the objects
    NSArray *allObjects = [libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]];
    XCTAssertNotNil(allObjects, @"LibraryObjectStore failed to get all library objects.");
    XCTAssertEqual([allObjects count], 2ul, @"All of the objects were not returned from LibraryObjectStore.");
}

/// Verify the correct number of library objects from table is returned
- (void)testCountLibraryObjects
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    NSString *sourceKey1 = @"rock1030";
    Source *sourceObject1 = [[Source alloc] initWithKey:sourceKey1 AndWithValues:[SourceConstants attributeDefaultValues]];
    BOOL putSuccess = [libraryObjectStore putLibraryObject:sourceObject1 IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    NSString *sourceKey2 = @"rock1031";
    Source *sourceObject2 = [[Source alloc] initWithKey:sourceKey2 AndWithValues:[SourceConstants attributeDefaultValues]];
    putSuccess = [libraryObjectStore putLibraryObject:sourceObject2 IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    // Get the count
    NSInteger objectCount = [libraryObjectStore countInTable:[SourceConstants tableName]];
    XCTAssertTrue(objectCount == 2, @"All of the objects were not returned from LibraryObjectStore.");
}

/// Verify can get all samples that originated from a source
- (void)testGetSamplesFromSource
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    NSString *sourceKey = @"rock1030";
    Source *sourceObject = [[Source alloc] initWithKey:sourceKey AndWithValues:[SourceConstants attributeDefaultValues]];
    BOOL putSuccess = [libraryObjectStore putLibraryObject:sourceObject IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    NSString *sampleKey1 = @"rock1030.001";
    Sample *sampleObject1 = [[Sample alloc] initWithKey:sampleKey1 AndWithValues:[SampleConstants attributeDefaultValues]];
    [sampleObject1.attributes setObject:sourceKey forKey:SMP_SOURCE_KEY];
    putSuccess = [libraryObjectStore putLibraryObject:sampleObject1 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    NSString *sampleKey2 = @"rock1030.002";
    Sample *sampleObject2 = [[Sample alloc] initWithKey:sampleKey2 AndWithValues:[SampleConstants attributeDefaultValues]];
    [sampleObject2.attributes setObject:sourceKey forKey:SMP_SOURCE_KEY];
    putSuccess = [libraryObjectStore putLibraryObject:sampleObject2 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    NSString *sampleKey3 = @"rock9999.001";
    Sample *sampleObject3 = [[Sample alloc] initWithKey:sampleKey3 AndWithValues:[SampleConstants attributeDefaultValues]];
    [sampleObject3.attributes setObject:@"rock9999" forKey:SMP_SOURCE_KEY];
    putSuccess = [libraryObjectStore putLibraryObject:sampleObject3 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    // Make sure all corresponding samples are returned
    NSArray *samples = [libraryObjectStore getAllSamplesForSource:sourceObject];
    XCTAssertNotNil(samples, @"LibraryObjectStore failed to get the samples.");
    XCTAssertEqual([samples count], 2ul, @"LibraryObjectStore should have returned 2 samples.");
}

/// Verify that executing a custom sql query returns the correct library objects
- (void)testExecuteSqlQuery
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    NSString *sampleKey1 = @"rock1030.001";
    Sample *sampleObject1 = [[Sample alloc] initWithKey:sampleKey1 AndWithValues:[SampleConstants attributeDefaultValues]];
    [sampleObject1.attributes setObject:@"rock1030" forKey:SMP_SOURCE_KEY];
    [sampleObject1.attributes setObject:@"over there" forKey:SMP_CURRENT_LOCATION];
    BOOL putSuccess = [libraryObjectStore putLibraryObject:sampleObject1 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    NSString *sampleKey2 = @"rock1030.002";
    Sample *sampleObject2 = [[Sample alloc] initWithKey:sampleKey2 AndWithValues:[SampleConstants attributeDefaultValues]];
    [sampleObject2.attributes setObject:@"rock1030" forKey:SMP_SOURCE_KEY];
    [sampleObject2.attributes setObject:@"over here" forKey:SMP_CURRENT_LOCATION];
    putSuccess = [libraryObjectStore putLibraryObject:sampleObject2 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    NSString *sampleKey3 = @"rock9999.001";
    Sample *sampleObject3 = [[Sample alloc] initWithKey:sampleKey3 AndWithValues:[SampleConstants attributeDefaultValues]];
    [sampleObject3.attributes setObject:@"rock9999" forKey:SMP_SOURCE_KEY];
    [sampleObject3.attributes setObject:@"over there" forKey:SMP_CURRENT_LOCATION];
    putSuccess = [libraryObjectStore putLibraryObject:sampleObject3 IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(putSuccess, @"LibraryObjectStore failed to put the library object into the database.");
    
    // Execute some commands and make sure they return the correct objects
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE sourceKey='rock1030'", [SampleConstants tableName]];
    NSArray *libraryObjects = [libraryObjectStore executeSqlQuery:sql OnTable:[SampleConstants tableName]];
    XCTAssertNotNil(libraryObjects, @"LibraryObjectStore failed to execute the query.");
    XCTAssertEqual([libraryObjects count], 2ul, @"LibraryObjectStore should have returned 2 samples.");
    
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE currentLocation='over here'", [SampleConstants tableName]];
    libraryObjects = [libraryObjectStore executeSqlQuery:sql OnTable:[SampleConstants tableName]];
    XCTAssertNotNil(libraryObjects, @"LibraryObjectStore failed to execute the query.");
    XCTAssertEqual([libraryObjects count], 1ul, @"LibraryObjectStore should have returned 2 samples.");
    
    // Make sure invalid command type returns nil
    sql = [NSString stringWithFormat:@"DELETE * FROM %@", [SampleConstants tableName]];
    libraryObjects = [libraryObjectStore executeSqlQuery:sql OnTable:[SampleConstants tableName]];
    XCTAssertNil(libraryObjects, @"executeSqlQuery: should only execute queries that do not change values in the database.");
}

@end