//
//  LibraryObjectCSVWriter.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObjectCSVWriter.h"
#import "LibraryObject.h"
#import "DDLog.h"
#import "Source.h"
#import "SourceConstants.h"
#import "Sample.h"
#import "SampleConstants.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation LibraryObjectCSVWriter

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 *  Write an Array of LibraryObjects to a CSV file.
 */
-(void)writeObjects:(NSArray *)libraryObjects
       ToFileAtPath:(NSString *)filePath;
{
    if (libraryObjects.count <= 0) {
        return;
    }
    
    bool fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!fileExists) {
        [[NSFileManager defaultManager] createFileAtPath:filePath
                                                contents:nil
                                              attributes:nil];
    }
    
    NSOutputStream *outStream = [[NSOutputStream alloc] initToFileAtPath:filePath
                                                                  append:NO];
    
    csvWriter = [[CHCSVWriter alloc] initWithOutputStream:outStream
                                                 encoding:NSUTF8StringEncoding
                                                delimiter:','];
    
    // Write header line
    LibraryObject *representativeLibraryObject = [libraryObjects firstObject];
    NSArray *headers;

    // Identify which type of LibraryObject we are exporting.
    if ([representativeLibraryObject isKindOfClass:[Sample class]]) {
        headers = [SampleConstants attributeNames];
    } else if ([representativeLibraryObject isKindOfClass:[Source class]]) {
        headers = [SourceConstants attributeNames];
    } else {
        headers = [representativeLibraryObject.attributes allKeys];
    }

    // Create a set for for error checking.
    NSSet *headerSet = [NSSet setWithArray:headers];
    
    [csvWriter writeLineOfFields:headers];
    
    // Now write all objects
    for (LibraryObject *libraryObject in libraryObjects) {
        if (![headerSet isEqualToSet:[NSSet setWithArray:libraryObject.attributes.allKeys]]) {
            DDLogWarn(@"Attributes for object with key %@ did not match header!", libraryObject.key);
        }

        NSMutableArray *orderedAttributeValues = [[NSMutableArray alloc] initWithCapacity:headers.count];
        for (NSString *header in headers) {
            NSString *value = [libraryObject.attributes objectForKey:header];
            [orderedAttributeValues addObject:value];
        }
        [csvWriter writeLineOfFields:orderedAttributeValues];
    }
}

/// MIME representatation for CSV files (text/csv)
+(NSString *)fileFormat {
    return @"text/csv";
}

@end
