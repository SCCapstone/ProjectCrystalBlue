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
#import "ProcedureRecord.h"
#import "SplitConstants.h"
#import "FileSystemUtils.h"
#import "Split.h"

#define DATABASE_NAME @"procedures-test-db"

@interface PrimitiveProcedureTests : XCTestCase

@end

@implementation PrimitiveProcedureTests

LocalLibraryObjectStore *testStore;

- (void)setUp
{
    [super setUp];
    
    // Set up a test table
    testStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                     WithDatabaseName:DATABASE_NAME];
}

- (void)tearDown
{
    // Just to be sure everything is gone.
    [FileSystemUtils clearTestDirectory];

    [super tearDown];
}

/// Simply clone a single split object.
- (void)testCloneSplit
{
    NSString *key = @"A_ROCK.001";
    Split *s = [[Split alloc] initWithKey:key
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    [s.attributes setObject:key forKey:SPL_KEY];
    
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [PrimitiveProcedures cloneSplit:s
                           intoStore:testStore
                      intoTableNamed:[SplitConstants tableName]];
    
    NSString *expectedKey = @"A_ROCK.002";
    LibraryObject *clone = [testStore getLibraryObjectForKey:expectedKey FromTable:[SplitConstants tableName]];
    
    XCTAssertNotNil(clone, @"No split with expected key %@ was found!", expectedKey);
    for (NSString *attribute in [SplitConstants attributeNames]) {
        NSString *cloneAttributeValue = [[clone attributes] objectForKey:attribute];
        NSString *originalAttributeValue = [[s attributes] objectForKey:attribute];
        
        if ([attribute isEqualToString:SPL_KEY]) {
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
 *  If we clone MY_SPLIT.001, but MY_SPLIT.002 already exists, then the clone will be called MY_SPLIT.003
 */
- (void)testNameCollision
{
    const int NUM_SPLITS_TO_CREATE = 5;
    for (int i = 1; i <= NUM_SPLITS_TO_CREATE; ++i) {
        NSString *key = [NSString stringWithFormat:@"A_ROCK.%03d", i];
        Split *s = [[Split alloc] initWithKey:key
                              AndWithAttributes:[SplitConstants attributeNames]
                                      AndValues:[SplitConstants attributeDefaultValues]];
        
        [s.attributes setObject:key forKey:SPL_KEY];
        
        [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    }
    
    LibraryObject *original = [testStore getLibraryObjectForKey:@"A_ROCK.001" FromTable:[SplitConstants tableName]];
    XCTAssertTrue([original isKindOfClass:[Split class]]);
    
    Split *originalAsSplit = (Split*)original;
    [PrimitiveProcedures cloneSplit:originalAsSplit
                           intoStore:testStore
                      intoTableNamed:[SplitConstants tableName]];
    
    NSString *expectedKey = [NSString stringWithFormat:@"A_ROCK.%03d", NUM_SPLITS_TO_CREATE+1];
    LibraryObject *clone = [testStore getLibraryObjectForKey:expectedKey FromTable:[SplitConstants tableName]];
    
    XCTAssertNotNil(clone, @"No split with expected key %@ was found!", expectedKey);
}

/// verify that the cloneWithClearedTags method sets the tags to empty string
- (void)testCloneWithClearedtags
{
    NSString *key = @"A_ROCK.001";
    Split *s = [[Split alloc] initWithKey:key
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    [s.attributes setObject:key forKey:SPL_KEY];
    [s.attributes setObject:@"TAG, ANOTHER_TAG, MORE_TAGS" forKey:SPL_TAGS];
    
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [PrimitiveProcedures cloneSplitWithClearedTags:s
                                          intoStore:testStore
                                     intoTableNamed:[SplitConstants tableName]];
    
    NSString *expectedKey = @"A_ROCK.002";
    LibraryObject *clone = [testStore getLibraryObjectForKey:expectedKey FromTable:[SplitConstants tableName]];
    
    XCTAssertNotNil(clone, @"No split with expected key %@ was found!", expectedKey);
    NSString *cloneTags = [clone.attributes objectForKey:SPL_TAGS];
    XCTAssertEqualObjects(cloneTags, @"", @"Expected clone to have empty tags, but tag was %@", cloneTags);
}

/// Tests that the appendTagInPlace method correctly appends a tag to a split in place.
- (void)testAppendTagInPlace
{
    NSString *key = @"A_ROCK.001";
    NSString *aInitials = @"AAA";
    NSString *bInitials = @"BBB";
    
    ProcedureRecord *pulvRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_PULVERIZE andInitials:aInitials];
    ProcedureRecord *gemRecord  = [[ProcedureRecord alloc] initWithTag:PROC_TAG_GEMENI_DOWN andInitials:bInitials];
    ProcedureRecord *magRecord  = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HAND_MAGNET_UP andInitials:bInitials];
    
    NSString *originalProcedureRecords = [NSString stringWithFormat:@"%@%@%@%@%@",
                                          pulvRecord,
                                          TAG_DELIMITER,
                                          gemRecord,
                                          TAG_DELIMITER,
                                          magRecord];
                              
    Split *s = [[Split alloc] initWithKey:key
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    [s.attributes setObject:key forKey:SPL_KEY];
    [s.attributes setObject:originalProcedureRecords forKey:SPL_TAGS];
    
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [PrimitiveProcedures appendToSplitInPlace:s
                                     tagString:PROC_TAG_JAWCRUSH
                                  withInitials:aInitials
                                     intoStore:testStore
                                intoTableNamed:[SplitConstants tableName]];
    
    ProcedureRecord *expectedJawRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_JAWCRUSH andInitials:aInitials];
    s = nil;
    
    LibraryObject *retrievedObject = [testStore getLibraryObjectForKey:key FromTable:[SplitConstants tableName]];
    Split *retrievedSplit = (Split*)retrievedObject;
    
    NSString *expectedProcedures = [NSString stringWithFormat:@"%@%@%@", originalProcedureRecords, TAG_DELIMITER, expectedJawRecord];
    NSString *actualProcedures = [retrievedSplit.attributes objectForKey:SPL_TAGS];
    
    XCTAssertEqualObjects(expectedProcedures, actualProcedures,
                          @"Expected procedures: %@ \nActual procedures: %@", expectedProcedures, actualProcedures);
}

/// Tests that the appendTagToClone method correctly appends a tag to a clone of a split.
- (void)testAppendTagToClone
{
    NSString *originalKey = @"A_ROCK.001";
    NSString *aInitials = @"AAA";
    NSString *bInitials = @"BBB";
    
    ProcedureRecord *pulvRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_PULVERIZE andInitials:aInitials];
    ProcedureRecord *gemRecord  = [[ProcedureRecord alloc] initWithTag:PROC_TAG_GEMENI_DOWN andInitials:bInitials];
    ProcedureRecord *magRecord  = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HAND_MAGNET_UP andInitials:bInitials];
    
    NSString *originalProcedureRecords = [NSString stringWithFormat:@"%@%@%@%@%@",
                                          pulvRecord,
                                          TAG_DELIMITER,
                                          gemRecord,
                                          TAG_DELIMITER,
                                          magRecord];
    
    Split *originalSplit = [[Split alloc] initWithKey:originalKey
                                       AndWithAttributes:[SplitConstants attributeNames]
                                               AndValues:[SplitConstants attributeDefaultValues]];
    
    [originalSplit.attributes setObject:originalKey forKey:SPL_KEY];
    [originalSplit.attributes setObject:originalProcedureRecords forKey:SPL_TAGS];
    
    [testStore putLibraryObject:originalSplit IntoTable:[SplitConstants tableName]];
    [PrimitiveProcedures appendToCloneOfSplit:originalSplit
                                     tagString:PROC_TAG_JAWCRUSH
                                  withInitials:aInitials
                                     intoStore:testStore
                                intoTableNamed:[SplitConstants tableName]];
    
    ProcedureRecord *expectedJawRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_JAWCRUSH andInitials:aInitials];
    
    NSString *expectedKey = @"A_ROCK.002";
    
    LibraryObject *retrievedObject = [testStore getLibraryObjectForKey:expectedKey FromTable:[SplitConstants tableName]];
    Split *retrievedSplit = (Split*)retrievedObject;
    
    NSString *expectedProcedures = [NSString stringWithFormat:@"%@%@%@", originalProcedureRecords, TAG_DELIMITER, expectedJawRecord];
    NSString *actualProcedures = [retrievedSplit.attributes objectForKey:SPL_TAGS];
    
    XCTAssertEqualObjects(expectedProcedures, actualProcedures,
                          @"Expected records: %@ \nActual records: %@", expectedProcedures, actualProcedures);
}

@end
