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
    NSString *databasePath = [[documentsDirectory stringByAppendingPathComponent:TEST_DIRECTORY] stringByAppendingPathComponent:DATABASE_NAME];
    BOOL success = [NSFileManager.defaultManager removeItemAtPath:databasePath error:&error];
    XCTAssertTrue(success, @"Error removing database file! Error: %@", error);
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
    [libraryObjectStore libraryObjectExistsForKey:nonexistentKey FromTable:[SourceConstants tableName]];
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
    XCTAssertEqualObjects(storedSource, sourceObject, @"The same object was not returned.");
    
    LibraryObject *storedSample = [libraryObjectStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];
    XCTAssertNotNil(storedSample, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects(storedSample, sampleObject, @"The same object was not returned.");
    
    // Update the objects
    [sourceObject.attributes setObject:@"really old..." forKey:SRC_AGE];
    BOOL updateSuccess = [libraryObjectStore updateLibraryObject:sourceObject IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(updateSuccess, @"LocalLibraryObjectStore failed to update the specified object.");
    
    [sampleObject.attributes setObject:@"did so much stuff" forKey:SMP_TAGS];
    updateSuccess = [libraryObjectStore updateLibraryObject:sampleObject IntoTable:[SampleConstants tableName]];
    XCTAssertTrue(updateSuccess, @"LocalLibraryObjectStore failed to update the specified object.");
    
    // Check the objects have been updated in the database
    LibraryObject *updatedSource = [libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(updatedSource, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects(sourceObject, updatedSource, @"LocalLibraryObjectStore did not update the object properly.");
    
    LibraryObject *updatedSample = [libraryObjectStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];
    XCTAssertEqualObjects(sampleObject, updatedSample, @"LocalLibraryObjectStore did not update the object properly.");
    
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
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Get all of the objects
    NSArray *allObjects = [libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]];
    XCTAssertNotNil(allObjects, @"LibraryObjectStore failed to get all library objects.");
    XCTAssertTrue(allObjects.count == 5, @"All of the objects were not returned from LibraryObjectStore.");
}

/// Verify the correct number of library objects from table is returned
- (void)testCountLibraryObjects
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Get the count
    NSInteger objectCount = [libraryObjectStore countInTable:[SourceConstants tableName]];
    XCTAssertTrue(objectCount == 5, @"All of the objects were not returned from LibraryObjectStore.");
}

/// Verify can get all samples that originated from a source
- (void)testGetSamplesForSourceKey
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Make sure all corresponding samples are returned
    NSArray *samples = [libraryObjectStore getAllSamplesForSourceKey:@"rock1"];
    XCTAssertNotNil(samples, @"LibraryObjectStore failed to get the samples.");
    XCTAssertTrue(samples.count == 5, @"LibraryObjectStore should have returned 5 samples.");
}

/// Verify that executing a custom sql query returns the correct library objects
- (void)testExecuteSqlQuery
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Execute some commands and make sure they return the correct objects
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='rock1'", [SampleConstants tableName], SMP_SOURCE_KEY];
    NSArray *libraryObjects = [libraryObjectStore executeSqlQuery:sql OnTable:[SampleConstants tableName]];
    XCTAssertNotNil(libraryObjects, @"LibraryObjectStore failed to execute the query.");
    XCTAssertTrue(libraryObjects.count == 5, @"LibraryObjectStore should have returned 5 samples.");
    
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='rock4'", [SampleConstants tableName], SMP_SOURCE_KEY];
    libraryObjects = [libraryObjectStore executeSqlQuery:sql OnTable:[SampleConstants tableName]];
    XCTAssertNotNil(libraryObjects, @"LibraryObjectStore failed to execute the query.");
    XCTAssertTrue(libraryObjects.count == 5, @"LibraryObjectStore should have returned 5 samples.");
    
    // Make sure invalid command type returns nil
    sql = [NSString stringWithFormat:@"DELETE * FROM %@", [SampleConstants tableName]];
    libraryObjects = [libraryObjectStore executeSqlQuery:sql OnTable:[SampleConstants tableName]];
    XCTAssertNil(libraryObjects, @"executeSqlQuery: should only execute queries that do not change values in the database.");
}

/// Verify all samples are deleted when deleting its source
- (void)testDeleteSourceWithSamples
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Delete a source and make sure its samples are deleted too
    BOOL deleteSuccess = [libraryObjectStore deleteLibraryObjectWithKey:@"rock1" FromTable:[SourceConstants tableName]];
    XCTAssertTrue(deleteSuccess, @"LibraryObjectStore failed to delete the library object and its samples from the database.");
    NSArray *samples = [libraryObjectStore getAllLibraryObjectsFromTable:[SampleConstants tableName]];
    XCTAssertNotNil(samples, @"LibraryObjectStore failed to get samples from table.");
    XCTAssertTrue(samples.count == 20, @"LibraryObjectStore should have returned 1 sample.");
}

- (void)testGetAllLibraryObjectsForAttributeValue
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Ensure all objects with attribute value are retrieved
    NSArray *samples = [libraryObjectStore getAllLibraryObjectsForAttributeName:SMP_SOURCE_KEY
                                                             WithAttributeValue:@"rock1"
                                                                      FromTable:[SampleConstants tableName]];
    XCTAssertNotNil(samples, @"LibraryObjectStore failed to get objects from store.");
    XCTAssertTrue(samples.count == 5, @"LibraryObjectStore failed to return the correct number of objects.");
    
    // Ensure if no values apply, empty array is returned
    samples = [libraryObjectStore getAllLibraryObjectsForAttributeName:SMP_SOURCE_KEY
                                                    WithAttributeValue:@"rock7"
                                                             FromTable:[SampleConstants tableName]];
    XCTAssertNotNil(samples, @"LibraryObjectStore failed to get objects from store.");
    XCTAssertTrue(samples.count == 0, @"LibraryObjectStore failed to return the correct number of objects.");
}

- (void)testGetUniqueAttributeValues
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Try to get unique values and make sure the correct number is returned
    NSArray *uniqueValues = [libraryObjectStore getUniqueAttributeValuesForAttributeName:SRC_AGE
                                                                               FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(uniqueValues, @"LibraryObjectStore failed to get unique values from store.");
    XCTAssertTrue(uniqueValues.count == 1, @"LibraryObjectStore returned the incorrect number of items.");
    
    uniqueValues = [libraryObjectStore getUniqueAttributeValuesForAttributeName:SRC_KEY
                                                                      FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(uniqueValues, @"LibraryObjectStore failed to get unique values from store.");
    XCTAssertTrue(uniqueValues.count == 5, @"LibraryObjectStore returned the incorrect number of items.");
}

- (void)populateDatabaseWithLibraryObjectStore:(AbstractLibraryObjectStore *)libraryObjectStore
{
    for (int i=0; i<5; i++)
    {
        NSString *sourceKey = [NSString stringWithFormat:@"rock%d", i];
        Source *source = [[Source alloc] initWithKey:sourceKey AndWithValues:[SourceConstants attributeDefaultValues]];
        [source.attributes setObject:@"really old..." forKey:SRC_AGE];
        [libraryObjectStore putLibraryObject:source IntoTable:[SourceConstants tableName]];
        
        for (int j=0; j<5; j++)
        {
            NSString *sampleKey = [NSString stringWithFormat:@"rock%d.00%d", i, j];
            Sample *sample = [[Sample alloc] initWithKey:sampleKey AndWithValues:[SampleConstants attributeDefaultValues]];
            [sample.attributes setObject:sourceKey forKey:SMP_SOURCE_KEY];
            [libraryObjectStore putLibraryObject:sample IntoTable:[SampleConstants tableName]];
        }
    }
    
    // Make sure objects were put into the store correctly
    NSArray *sources = [libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]];
    XCTAssertNotNil(sources, @"LibraryObjectStore faied to get sources from table.");
    XCTAssertTrue(sources.count == 5, @"LibraryObjectStore failed to put all source objects.");
    
    NSArray *samples = [libraryObjectStore getAllLibraryObjectsFromTable:[SampleConstants tableName]];
    XCTAssertNotNil(samples, @"LibraryObjectStore faied to get samples from table.");
    XCTAssertTrue(samples.count == 25, @"LibraryObjectStore failed to put all sample objects.");
}

@end