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
#import "LibraryObjectCSVWriter.h"

#define TEST_DIRECTORY @"pcb-sample-import-controller-test"
#define TEST_DB_NAME @"pcb-test-db"
#define TEST_CSV_FILE @"testSources.csv"

@interface SourceImportControllerTests : XCTestCase {
    AbstractLibraryObjectStore *objectStore;
    NSString *localDirectory;
    NSString *dbPath;
    NSString *csvPath;
}

@end

@implementation SourceImportControllerTests

- (void)setUp
{
    [super setUp];
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    localDirectory = [documentDirectory stringByAppendingFormat:@"/%@", TEST_DIRECTORY];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    objectStore = [[LocalLibraryObjectStore alloc] initInLocalDirectory:localDirectory
                                                       WithDatabaseName:TEST_DB_NAME];
    
    csvPath = [localDirectory stringByAppendingFormat:@"/%@", TEST_CSV_FILE];
    dbPath = [localDirectory stringByAppendingFormat:@"/%@", TEST_DB_NAME];
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:csvPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:localDirectory error:nil];
    [super tearDown];
}


/// Quickly generate a valid array of sources.
- (NSArray *)generateSources:(NSUInteger)count
{
    NSMutableArray *sources = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%04d", i];
        
        Source *s = [[Source alloc] initWithKey:key
                              AndWithAttributes:[SourceConstants attributeNames]
                                      AndValues:[SourceConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SourceConstants attributeNames]) {
            NSString *value = [attribute stringByAppendingFormat:@"%04d", i];
            [s.attributes setObject:value forKey:attribute];
        }
        
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
    [importController fileSelector:nil didOpenFileAtPath:csvPath];
    
    // These samples should now have been imported to the db.
    for (Source *s in testSources) {
        XCTAssertTrue([objectStore libraryObjectExistsForKey:s.key
                                                   FromTable:[SourceConstants tableName]],
                      @"%@ wasn't found", s.key);
        
        XCTAssertEqualObjects(s, [objectStore getLibraryObjectForKey:s.key
                                                           FromTable:[SourceConstants tableName]]
                              , @"Object with key %@ did not match.", s.key);
    }
}

@end
