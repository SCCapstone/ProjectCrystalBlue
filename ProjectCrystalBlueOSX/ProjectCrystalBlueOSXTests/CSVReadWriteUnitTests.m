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
#import "FileSystemUtils.h"
#import "LibraryObjectCSVWriter.h"
#import "LibraryObjectCSVReader.h"

@interface CSVReadWriteUnitTests : XCTestCase

@end

@implementation CSVReadWriteUnitTests

NSString* localDirectory;
NSString* filePath;

- (void)setUp
{
    [super setUp];
    localDirectory = [FileSystemUtils testDirectory];
}

- (void)tearDown
{
    [FileSystemUtils clearTestDirectory];
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
        NSString *key = [NSString stringWithFormat:@"%@%05d", SMP_KEY, i];
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
        NSString *key = [NSString stringWithFormat:@"%@%05d", SRC_KEY, i];
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

/// Populates an array of sources, writes them to a file, then parses them again.
/// This time some of the attributes contain commas.
/// The results from the parser should match the original array.
- (void)testWriteAndReadAttributesContainingCommas
{
    filePath = [localDirectory stringByAppendingFormat:@"/%@", @"testWriteSourcesWithCommas.csv"];
    
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    
    const int numberOfSources = 100;
    for (int i = 0; i < numberOfSources; ++i) {
        NSString *key = [NSString stringWithFormat:@"artichoke,eggplant,%@%05d", SRC_KEY, i];
        Source *s = [[Source alloc] initWithKey:key
                              AndWithAttributes:[SourceConstants attributeNames]
                                      AndValues:[SourceConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SourceConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"artichoke,eggplant,%@%05d", attribute, i];
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
        NSString *key = [NSString stringWithFormat:@"%@%05d", SRC_KEY, i];
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

/// Capitalization of headers should not matter when parsing CSV files
- (void)testReadFileWithDifferentCapitalization
{
    NSString *testFile = @"samples_different_capitalization";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];

    NSMutableArray *samples = [[NSMutableArray alloc] init];

    const int numberOfSamples = 3; // Do not change this value unless you create a new test file.

    for (int i = 0; i < numberOfSamples; ++i) {
        NSString *key = [NSString stringWithFormat:@"%@%05d", SRC_KEY, i];
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
        NSString *key = [NSString stringWithFormat:@"%@%05d", SMP_KEY, i];
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

/// Verify that a file with non-ascii characters is correctly parsed.
- (void)testReadFileWithNonAsciiChars
{
    NSString *testFile = @"samples_non_ascii_chars";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];

    // Do not change these values unless you change the test file
    Sample *expected = [[Sample alloc] initWithKey:@"key00000"
                                 AndWithAttributes:[SampleConstants attributeNames]
                                         AndValues:[SampleConstants attributeDefaultValues]];

    [expected.attributes setValue:@"key00000"       forKey:SMP_KEY];
    [expected.attributes setValue:@"98°"            forKey:SMP_SOURCE_KEY];
    [expected.attributes setValue:@"≥_≤"            forKey:SMP_CURRENT_LOCATION];
    [expected.attributes setValue:@"¡™£¢∞§¶•ªº–≠"   forKey:SMP_TAGS];

    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSamples = [reader readFromFileAtPath:testPath];

    XCTAssertTrue(readSamples.count == 1);
    XCTAssertEqualObjects([readSamples objectAtIndex:0], expected);
}

/// Populates an array of sources (containing UTF8 characters in some fields), writes them to a
/// file, then parses them again.
/// The results from the parser should match the original array.
- (void)testWriteAndReadSourcesWithUTF8Characters
{
    filePath = [localDirectory stringByAppendingFormat:@"/%@", @"testWriteSources.csv"];

    NSMutableArray *sources = [[NSMutableArray alloc] init];

    const int numberOfSources = 100;
    for (int i = 0; i < numberOfSources; ++i) {
        NSString *key = [NSString stringWithFormat:@"˚®ˆø∂ƒøˆ∆ƒ%05d", i];
        Source *s = [[Source alloc] initWithKey:key
                              AndWithAttributes:[SourceConstants attributeNames]
                                      AndValues:[SourceConstants attributeDefaultValues]];

        for (NSString *attribute in [SourceConstants attributeNames]) {
            NSString *attributeValue;
            if ([attribute isEqualToString:SRC_KEY]) {
                attributeValue = s.key;
            } else {
                attributeValue = [NSString stringWithFormat:@"ø∑øˆ´øˆˆø∑ˆø´ˆø∑•ªª•%@%05d", attribute, i];
            }
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

/// Reads a test CSV file with Apple's Western Europe encoding.
- (void)testReadSourcesFromAppleWesternEuropeEncoding
{
    NSString *testFile = @"source_with_western_europe_apple_encoding";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];

    NSString *key           = @"å∫ç∂";
    NSString *continent     = @"´ƒ©˙";
    NSString *locality      = @"ÇÎ";
    NSString *region        = @"Åı";
    NSString *hyperlinks    = @"Hyperlinks here";
    NSString *member        = @"¥Ω";
    NSString *latitude      = @"ˆÔ";
    NSString *ageDataType   = @"˛Á¸";
    NSString *type          = @"ˆ∆˚";
    NSString *ageMethod     = @"Œ‰";
    NSString *lithology     = @"¬µ˜øπ";
    NSString *deposystem    = @"œ®ß";
    NSString *meter         = @"˝Ó";
    NSString *longitude     = @"-64° 13.334";
    NSString *rockGroup     = @"†¨√°";
    NSString *age           = @"Ø∏";
    NSString *notes         = @"Notes here";
    NSString *section       = @"´Ï";
    NSString *formation     = @"∑≈";
    NSString *images        = @"ÏÔ˚ÒÅ˚Ò";

    Source *expected = [[Source alloc] initWithKey:key
                                 AndWithAttributes:[SourceConstants attributeNames]
                                         AndValues:[SourceConstants attributeDefaultValues]];

    [expected.attributes setObject:key          forKey:SRC_KEY];
    [expected.attributes setObject:continent    forKey:SRC_CONTINENT];
    [expected.attributes setObject:locality     forKey:SRC_LOCALITY];
    [expected.attributes setObject:region       forKey:SRC_REGION];
    [expected.attributes setObject:hyperlinks   forKey:SRC_HYPERLINKS];
    [expected.attributes setObject:member       forKey:SRC_MEMBER];
    [expected.attributes setObject:latitude     forKey:SRC_LATITUDE];
    [expected.attributes setObject:longitude    forKey:SRC_LONGITUDE];
    [expected.attributes setObject:ageDataType  forKey:SRC_AGE_DATATYPE];
    [expected.attributes setObject:type         forKey:SRC_TYPE];
    [expected.attributes setObject:ageMethod    forKey:SRC_AGE_METHOD];
    [expected.attributes setObject:lithology    forKey:SRC_LITHOLOGY];
    [expected.attributes setObject:deposystem   forKey:SRC_DEPOSYSTEM];
    [expected.attributes setObject:meter        forKey:SRC_METER];
    [expected.attributes setObject:rockGroup    forKey:SRC_GROUP];
    [expected.attributes setObject:age          forKey:SRC_AGE];
    [expected.attributes setObject:notes        forKey:SRC_NOTES];
    [expected.attributes setObject:section      forKey:SRC_SECTION];
    [expected.attributes setObject:formation    forKey:SRC_FORMATION];
    [expected.attributes setObject:images       forKey:SRC_IMAGES];

    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSamples = [reader readFromFileAtPath:testPath];

    Source *actual = [readSamples objectAtIndex:0];
    // We don't care about the dates matching
    [actual.attributes setObject:[expected.attributes objectForKey:SRC_DATE_COLLECTED]
                          forKey:SRC_DATE_COLLECTED];

    XCTAssertEqualObjects(expected, actual);
}

@end
