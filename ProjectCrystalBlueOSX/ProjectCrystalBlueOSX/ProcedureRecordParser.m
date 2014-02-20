//
//  ProcedureTagDecoder.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProcedureRecordParser.h"
#import "ProcedureNameConstants.h"
#import "ProcedureRecord.h"

@implementation ProcedureRecordParser

+(NSArray *)nameArrayFromRecordList:(NSString *)recordList
{
    NSArray *tags = [self.class tagArrayFromRecordList:recordList];
    
    return [self.class nameArrayFromTagArray:tags];
}

+(NSArray *)procedureRecordArrayFromList:(NSString *)recordList
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:recordList];
    NSMutableArray *parsedRecords = [[NSMutableArray alloc] init];
    while (![scanner isAtEnd]) {
        NSString *currentToken;
        [scanner scanUpToString:TAG_DELIMITER intoString:&currentToken];
        ProcedureRecord *currentRecord = [[ProcedureRecord alloc] initFromString:currentToken];
        [parsedRecords addObject:currentRecord];
        // Skip over delimiter
        [scanner scanString:TAG_DELIMITER intoString:nil];
    }
    
    return parsedRecords;
}

+(NSString *)mostRecentProcedurePerformedOnSample:(Sample *)sample
{
    NSString *records = [sample.attributes objectForKey:SMP_TAGS];
    NSArray *tagList = [self.class tagArrayFromRecordList:records];
    if (tagList.count > 0) {
        return [ProcedureNameConstants procedureNameForTag:[tagList lastObject]];
    } else {
        return @"None";
    }
}

+(NSArray *)tagArrayFromRecordList:(NSString *)records
{
    NSArray *parsedRecords = [self.class procedureRecordArrayFromList:records];
    
    NSMutableArray *tags = [[NSMutableArray alloc] initWithCapacity:parsedRecords.count];
    for (ProcedureRecord *record in parsedRecords) {
        [tags addObject:record.tag];
    }
    
    return tags;
}

+(NSArray *)nameArrayFromTagArray:(NSArray *)tags
{
    NSMutableArray *userReadableNames = [[NSMutableArray alloc] initWithCapacity:tags.count];
    for (NSString *tag in tags) {
        [userReadableNames addObject:[ProcedureNameConstants procedureNameForTag:tag]];
    }
    return userReadableNames;
}

@end
