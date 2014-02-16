//
//  ProcedureTagDecoder.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProcedureTagDecoder.h"
#import "ProcedureNameConstants.h"

@implementation ProcedureTagDecoder

+(NSArray *)nameArrayFromTags:(NSString *)tags
{
    NSArray *tagTokens = [self.class tagArrayFromCommaSeparatedTagString:tags];
    
    return [self.class nameArrayFromTagArray:tagTokens];
}

+(NSArray *)tagArrayFromCommaSeparatedTagString:(NSString *)tags
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:tags];
    NSMutableArray *tagTokens = [[NSMutableArray alloc] init];
    while (![scanner isAtEnd]) {
        NSString *currentToken;
        [scanner scanUpToString:TAG_DELIMITER intoString:&currentToken];
        [tagTokens addObject:currentToken];
        // Skip over delimiter
        [scanner scanString:TAG_DELIMITER intoString:nil];
    }
    
    return tagTokens;
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
