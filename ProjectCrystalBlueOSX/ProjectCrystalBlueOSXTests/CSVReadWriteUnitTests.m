//
//  CSVWriterUnitTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Split.h"
#import "Sample.h"
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

/// Populates an array of splits, writes them to a file, then parses them again.
/// The results from the parser should match the original array.
- (void)testWriteAndReadSplits
{
    filePath = [localDirectory stringByAppendingFormat:@"/%@", @"testWriteSplits.csv"];
    
    NSMutableArray *splits = [[NSMutableArray alloc] init];
    
    const int numberOfSplits = 100;
    for (int i = 0; i < numberOfSplits; ++i) {
        NSString *key = [NSString stringWithFormat:@"%@%05d", SPL_KEY, i];
        Split *s = [[Split alloc] initWithKey:key
                              AndWithAttributes:[SplitConstants attributeNames]
                                      AndValues:[SplitConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SplitConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"%@%05d", attribute, i];
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [splits addObject:s];
    }
    
    // Write to the file
    LibraryObjectCSVWriter *writer = [[LibraryObjectCSVWriter alloc] init];
    [writer writeObjects:splits
            ToFileAtPath:filePath];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSplits = [reader readFromFileAtPath:filePath];
    
    XCTAssertEqual(readSplits.count, splits.count);
    for (int i = 0; i < numberOfSplits; ++i) {
        LibraryObject *expected = (LibraryObject *)[splits objectAtIndex:i];
        LibraryObject *actual = [readSplits objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
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

/// Populates an array of samples, writes them to a file, then parses them again.
/// This time some of the attributes contain commas.
/// The results from the parser should match the original array.
- (void)testWriteAndReadAttributesContainingCommas
{
    filePath = [localDirectory stringByAppendingFormat:@"/%@", @"testWriteSamplesWithCommas.csv"];
    
    NSMutableArray *samples = [[NSMutableArray alloc] init];
    
    const int numberOfSamples = 100;
    for (int i = 0; i < numberOfSamples; ++i) {
        NSString *key = [NSString stringWithFormat:@"artichoke,eggplant,%@%05d", SMP_KEY, i];
        Sample *s = [[Sample alloc] initWithKey:key
                              AndWithAttributes:[SampleConstants attributeNames]
                                      AndValues:[SampleConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SampleConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"artichoke,eggplant,%@%05d", attribute, i];
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

/// Order should not matter when parsing CSV files
- (void)testReadFileWithReorderedColumns
{
    NSString *testFile = @"splits_reordered_columns";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];
    
    NSMutableArray *splits = [[NSMutableArray alloc] init];
    
    const int numberOfSplits = 3; // Do not change this value unless you create a new test file.
    
    for (int i = 0; i < numberOfSplits; ++i) {
        NSString *key = [NSString stringWithFormat:@"%@%05d", SMP_KEY, i];
        Split *s = [[Split alloc] initWithKey:key
                              AndWithAttributes:[SplitConstants attributeNames]
                                      AndValues:[SplitConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SplitConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"%@%05d", attribute, i];
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [splits addObject:s];
    }
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSplits = [reader readFromFileAtPath:testPath];
    
    XCTAssertEqual(readSplits.count, splits.count);
    for (int i = 0; i < numberOfSplits; ++i) {
        LibraryObject *expected = (LibraryObject *)[splits objectAtIndex:i];
        LibraryObject *actual = [readSplits objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

/// Capitalization of headers should not matter when parsing CSV files
- (void)testReadFileWithDifferentCapitalization
{
    NSString *testFile = @"splits_different_capitalization";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];

    NSMutableArray *splits = [[NSMutableArray alloc] init];

    const int numberOfSplits = 3; // Do not change this value unless you create a new test file.

    for (int i = 0; i < numberOfSplits; ++i) {
        NSString *key = [NSString stringWithFormat:@"%@%05d", SMP_KEY, i];
        Split *s = [[Split alloc] initWithKey:key
                              AndWithAttributes:[SplitConstants attributeNames]
                                      AndValues:[SplitConstants attributeDefaultValues]];

        for (NSString *attribute in [SplitConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"%@%05d", attribute, i];
            [s.attributes setObject:attributeValue forKey:attribute];
        }

        [splits addObject:s];
    }

    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSplits = [reader readFromFileAtPath:testPath];

    XCTAssertEqual(readSplits.count, splits.count);
    for (int i = 0; i < numberOfSplits; ++i) {
        LibraryObject *expected = (LibraryObject *)[splits objectAtIndex:i];
        LibraryObject *actual = [readSplits objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

/// If an item has an extra attribute, it should be ignored.
- (void)testReadFileWithExtraAttribute
{
    NSString *testFile = @"splits_extra_attribute";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];
    
    NSMutableArray *splits = [[NSMutableArray alloc] init];
    
    const int numberOfSplits = 3; // Do not change this value unless you create a new test file.
    
    for (int i = 0; i < numberOfSplits; ++i) {
        NSString *key = [NSString stringWithFormat:@"%@%05d", SPL_KEY, i];
        Split *s = [[Split alloc] initWithKey:key
                              AndWithAttributes:[SplitConstants attributeNames]
                                      AndValues:[SplitConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SplitConstants attributeNames]) {
            NSString *attributeValue = [NSString stringWithFormat:@"%@%05d", attribute, i];
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [splits addObject:s];
    }
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSplits = [reader readFromFileAtPath:testPath];
    
    XCTAssertEqual(readSplits.count, splits.count);
    for (int i = 0; i < numberOfSplits; ++i) {
        LibraryObject *expected = (LibraryObject *)[splits objectAtIndex:i];
        LibraryObject *actual = [readSplits objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

/// If an item is missing any attributes, they should be populated with empty string.
- (void)testReadFileWithMissingAttribute
{
    NSString *testFile = @"splits_missing_attribute";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];
    
    NSMutableArray *splits = [[NSMutableArray alloc] init];
    
    const int numberOfSplits = 3; // Do not change this value unless you need to modify the test file.
    
    for (int i = 0; i < numberOfSplits; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%05d", i];
        Split *s = [[Split alloc] initWithKey:key
                              AndWithAttributes:[SplitConstants attributeNames]
                                      AndValues:[SplitConstants attributeDefaultValues]];
        
        for (NSString *attribute in [SplitConstants attributeNames]) {
            NSString *attributeValue;
            if ([attribute isEqualToString:SPL_KEY]) {
                attributeValue = key;
            } else {
                attributeValue = @"";
            }
            
            [s.attributes setObject:attributeValue forKey:attribute];
        }
        
        [splits addObject:s];
    }
    
    // Read from the file
    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSplits = [reader readFromFileAtPath:testPath];
    
    XCTAssertEqual(readSplits.count, splits.count);
    for (int i = 0; i < numberOfSplits; ++i) {
        LibraryObject *expected = (LibraryObject *)[splits objectAtIndex:i];
        LibraryObject *actual = [readSplits objectAtIndex:i];
        XCTAssertEqualObjects(expected, actual);
    }
}

/// Verify that a file with non-ascii characters is correctly parsed.
- (void)testReadFileWithNonAsciiChars
{
    NSString *testFile = @"splits_non_ascii_chars";
    NSString *testPath = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"csv"];

    // Do not change these values unless you change the test file
    Split *expected = [[Split alloc] initWithKey:@"key00000"
                                 AndWithAttributes:[SplitConstants attributeNames]
                                         AndValues:[SplitConstants attributeDefaultValues]];

    [expected.attributes setValue:@"key00000"       forKey:SPL_KEY];
    [expected.attributes setValue:@"98°"            forKey:SPL_SAMPLE_KEY];
    [expected.attributes setValue:@"≥_≤"            forKey:SPL_CURRENT_LOCATION];
    [expected.attributes setValue:@"¡™£¢∞§¶•ªº–≠"   forKey:SPL_TAGS];

    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSplits = [reader readFromFileAtPath:testPath];

    XCTAssertTrue(readSplits.count == 1);
    XCTAssertEqualObjects([readSplits objectAtIndex:0], expected);
}

/// Populates an array of samples (containing UTF8 characters in some fields), writes them to a
/// file, then parses them again.
/// The results from the parser should match the original array.
- (void)testWriteAndReadSamplesWithUTF8Characters
{
    filePath = [localDirectory stringByAppendingFormat:@"/%@", @"testWriteSamples.csv"];

    NSMutableArray *samples = [[NSMutableArray alloc] init];

    const int numberOfSamples = 100;
    for (int i = 0; i < numberOfSamples; ++i) {
        NSString *key = [NSString stringWithFormat:@"˚®ˆø∂ƒøˆ∆ƒ%05d", i];
        Sample *s = [[Sample alloc] initWithKey:key
                              AndWithAttributes:[SampleConstants attributeNames]
                                      AndValues:[SampleConstants attributeDefaultValues]];

        for (NSString *attribute in [SampleConstants attributeNames]) {
            NSString *attributeValue;
            if ([attribute isEqualToString:SMP_KEY]) {
                attributeValue = s.key;
            } else {
                attributeValue = [NSString stringWithFormat:@"ø∑øˆ´øˆˆø∑ˆø´ˆø∑•ªª•%@%05d", attribute, i];
            }
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

/// Reads a test CSV file with Apple's Western Europe encoding.
- (void)testReadSamplesFromAppleWesternEuropeEncoding
{
    NSString *testFile = @"sample_with_western_europe_apple_encoding";
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

    Sample *expected = [[Sample alloc] initWithKey:key
                                 AndWithAttributes:[SampleConstants attributeNames]
                                         AndValues:[SampleConstants attributeDefaultValues]];

    [expected.attributes setObject:key          forKey:SMP_KEY];
    [expected.attributes setObject:continent    forKey:SMP_CONTINENT];
    [expected.attributes setObject:locality     forKey:SMP_LOCALITY];
    [expected.attributes setObject:region       forKey:SMP_REGION];
    [expected.attributes setObject:hyperlinks   forKey:SMP_HYPERLINKS];
    [expected.attributes setObject:member       forKey:SMP_MEMBER];
    [expected.attributes setObject:latitude     forKey:SMP_LATITUDE];
    [expected.attributes setObject:longitude    forKey:SMP_LONGITUDE];
    [expected.attributes setObject:ageDataType  forKey:SMP_AGE_DATATYPE];
    [expected.attributes setObject:type         forKey:SMP_TYPE];
    [expected.attributes setObject:ageMethod    forKey:SMP_AGE_METHOD];
    [expected.attributes setObject:lithology    forKey:SMP_LITHOLOGY];
    [expected.attributes setObject:deposystem   forKey:SMP_DEPOSYSTEM];
    [expected.attributes setObject:meter        forKey:SMP_METER];
    [expected.attributes setObject:rockGroup    forKey:SMP_GROUP];
    [expected.attributes setObject:age          forKey:SMP_AGE];
    [expected.attributes setObject:notes        forKey:SMP_NOTES];
    [expected.attributes setObject:section      forKey:SMP_SECTION];
    [expected.attributes setObject:formation    forKey:SMP_FORMATION];
    [expected.attributes setObject:images       forKey:SMP_IMAGES];

    LibraryObjectCSVReader *reader = [[LibraryObjectCSVReader alloc] init];
    NSArray *readSplits = [reader readFromFileAtPath:testPath];

    Sample *actual = [readSplits objectAtIndex:0];
    // We don't care about the dates matching
    [actual.attributes setObject:[expected.attributes objectForKey:SMP_DATE_COLLECTED]
                          forKey:SMP_DATE_COLLECTED];

    XCTAssertEqualObjects(expected, actual);
}

@end
