//
//  SampleImportControllerTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SampleImportController.h"
#import "Sample.h"
#import "SampleConstants.h"
#import "LocalLibraryObjectStore.h"
#import "FileSystemUtils.h"
#import "LibraryObjectCSVWriter.h"
#import "TestingUtils.h"

#define TEST_DB_NAME @"pcb-test-db"
#define TEST_CSV_FILE @"testSamples.csv"

@interface SampleImportControllerTests : XCTestCase {
    AbstractLibraryObjectStore *objectStore;
    NSString *localDirectory;
    NSString *dbPath;
    NSString *csvPath;
    NSString *testDirectoryFullPath;
}

@end

@implementation SampleImportControllerTests

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


/// Quickly generate a valid array of samples.
- (NSArray *)generateSamples:(NSUInteger)count
{
    NSMutableArray *samples = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; ++i) {
        NSString *key = [NSString stringWithFormat:@"KEY%04d", i];
        
        Sample *s = [[Sample alloc] initWithKey:key
                              AndWithAttributes:[SampleConstants attributeNames]
                                      AndValues:[SampleConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SampleConstants attributeNames]) {
            NSString *value = [[attribute substringToIndex:3] stringByAppendingFormat:@"%04d", i];
            [s.attributes setObject:value forKey:attribute];
        }

        // some fields are a special case
        [s.attributes setObject:@"128.2" forKey:SMP_METER];
        [s.attributes setObject:@"0.50" forKey:SMP_LATITUDE];
        [s.attributes setObject:@"0.80" forKey:SMP_LONGITUDE];
        [s.attributes setObject:@"1/1/70, 12:00 PM" forKey:SMP_DATE_COLLECTED];
        [s.attributes setObject:@"128" forKey:SMP_AGE];
        
        [samples addObject:s];
    }
    
    return samples;
}

/// Sends the SampleInputController an array of valid samples.
- (void)testSimulateInputValidSamples
{
    NSArray *testSamples = [self generateSamples:5];
    // write the samples to a csv file
    [[[LibraryObjectCSVWriter alloc] init] writeObjects:testSamples ToFileAtPath:csvPath];
    
    SampleImportController *importController = [[SampleImportController alloc] init];
    [importController setLibraryObjectStore:objectStore];
    [importController fileSelectorDidOpenFileAtURL:[NSURL fileURLWithPath:csvPath]];

    [TestingUtils busyWaitForSeconds:0.3f];
    
    // These samples should now have been imported to the db.
    for (Sample *s in testSamples) {
        XCTAssertTrue([objectStore libraryObjectExistsForKey:s.key
                                                   FromTable:[SampleConstants tableName]],
                      @"%@ wasn't found", s.key);

        Sample *expectedSample = s;
        Sample *actualSample = (Sample *)[objectStore getLibraryObjectForKey:s.key FromTable:[SampleConstants tableName]];
        XCTAssertEqualObjects(expectedSample, actualSample, @"Object with key %@ did not match.", s.key);
    }
}

@end
