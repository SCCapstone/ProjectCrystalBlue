//
//  PrimitiveProcedures.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "PrimitiveProcedures.h"
#import "ProcedureNameConstants.h"
#import "Split.h"
#import "Sample.h"
#import "ProcedureRecord.h"
#import "PCBLogWrapper.h"

@implementation PrimitiveProcedures

+(void)cloneSplit:(Split *)original
         intoStore:(AbstractLibraryObjectStore *)store
    intoTableNamed:(NSString *)tableName
{
    DDLogInfo(@"%@: cloning split with key %@", NSStringFromClass(self.class), original.key);
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:original.attributes];
    NSString *key = [self.class uniqueKeyBasedOn:original.key
                                         inStore:store
                                         inTable:tableName];
    [newAttributes setObject:key forKey:SPL_KEY];
    Split *newSplit = [[Split alloc] initWithKey:key AndWithAttributeDictionary:newAttributes];
    
    [store putLibraryObject:newSplit IntoTable:tableName];
}

+(void)cloneSplitWithClearedTags:(Split *)original
                        intoStore:(AbstractLibraryObjectStore *)store
                   intoTableNamed:(NSString *)tableName
{
    DDLogInfo(@"%@: creating a fresh (no tags) from split with key %@", NSStringFromClass(self.class), original.key);
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:original.attributes];
    NSString *key = [self.class uniqueKeyBasedOn:original.key
                                         inStore:store
                                         inTable:tableName];
    [newAttributes setObject:key forKey:SPL_KEY];
    [newAttributes setObject:@"" forKey:SPL_TAGS];
    [newAttributes setObject:@"" forKey:SPL_LAST_PROC];
    Split *newSplit = [[Split alloc] initWithKey:key AndWithAttributeDictionary:newAttributes];
    
    [store putLibraryObject:newSplit IntoTable:tableName];
    
    Sample *sample = (Sample *)[store getLibraryObjectForKey:[newSplit sampleKey] FromTable:[SampleConstants tableName]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *count = [formatter numberFromString:[sample.attributes objectForKey:SMP_NUM_SPLITS]];
    count = [NSNumber numberWithInt:[count intValue] + 1];
    [sample.attributes setObject:count.stringValue forKey:SMP_NUM_SPLITS];
    [store updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSampleData"
                                                        object:self];
}

+(void)appendToSplitInPlace:(Split *)modifiedSplit
                   tagString:(NSString *)tag
                withInitials:(NSString *)initials
                   intoStore:(AbstractLibraryObjectStore *)store
              intoTableNamed:(NSString *)tableName
{
    DDLogInfo(@"%@: IN-PLACE Appending tag %@ to split with key %@", NSStringFromClass(self.class), tag, modifiedSplit.key);
    
    NSString *oldTagList = [[modifiedSplit attributes] objectForKey:SPL_TAGS];
    ProcedureRecord *newProcedureRecord = [[ProcedureRecord alloc] initWithTag:tag
                                                                   andInitials:initials];
    
    NSString *newTagList = [self.class appendTagToString:oldTagList
                                               tagString:[newProcedureRecord description]];
    
    [[modifiedSplit attributes] setObject:newTagList forKey:SPL_TAGS];
    [[modifiedSplit attributes] setObject:[self lastProcedureFromProcedureRecord:newProcedureRecord] forKey:SPL_LAST_PROC];
    [store updateLibraryObject:modifiedSplit IntoTable:tableName];
}

+(void)appendToCloneOfSplit:(Split *)original
                   tagString:(NSString *)tag
                withInitials:(NSString *)initials
                   intoStore:(AbstractLibraryObjectStore *)store
              intoTableNamed:(NSString *)tableName
{
    DDLogInfo(@"%@: cloning split with key %@ and adding tag %@", NSStringFromClass(self.class), original.key, tag);
    
    NSString *oldTagList = [[original attributes] objectForKey:SPL_TAGS];
    ProcedureRecord *newProcedureRecord = [[ProcedureRecord alloc] initWithTag:tag
                                                                   andInitials:initials];
    
    NSString *newTagList = [self.class appendTagToString:oldTagList
                                               tagString:[newProcedureRecord description]];
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:original.attributes];
    NSString *key = [self.class uniqueKeyBasedOn:original.key
                                         inStore:store
                                         inTable:tableName];
    [newAttributes setObject:key forKey:SPL_KEY];
    [newAttributes setObject:newTagList forKey:SPL_TAGS];
    [newAttributes setObject:[self lastProcedureFromProcedureRecord:newProcedureRecord] forKey:SPL_LAST_PROC];
    Split *newSplit = [[Split alloc] initWithKey:key AndWithAttributeDictionary:newAttributes];
    
    [store putLibraryObject:newSplit IntoTable:tableName];
    
    Sample *sample = (Sample *)[store getLibraryObjectForKey:[newSplit sampleKey] FromTable:[SampleConstants tableName]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *count = [formatter numberFromString:[sample.attributes objectForKey:SMP_NUM_SPLITS]];
    count = [NSNumber numberWithInt:[count intValue] + 1];
    [sample.attributes setObject:count.stringValue forKey:SMP_NUM_SPLITS];
    [store updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSampleData"
                                                        object:self];
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
 *  Helper method to generate a new unique key for a split. This key is guaranteed to be unique within the given table.
 *  Recall that splits are generally named something like 'SUPER_AWESOME_SPLIT.001'. This method would generate the key
 *  'SUPER_AWESOME_SPLIT.002' and, assuming no other split exists with that name, return it. If 'SUPER_AWESOME_SPLIT.002'
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
        if (![store libraryObjectExistsForKey:newKey FromTable:tableName]) {
            DDLogInfo(@"%@: Created new key %@ from key %@", NSStringFromClass(self.class), newKey, previousKey);
            return newKey;
        } else {
            DDLogDebug(@"%@: A split with key %@ already exists...", NSStringFromClass(self.class), newKey);
        }
    }
    
    // If we exhaust all 1000 possible splits, this is a problem.
    // Just so that we have something to return, we'll just append part of a UUID to the split.
    // This is ugly, but hopefully will be a clear indication to the user that our app does not scale to their needs.
    DDLogError(@"%@: There are at least 999 splits with the prefix %@. This application is really not meant to handle that many sub-splits from a single sample.", NSStringFromClass(self.class), strippedString);
    
    NSString *randomCharacters = [[[[NSUUID alloc] init] UUIDString] substringToIndex:4];
    
    return [strippedString stringByAppendingFormat:@"%@.%3d", randomCharacters, 1];
}

+ (NSString *)lastProcedureFromProcedureRecord:(ProcedureRecord *)procedureRecord
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    NSString *procedureName = [ProcedureNameConstants procedureNameForTag:procedureRecord.tag];
    NSString *date = [formatter stringFromDate:procedureRecord.date];
    return [NSString stringWithFormat:@"%@ on %@ by %@", procedureName, date, procedureRecord.initials];
}

@end
