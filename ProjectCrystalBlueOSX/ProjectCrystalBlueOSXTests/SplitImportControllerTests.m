//
//  SplitImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SplitImportController.h"
#import "Split.h"
#import "SplitConstants.h"
#import "LocalLibraryObjectStore.h"
#import "LibraryObjectCSVWriter.h"
#import "FileSystemUtils.h"
#import "TestingUtils.h"

#define TEST_DB_NAME @"pcb-test-db"
#define TEST_CSV_FILE @"testSamples.csv"

@interface SplitImportControllerTests : XCTestCase {
    AbstractLibraryObjectStore *objectStore;
    NSString *localDirectory;
    NSString *dbPath;
    NSString *csvPath;
}

@end

@implementation SplitImportControllerTests

- (void)setUp
{
    [super setUp];
    localDirectory = [FileSystemUtils testDirectory];

    objectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:localDirectory
                                                       WithDatabaseName:TEST_DB_NAME];
    
    csvPath = [localDirectory stringByAppendingFormat:@"/%@", TEST_CSV_FILE];
    dbPath = [localDirectory stringByAppendingFormat:@"/%@", TEST_DB_NAME];
}

- (void)tearDown
{
    [FileSystemUtils clearTestDirectory];
    [super tearDown];
}

/// Quickly generate a valid array of splits.
- (NSArray *)generateSplits:(NSUInteger)count
{
    NSMutableArray *splits = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY%04d", i];
        
        Split *s = [[Split alloc] initWithKey:key
                              AndWithAttributes:[SplitConstants attributeNames]
                                      AndValues:[SplitConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SplitConstants attributeNames]) {
            NSString *value = [attribute stringByAppendingFormat:@"%04d", i];
            [s.attributes setObject:value forKey:attribute];
        }
        
        [splits addObject:s];
    }
    
    return splits;
}

/// Sends the SplitInputController an array of valid splits.
- (void)testSimulateInputValidSamples
{
    NSArray *testSplits = [self generateSplits:5];
    // write the splits to a csv file
    [[[LibraryObjectCSVWriter alloc] init] writeObjects:testSplits ToFileAtPath:csvPath];
    
    SplitImportController *importController = [[SplitImportController alloc] init];
    [importController setLibraryObjectStore:objectStore];
    [importController fileSelectorDidOpenFileAtPath:csvPath];

    [TestingUtils busyWaitForSeconds:0.2f];

    // These splits should now have been imported to the db.
    for (Split *s in testSplits) {
        XCTAssertTrue([objectStore libraryObjectExistsForKey:s.key
                                                   FromTable:[SplitConstants tableName]],
                      @"%@ wasn't found", s.key);
        
        XCTAssertEqualObjects(s, [objectStore getLibraryObjectForKey:s.key
                                                           FromTable:[SplitConstants tableName]]
                              , @"Object with key %@ did not match.", s.key);
    }
}

@end
