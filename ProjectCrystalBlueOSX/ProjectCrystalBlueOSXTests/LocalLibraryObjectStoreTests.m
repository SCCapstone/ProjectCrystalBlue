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
#import "FileSystemUtils.h"
#import "LocalEncryptedCredentialsProvider.h"
#import "Source.h"
#import "Split.h"

#define DATABASE_NAME @"test_database.db"

@interface LocalLibraryObjectStoreTests : XCTestCase

@end

@implementation LocalLibraryObjectStoreTests {
    NSString *TEST_DIRECTORY;
}

- (void)setUp
{
    TEST_DIRECTORY = [FileSystemUtils testDirectory];
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];

    // Just to be sure everything is cleared
    [FileSystemUtils clearTestDirectory];
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

// Verify that we can successfully Put, Get, Update, and Delete both Source and Split objects
- (void)testPutGetUpdateAndDeleteLibraryObject
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store and make sure they don't already exist
    NSString *sourceKey = @"rock1030";
    Source *sourceObject = [[Source alloc] initWithKey:sourceKey AndWithValues:[SourceConstants attributeDefaultValues]];
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]], @"LocalLibraryObjectStore believes an object with this key already exists.");
    
    NSString *splitKey = @"rock1030.001";
    Split *splitObject = [[Split alloc] initWithKey:splitKey AndWithValues:[SplitConstants attributeDefaultValues]];
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:splitKey FromTable:[SplitConstants tableName]], @"LocalLibraryObjectStore believes an object with this key already exists.");
    
    // Put the library objects into the local database
    BOOL putSuccess = [libraryObjectStore putLibraryObject:sourceObject IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(putSuccess, @"LocalLibraryObjectStore failed to put the library object into the database.");
    
    putSuccess = [libraryObjectStore putLibraryObject:splitObject IntoTable:[SplitConstants tableName]];
    XCTAssertTrue(putSuccess, @"LocalLibraryObjectStore failed to put the library object into the database.");
    
    // Check the added library objects exist in the local database now
    XCTAssertTrue([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]], @"LocalLibraryObjectStore did not find the object.");
    XCTAssertTrue([libraryObjectStore libraryObjectExistsForKey:splitKey FromTable:[SplitConstants tableName]], @"LocalLibraryObjectStore did not find the object.");
    
    // Try to get the added objects
    LibraryObject *storedSource = [libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(storedSource, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects(storedSource, sourceObject, @"The same object was not returned.");
    
    LibraryObject *storedSplit = [libraryObjectStore getLibraryObjectForKey:splitKey FromTable:[SplitConstants tableName]];
    XCTAssertNotNil(storedSplit, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects(storedSplit, splitObject, @"The same object was not returned.");
    
    // Update the objects
    [sourceObject.attributes setObject:@"really old..." forKey:SRC_AGE];
    BOOL updateSuccess = [libraryObjectStore updateLibraryObject:sourceObject IntoTable:[SourceConstants tableName]];
    XCTAssertTrue(updateSuccess, @"LocalLibraryObjectStore failed to update the specified object.");
    
    [splitObject.attributes setObject:@"did so much stuff" forKey:SPL_TAGS];
    updateSuccess = [libraryObjectStore updateLibraryObject:splitObject IntoTable:[SplitConstants tableName]];
    XCTAssertTrue(updateSuccess, @"LocalLibraryObjectStore failed to update the specified object.");
    
    // Check the objects have been updated in the database
    LibraryObject *updatedSource = [libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertNotNil(updatedSource, @"LocalLibraryObjectStore failed to retrieve the specified object.");
    XCTAssertEqualObjects(sourceObject, updatedSource, @"LocalLibraryObjectStore did not update the object properly.");
    
    LibraryObject *updatedSplit = [libraryObjectStore getLibraryObjectForKey:splitKey FromTable:[SplitConstants tableName]];
    XCTAssertEqualObjects(splitObject, updatedSplit, @"LocalLibraryObjectStore did not update the object properly.");
    
    // Delete the added objects
    BOOL deleteSuccess = [libraryObjectStore deleteLibraryObjectWithKey:sourceKey FromTable:[SourceConstants tableName]];
    XCTAssertTrue(deleteSuccess, @"LocalLibraryObjectStore failed to delete the specified object.");
    
    deleteSuccess = [libraryObjectStore deleteLibraryObjectWithKey:splitKey FromTable:[SplitConstants tableName]];
    XCTAssertTrue(deleteSuccess, @"LocalLibraryObjectStore failed to delete the specified object.");
    
    // Veryify the objects have been deleted
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:sourceKey FromTable:[SourceConstants tableName]], @"LocalLibraryObjectStore still contains the object.");
    XCTAssertNil([libraryObjectStore getLibraryObjectForKey:sourceKey FromTable:[SourceConstants tableName]], @"LocalLibraryObjectStore should have returned nil.");
    
    XCTAssertFalse([libraryObjectStore libraryObjectExistsForKey:splitKey FromTable:[SplitConstants tableName]], @"LocalLibraryObjectStore still contains find the object.");
    XCTAssertNil([libraryObjectStore getLibraryObjectForKey:splitKey FromTable:[SplitConstants tableName]], @"LocalLibraryObjectStore should have returned nil.");
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

/// Verify can get all splits that originated from a source
- (void)testGetSplitsForSourceKey
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Make sure all corresponding splits are returned
    NSArray *splits = [libraryObjectStore getAllSplitsForSampleKey:@"rock1"];
    XCTAssertNotNil(splits, @"LibraryObjectStore failed to get the splits.");
    XCTAssertTrue(splits.count == 5, @"LibraryObjectStore should have returned 5 splits.");
}

/// Verify that executing a custom sql query returns the correct library objects
- (void)testExecuteSqlQuery
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Execute some commands and make sure they return the correct objects
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='rock1'", [SplitConstants tableName], SPL_SAMPLE_KEY];
    NSArray *libraryObjects = [libraryObjectStore getLibraryObjectsWithSqlQuery:sql OnTable:[SplitConstants tableName]];
    XCTAssertNotNil(libraryObjects, @"LibraryObjectStore failed to execute the query.");
    XCTAssertTrue(libraryObjects.count == 5, @"LibraryObjectStore should have returned 5 splits.");
    
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='rock4'", [SplitConstants tableName], SPL_SAMPLE_KEY];
    libraryObjects = [libraryObjectStore getLibraryObjectsWithSqlQuery:sql OnTable:[SplitConstants tableName]];
    XCTAssertNotNil(libraryObjects, @"LibraryObjectStore failed to execute the query.");
    XCTAssertTrue(libraryObjects.count == 5, @"LibraryObjectStore should have returned 5 splits.");
    
    // Make sure invalid command type returns nil
    sql = [NSString stringWithFormat:@"DELETE * FROM %@", [SplitConstants tableName]];
    libraryObjects = [libraryObjectStore getLibraryObjectsWithSqlQuery:sql OnTable:[SplitConstants tableName]];
    XCTAssertNil(libraryObjects, @"executeSqlQuery: should only execute queries that do not change values in the database.");
}

/// Verify all splits are deleted when deleting its source
- (void)testDeleteSourceWithSplits
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Delete a source and make sure its splits are deleted too
    BOOL deleteSuccess = [libraryObjectStore deleteLibraryObjectWithKey:@"rock1" FromTable:[SourceConstants tableName]];
    XCTAssertTrue(deleteSuccess, @"LibraryObjectStore failed to delete the library object and its splits from the database.");
    NSArray *splits = [libraryObjectStore getAllLibraryObjectsFromTable:[SplitConstants tableName]];
    XCTAssertNotNil(splits, @"LibraryObjectStore failed to get splits from table.");
    XCTAssertTrue(splits.count == 20, @"LibraryObjectStore should have returned 1 split.");
}

/// Verify all library objects are returned for a specified attribute value
- (void)testGetAllLibraryObjectsForAttributeValue
{
    AbstractLibraryObjectStore *libraryObjectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:TEST_DIRECTORY
                                                                                          WithDatabaseName:DATABASE_NAME];
    // Setup some objects to store
    [self populateDatabaseWithLibraryObjectStore:libraryObjectStore];
    
    // Ensure all objects with attribute value are retrieved
    NSArray *splits = [libraryObjectStore getAllLibraryObjectsForAttributeName:SPL_SAMPLE_KEY
                                                             WithAttributeValue:@"rock1"
                                                                      FromTable:[SplitConstants tableName]];
    XCTAssertNotNil(splits, @"LibraryObjectStore failed to get objects from store.");
    XCTAssertTrue(splits.count == 5, @"LibraryObjectStore failed to return the correct number of objects.");
    
    // Ensure if no values apply, empty array is returned
    splits = [libraryObjectStore getAllLibraryObjectsForAttributeName:SPL_SAMPLE_KEY
                                                    WithAttributeValue:@"rock7"
                                                             FromTable:[SplitConstants tableName]];
    XCTAssertNotNil(splits, @"LibraryObjectStore failed to get objects from store.");
    XCTAssertTrue(splits.count == 0, @"LibraryObjectStore failed to return the correct number of objects.");
}

/// Verify a unique list of attribute values is returned for a attribute name
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

/// Populate database with 5 sources and 5 splits for each source
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
            NSString *splitKey = [NSString stringWithFormat:@"rock%d.00%d", i, j];
            Split *split = [[Split alloc] initWithKey:splitKey AndWithValues:[SplitConstants attributeDefaultValues]];
            [split.attributes setObject:sourceKey forKey:SPL_SAMPLE_KEY];
            [libraryObjectStore putLibraryObject:split IntoTable:[SplitConstants tableName]];
        }
    }
    
    // Make sure objects were put into the store correctly
    NSArray *sources = [libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]];
    XCTAssertNotNil(sources, @"LibraryObjectStore faied to get sources from table.");
    XCTAssertTrue(sources.count == 5, @"LibraryObjectStore failed to put all source objects.");
    
    NSArray *splits = [libraryObjectStore getAllLibraryObjectsFromTable:[SplitConstants tableName]];
    XCTAssertNotNil(splits, @"LibraryObjectStore faied to get splits from table.");
    XCTAssertTrue(splits.count == 25, @"LibraryObjectStore failed to put all split objects.");
}

@end