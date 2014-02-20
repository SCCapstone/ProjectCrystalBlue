//
//  CSVWriterUnitTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Sample.h"
#import "Source.h"
#import "LibraryObjectCSVWriter.h"
#import "LibraryObjectCSVReader.h"

#define TEST_DIRECTORY @"csv-test-directory"

@interface CSVReadWriteUnitTests : XCTestCase

@end

@implementation CSVReadWriteUnitTests

NSString* localDirectory;
NSString* filePath;

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
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:localDirectory error:nil];
    [super tearDown];
}

/// Populates an array of samples, writes them to a file, then parses them again.
/// The results from the parser should match the original array.
- (void)testWriteAndReadSamples
{
    filePath = [localDirectory stringByAppendingFormat:@"/%@", @"testWriteSamples.csv"];
    
    NSMutableArray *samples = [[NSMutableArray alloc] init];
    
    const int numberOfSamples = 100;
    for (int i = 0; i < numberOfSamples; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%05d", i];
        Sample *s = [[Sample alloc] initWithKey:key
                              AndWithAttributes:[SampleConstants attributeNames]
                                      AndValues:[SampleConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SampleConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"%@%05d", attribute, i];
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [samples addObject:s];
    }
    
    // Write to the file
    LibraryObjectCSVWriter *writer = [[LibraryObjectCSVWriter alloc] init];
    [writer writeObjects:samples
            ToFileAtPath:filePath];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSamples = [reader readFromFileAtPath:filePath];
    
    XCTAssertEqual(readSamples.count, samples.count);
    for (int i = 0; i < numberOfSamples; ++i) {
        LibraryObject *expected = (LibraryObject *)[samples objectAtIndex:i];
        LibraryObject *actual = [readSamples objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

/// Populates an array of sources, writes them to a file, then parses them again.
/// The results from the parser should match the original array.
- (void)testWriteAndReadSources
{
    filePath = [localDirectory stringByAppendingFormat:@"/%@", @"testWriteSources.csv"];
    
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    
    const int numberOfSources = 100;
    for (int i = 0; i < numberOfSources; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%05d", i];
        Source *s = [[Source alloc] initWithKey:key
                              AndWithAttributes:[SourceConstants attributeNames]
                                      AndValues:[SourceConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SourceConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"%@%05d", attribute, i];
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [sources addObject:s];
    }
    
    // Write to the file
    LibraryObjectCSVWriter *writer = [[LibraryObjectCSVWriter alloc] init];
    [writer writeObjects:sources
            ToFileAtPath:filePath];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSources = [reader readFromFileAtPath:filePath];
    
    XCTAssertEqual(readSources.count, sources.count);
    for (int i = 0; i < numberOfSources; ++i) {
        LibraryObject *expected = (LibraryObject *)[sources objectAtIndex:i];
        LibraryObject *actual = [readSources objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

/// Order should not matter when parsing CSV files
- (void)testReadFileWithReorderedColumns
{
    NSString *testFile = @"samples_reordered_columns";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];
    
    NSMutableArray *samples = [[NSMutableArray alloc] init];
    
    const int numberOfSamples = 3; // Do not change this value unless you create a new test file.
    
    for (int i = 0; i < numberOfSamples; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%05d", i];
        Sample *s = [[Sample alloc] initWithKey:key
                              AndWithAttributes:[SampleConstants attributeNames]
                                      AndValues:[SampleConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SampleConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"%@%05d", attribute, i];
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [samples addObject:s];
    }
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSamples = [reader readFromFileAtPath:testPath];
    
    XCTAssertEqual(readSamples.count, samples.count);
    for (int i = 0; i < numberOfSamples; ++i) {
        LibraryObject *expected = (LibraryObject *)[samples objectAtIndex:i];
        LibraryObject *actual = [readSamples objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

/// If an item has an extra attribute, it should be ignored.
- (void)testReadFileWithExtraAttribute
{
    NSString *testFile = @"samples_extra_attribute";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];
    
    NSMutableArray *samples = [[NSMutableArray alloc] init];
    
    const int numberOfSamples = 3; // Do not change this value unless you create a new test file.
    
    for (int i = 0; i < numberOfSamples; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%05d", i];
        Sample *s = [[Sample alloc] initWithKey:key
                              AndWithAttributes:[SampleConstants attributeNames]
                                      AndValues:[SampleConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SampleConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"%@%05d", attribute, i];
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [samples addObject:s];
    }
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSamples = [reader readFromFileAtPath:testPath];
    
    XCTAssertEqual(readSamples.count, samples.count);
    for (int i = 0; i < numberOfSamples; ++i) {
        LibraryObject *expected = (LibraryObject *)[samples objectAtIndex:i];
        LibraryObject *actual = [readSamples objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

/// If an item is missing any attributes, they should be populated with empty string.
- (void)testReadFileWithMissingAttribute
{
    NSString *testFile = @"samples_missing_attribute";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];
    
    NSMutableArray *samples = [[NSMutableArray alloc] init];
    
    const int numberOfSamples = 3; // Do not change this value unless you need to modify the test file.
    
    for (int i = 0; i < numberOfSamples; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%05d", i];
        Sample *s = [[Sample alloc] initWithKey:key
                              AndWithAttributes:[SampleConstants attributeNames]
                                      AndValues:[SampleConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SampleConstants attributeNames]) {
            NSString *attributeValue;
            if ([attribute isEqualToString:SMP_KEY]) {
                attributeValue = key;
            } else {
                attributeValue = @"";
            }
            
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [samples addObject:s];
    }
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSamples = [reader readFromFileAtPath:testPath];
    
    XCTAssertEqual(readSamples.count, samples.count);
    for (int i = 0; i < numberOfSamples; ++i) {
        LibraryObject *expected = (LibraryObject *)[samples objectAtIndex:i];
        LibraryObject *actual = [readSamples objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

@end
