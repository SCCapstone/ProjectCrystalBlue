//
//  PrimitiveProcedures.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "PrimitiveProcedures.h"
#import "DDLog.h"
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define TAG_DELIMITER @", "

#define KEY @"key"
#define TAGS @"tags"

@implementation PrimitiveProcedures

+(void)cloneSample:(Sample *)original
         intoStore:(AbstractLibraryObjectStore *)store
    intoTableNamed:(NSString *)tableName
{
    DDLogInfo(@"%@: cloning sample with key %@", NSStringFromClass(self.class), original.key);
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:original.attributes];
    NSString *key = [self.class uniqueKeyBasedOn:original.key
                                         inStore:store
                                         inTable:tableName];
    [newAttributes setObject:key forKey:KEY];
    Sample *newSample = [[Sample alloc] initWithKey:key AndWithAttributeDictionary:newAttributes];
    
    [store putLibraryObject:newSample IntoTable:tableName];
}

+(void)cloneSampleWithClearedTags:(Sample *)original
                        intoStore:(AbstractLibraryObjectStore *)store
                   intoTableNamed:(NSString *)tableName
{
    DDLogInfo(@"%@: creating a fresh (no tags) from sample with key %@", NSStringFromClass(self.class), original.key);
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:original.attributes];
    NSString *key = [self.class uniqueKeyBasedOn:original.key
                                         inStore:store
                                         inTable:tableName];
    [newAttributes setObject:key forKey:KEY];
    [newAttributes setObject:@"" forKey:TAGS];
    Sample *newSample = [[Sample alloc] initWithKey:key AndWithAttributeDictionary:newAttributes];
    
    [store putLibraryObject:newSample IntoTable:tableName];
}

+(void)appendToSampleInPlace:(Sample *)modifiedSample
                   tagString:(NSString *)tag
                   intoStore:(AbstractLibraryObjectStore *)store
              intoTableNamed:(NSString *)tableName
{
    DDLogInfo(@"%@: IN-PLACE Appending tag %@ to sample with key %@", NSStringFromClass(self.class), tag, modifiedSample.key);
    
    NSString *oldTags = [[modifiedSample attributes] objectForKey:TAGS];
    NSString *newTags = [self.class appendTagToString:oldTags tagString:tag];
    [[modifiedSample attributes] setObject:newTags forKey:TAGS];
    [store updateLibraryObject:modifiedSample IntoTable:tableName];
}

+(void)appendToCloneOfSample:(Sample *)original
                   tagString:(NSString *)tag
                   intoStore:(AbstractLibraryObjectStore *)store
              intoTableNamed:(NSString *)tableName
{
    DDLogInfo(@"%@: cloning sample with key %@ and adding tag %@", NSStringFromClass(self.class), original.key, tag);
    
    NSString *oldTags = [[original attributes] objectForKey:TAGS];
    NSString *newTags = [self.class appendTagToString:oldTags tagString:tag];
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:original.attributes];
    NSString *key = [self.class uniqueKeyBasedOn:original.key
                                         inStore:store
                                         inTable:tableName];
    [newAttributes setObject:key forKey:KEY];
    [newAttributes setObject:newTags forKey:TAGS];
    Sample *newSample = [[Sample alloc] initWithKey:key AndWithAttributeDictionary:newAttributes];
    
    [store putLibraryObject:newSample IntoTable:tableName];
}

/**
 *  Helper method to append a tag to a string, with a delimiter.
 */
+(NSString *)appendTagToString:(NSString *)string
                     tagString:(NSString *)tag
{
    NSString *newTag;
    if ([string isEqualToString:@""]) {
        // No delimiter is needed if the string is already empty.
        newTag = tag;
    } else {
        newTag = [NSString stringWithFormat:@"%@%@%@", string, TAG_DELIMITER, tag];
    }
    DDLogInfo(@"%@: %s %@ + %@ = %@", NSStringFromClass(self.class), __func__, string, tag, newTag);
    return newTag;
}

/**
 *  Helper method to generate a new unique key for a sample. This key is guaranteed to be unique within the given table.
 *  Recall that samples are generally named something like 'SUPER_AWESOME_SAMPLE.001'. This method would generate the key
 *  'SUPER_AWESOME_SAMPLE.002' and, assuming no other sample exists with that name, return it. If 'SUPER_AWESOME_SAMPLE.002'
 *  already exists, then we try '*.003' '*.004' etc. until we find an open name.
 */
+(NSString *)uniqueKeyBasedOn:(NSString *)previousKey
                      inStore:(AbstractLibraryObjectStore *)store
                      inTable:(NSString *)tableName
{
    NSScanner *scanner = [NSScanner scannerWithString:previousKey];
    
    NSString *strippedString;
    NSString *previousNumberAsString;
    int previousNumber = -1;
    
    [scanner scanUpToString:@"." intoString:&strippedString];
    
    [scanner scanCharactersFromSet:[NSCharacterSet punctuationCharacterSet]
                        intoString:NULL];
    
    [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet]
                        intoString:&previousNumberAsString];
    
    previousNumber = [previousNumberAsString intValue];
    
    for (int newNumber = previousNumber + 1; newNumber < 1000; ++newNumber) {
        NSString *newKey = [strippedString stringByAppendingFormat:@".%03d", newNumber];
        if ([store libraryObjectExistsForKey:newKey FromTable:tableName]) {
            DDLogInfo(@"%@: Created new key %@ from key %@", NSStringFromClass(self.class), newKey, previousKey);
            return newKey;
        } else {
            DDLogDebug(@"%@: A sample with key %@ already exists...", NSStringFromClass(self.class), newKey);
        }
    }
    
    // If we exhaust all 1000 possible samples, this is a problem.
    // Just so that we have something to return, we'll just append part of a UUID to the sample.
    // This is ugly, but hopefully will be a clear indication to the user that our app does not scale to their needs.
    DDLogError(@"%@: There are at least 999 samples with the prefix %@. This application is really not meant to handle that many sub-samples from a single source.", NSStringFromClass(self.class), strippedString);
    
    NSString *randomCharacters = [[[[NSUUID alloc] init] UUIDString] substringToIndex:4];
    
    return [strippedString stringByAppendingFormat:@"%@.%3d", randomCharacters, 1];
}

@end
