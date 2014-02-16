//
//  PrimitiveProcedureTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AbstractLibraryObjectStore.h"
#import "LocalLibraryObjectStore.h"
#import "PrimitiveProcedures.h"
#import "ProcedureNameConstants.h"
#import "SampleConstants.h"
#import "Sample.h"

#define TEST_DIR @"pcb-procedures-tests"
#define DATABASE_NAME @"procedures-test-db"

@interface PrimitiveProcedureTests : XCTestCase

@end

@implementation PrimitiveProcedureTests

LocalLibraryObjectStore *testStore;

- (void)setUp
{
    [super setUp];
    
    // Set up a test table
    testStore = [[LocalLibraryObjectStore alloc]
                       initInLocalDirectory:TEST_DIR
                          WithDatabaseName:DATABASE_NAME];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    // Remove test store
    NSError *error = nil;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *databasePath = [[documentsDirectory stringByAppendingPathComponent:TEST_DIR]
                              stringByAppendingPathComponent:DATABASE_NAME];
    [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&error];
    XCTAssertNil(error, @"Error removing database file!");
}

/// Simply clone a single sample object.
- (void)testCloneSample
{
    NSString *key = @"A_ROCK.001";
    Sample *s = [[Sample alloc] initWithKey:key
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    [s.attributes setObject:key forKey:SMP_KEY];
    
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [PrimitiveProcedures cloneSample:s
                           intoStore:testStore
                      intoTableNamed:[SampleConstants tableName]];
    
    NSString *expectedKey = @"A_ROCK.002";
    LibraryObject *clone = [testStore getLibraryObjectForKey:expectedKey FromTable:[SampleConstants tableName]];
    
    XCTAssertNotNil(clone, @"No sample with expected key %@ was found!", expectedKey);
    for (NSString *attribute in [SampleConstants attributeNames]) {
        NSString *cloneAttributeValue = [[clone attributes] objectForKey:attribute];
        NSString *originalAttributeValue = [[s attributes] objectForKey:attribute];
        
        if ([attribute isEqualToString:SMP_KEY]) {
            XCTAssertEqualObjects(cloneAttributeValue, expectedKey,
                                  @"Key attribute in clone was %@; expected %@", cloneAttributeValue, expectedKey);
            continue;
        }
        
        XCTAssertEqualObjects(originalAttributeValue, cloneAttributeValue,
                              @"Values for attribute \"%@\" did not match: %@, %@",
                              attribute, originalAttributeValue, cloneAttributeValue);
    }
}

/**
 *  If we clone MY_SAMPLE.001, but MY_SAMPLE.002 already exists, then the clone will be called MY_SAMPLE.003
 */
- (void)testNameCollision
{
    const int NUM_SAMPLES_TO_CREATE = 5;
    for (int i = 1; i <= NUM_SAMPLES_TO_CREATE; ++i) {
        NSString *key = [NSString stringWithFormat:@"A_ROCK.%03d", i];
        Sample *s = [[Sample alloc] initWithKey:key
                              AndWithAttributes:[SampleConstants attributeNames]
                                      AndValues:[SampleConstants attributeDefaultValues]];
        
        [s.attributes setObject:key forKey:SMP_KEY];
        
        [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    }
    
    LibraryObject *original = [testStore getLibraryObjectForKey:@"A_ROCK.001" FromTable:[SampleConstants tableName]];
    XCTAssertTrue([original isKindOfClass:[Sample class]]);
    
    Sample *originalAsSample = (Sample*)original;
    [PrimitiveProcedures cloneSample:originalAsSample
                           intoStore:testStore
                      intoTableNamed:[SampleConstants tableName]];
    
    NSString *expectedKey = [NSString stringWithFormat:@"A_ROCK.%03d", NUM_SAMPLES_TO_CREATE+1];
    LibraryObject *clone = [testStore getLibraryObjectForKey:expectedKey FromTable:[SampleConstants tableName]];
    
    XCTAssertNotNil(clone, @"No sample with expected key %@ was found!", expectedKey);
}

/// verify that the cloneWithClearedTags method sets the tags to empty string
- (void)testCloneWithClearedtags
{
    NSString *key = @"A_ROCK.001";
    Sample *s = [[Sample alloc] initWithKey:key
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    [s.attributes setObject:key forKey:SMP_KEY];
    [s.attributes setObject:@"TAG, ANOTHER_TAG, MORE_TAGS" forKey:SMP_TAGS];
    
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [PrimitiveProcedures cloneSampleWithClearedTags:s
                                          intoStore:testStore
                                     intoTableNamed:[SampleConstants tableName]];
    
    NSString *expectedKey = @"A_ROCK.002";
    LibraryObject *clone = [testStore getLibraryObjectForKey:expectedKey FromTable:[SampleConstants tableName]];
    
    XCTAssertNotNil(clone, @"No sample with expected key %@ was found!", expectedKey);
    NSString *cloneTags = [clone.attributes objectForKey:SMP_TAGS];
    XCTAssertEqualObjects(cloneTags, @"", @"Expected clone to have empty tags, but tag was %@", cloneTags);
}

/// Tests that the appendTagInPlace method correctly appends a tag to a sample in place.
- (void)testAppendTagInPlace
{
    NSString *key = @"A_ROCK.001";
    
    NSString *originalTags = [NSString stringWithFormat:@"%@%@%@%@%@",
                              PROC_TAG_PULVERIZE,
                              TAG_DELIMITER,
                              PROC_TAG_GEMINI_DOWN,
                              TAG_DELIMITER,
                              PROC_TAG_HAND_MAGNET_UP];
                              
    Sample *s = [[Sample alloc] initWithKey:key
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    [s.attributes setObject:key forKey:SMP_KEY];
    [s.attributes setObject:originalTags forKey:SMP_TAGS];
    
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:s
                                     tagString:PROC_TAG_JAWCRUSH
                                     intoStore:testStore
                                intoTableNamed:[SampleConstants tableName]];
    
    s = nil;
    
    LibraryObject *retrievedObject = [testStore getLibraryObjectForKey:key FromTable:[SampleConstants tableName]];
    Sample *retrievedSample = (Sample*)retrievedObject;
    
    NSString *expectedTags = [NSString stringWithFormat:@"%@%@%@", originalTags, TAG_DELIMITER, PROC_TAG_JAWCRUSH];
    NSString *actualTags = [retrievedSample.attributes objectForKey:SMP_TAGS];
    
    XCTAssertEqualObjects(expectedTags, actualTags, @"Expected tags: %@ \nActual tags: %@", expectedTags, actualTags);
}

/// Tests that the appendTagToClone method correctly appends a tag to a clone of a sample.
- (void)testAppendTagToClone
{
    NSString *originalKey = @"A_ROCK.001";
    
    NSString *originalTags = [NSString stringWithFormat:@"%@%@%@%@%@",
                              PROC_TAG_PULVERIZE,
                              TAG_DELIMITER,
                              PROC_TAG_GEMINI_DOWN,
                              TAG_DELIMITER,
                              PROC_TAG_HAND_MAGNET_UP];
    
    Sample *originalSample = [[Sample alloc] initWithKey:originalKey
                                       AndWithAttributes:[SampleConstants attributeNames]
                                               AndValues:[SampleConstants attributeDefaultValues]];
    
    [originalSample.attributes setObject:originalKey forKey:SMP_KEY];
    [originalSample.attributes setObject:originalTags forKey:SMP_TAGS];
    
    [testStore putLibraryObject:originalSample IntoTable:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToCloneOfSample:originalSample
                                     tagString:PROC_TAG_JAWCRUSH
                                     intoStore:testStore
                                intoTableNamed:[SampleConstants tableName]];
    
    NSString *expectedKey = @"A_ROCK.002";
    
    LibraryObject *retrievedObject = [testStore getLibraryObjectForKey:expectedKey FromTable:[SampleConstants tableName]];
    Sample *retrievedSample = (Sample*)retrievedObject;
    
    NSString *expectedTags = [NSString stringWithFormat:@"%@%@%@", originalTags, TAG_DELIMITER, PROC_TAG_JAWCRUSH];
    NSString *actualTags = [retrievedSample.attributes objectForKey:SMP_TAGS];
    
    XCTAssertEqualObjects(expectedTags, actualTags, @"Expected tags: %@ \nActual tags: %@", expectedTags, actualTags);
}

@end
