//
//  SourceImportControllerTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SourceImportController.h"
#import "Source.h"
#import "SourceConstants.h"
#import "LocalLibraryObjectStore.h"
#import "FileSystemUtils.h"
#import "LibraryObjectCSVWriter.h"
#import "TestingUtils.h"

#define TEST_DB_NAME @"pcb-test-db"
#define TEST_CSV_FILE @"testSources.csv"

@interface SourceImportControllerTests : XCTestCase {
    AbstractLibraryObjectStore *objectStore;
    NSString *localDirectory;
    NSString *dbPath;
    NSString *csvPath;
    NSString *testDirectoryFullPath;
}

@end

@implementation SourceImportControllerTests

- (void)setUp
{
    [super setUp];
    
    localDirectory = [FileSystemUtils testDirectory];
    objectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils testDirectory]
                                                       WithDatabaseName:TEST_DB_NAME];

    csvPath = [localDirectory stringByAppendingPathComponent:TEST_CSV_FILE];
    dbPath = [localDirectory stringByAppendingPathComponent:TEST_DB_NAME];
}

- (void)tearDown
{
    [FileSystemUtils clearTestDirectory];
    [super tearDown];
}


/// Quickly generate a valid array of sources.
- (NSArray *)generateSources:(NSUInteger)count
{
    NSMutableArray *sources = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY%04d", i];
        
        Source *s = [[Source alloc] initWithKey:key
                              AndWithAttributes:[SourceConstants attributeNames]
                                      AndValues:[SourceConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SourceConstants attributeNames]) {
            NSString *value = [[attribute substringToIndex:3] stringByAppendingFormat:@"%04d", i];
            [s.attributes setObject:value forKey:attribute];
        }

        // some fields are a special case
        [s.attributes setObject:@"128.2" forKey:SRC_METER];
        [s.attributes setObject:@"0.50" forKey:SRC_LATITUDE];
        [s.attributes setObject:@"0.80" forKey:SRC_LONGITUDE];
        [s.attributes setObject:@"1/1/70, 12:00 PM" forKey:SRC_DATE_COLLECTED];
        [s.attributes setObject:@"128" forKey:SRC_AGE];
        
        [sources addObject:s];
    }
    
    return sources;
}

/// Sends the SourceInputController an array of valid samples.
- (void)testSimulateInputValidSamples
{
    NSArray *testSources = [self generateSources:5];
    // write the samples to a csv file
    [[[LibraryObjectCSVWriter alloc] init] writeObjects:testSources ToFileAtPath:csvPath];
    
    SourceImportController *importController = [[SourceImportController alloc] init];
    [importController setLibraryObjectStore:objectStore];
    [importController fileSelectorDidOpenFileAtPath:csvPath];

    [TestingUtils busyWaitForSeconds:0.3f];
    
    // These samples should now have been imported to the db.
    for (Source *s in testSources) {
        XCTAssertTrue([objectStore libraryObjectExistsForKey:s.key
                                                   FromTable:[SourceConstants tableName]],
                      @"%@ wasn't found", s.key);

        Source *expectedSource = s;
        Source *actualSource = (Source *)[objectStore getLibraryObjectForKey:s.key FromTable:[SourceConstants tableName]];
        XCTAssertEqualObjects(expectedSource, actualSource, @"Object with key %@ did not match.", s.key);
    }
}

@end
