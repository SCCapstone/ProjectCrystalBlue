//
//  LibraryObjectCSVReader.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObjectCSVReader.h"
#import "LibraryObject.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/** 
 *  CSVParserDelegate is a "private" class to serve as the CHCSVParserDelegate.
 *  (Scroll down if you're looking for the LibraryObjectCSVReader implementation.)
 */
@interface CsvParserDelegate : NSObject <CHCSVParserDelegate> {
    NSMutableArray *objects;
    NSMutableArray *header;
    NSMutableArray *currentFields;
}

-(NSArray *)getParsedLibraryObjects;

@end
@implementation CsvParserDelegate

- (id)init
{
    self = [super init];
    if (self) {
        objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)getParsedLibraryObjects {
    return objects;
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    currentFields = [[NSMutableArray alloc] init];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    if (nil == currentFields
        || currentFields.count == 0
        || [[currentFields firstObject] isEqualToString:@""])
    {
        return;
    }
    
    if (!header) {
        header = [[NSMutableArray alloc] init];
        [header addObjectsFromArray:currentFields];
    } else {
        // make sure all fields at least have empty string
        while (currentFields.count < header.count) {
            [currentFields addObject:@""];
        }
        
        NSUInteger keyIndex = [header indexOfObject:@"key"];
        LibraryObject *object = [[LibraryObject alloc] initWithKey:[currentFields objectAtIndex:keyIndex]
                                                 AndWithAttributes:header
                                                         AndValues:currentFields];
        [objects addObject:object];
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    if (header && fieldIndex >= header.count) {
        // In case there are extra fields in the file, we should ignore them.
        return;
    }
    [currentFields addObject:field];
}

@end

/* ------------------------------------- */

@implementation LibraryObjectCSVReader

/// Read an Array of LibraryObjects from a CSV file.
-(NSArray *)readFromFileAtPath:(NSString *)filePath;
{
    bool fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (!fileExists) {
        DDLogWarn(@"File does not exist at %@", filePath);
        [NSException raise:@"FileNotFound" format:@"Did not find csv file at %@", filePath];
    }
    CsvParserDelegate *parserDelegate = [[CsvParserDelegate alloc] init];
    
    csvParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:filePath delimiter:','];
    [csvParser setSanitizesFields:YES];
    [csvParser setDelegate:parserDelegate];
    [csvParser parse];
    
    return [parserDelegate getParsedLibraryObjects];
}

/// MIME representatation for CSV files (text/csv)
+(NSString *)fileFormat {
    return @"text/csv";
}

@end