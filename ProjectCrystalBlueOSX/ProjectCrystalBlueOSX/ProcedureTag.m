//
//  ProcedureTag.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProcedureTag.h"
#define INTERNAL_DELIMITER @"|"

@implementation ProcedureTag

@synthesize tag = tag;
@synthesize initials = initials;
@synthesize date = date;

- (id)init
{
    [NSException raise:@"Wrong init" format:@"Use initWithTagAndInitials"];
    return nil;
}

-(id)initFromString:(NSString *)stringRepresentation
{
    NSScanner *parser = [[NSScanner alloc] initWithString:stringRepresentation];
    
    // Skip the opening brace.
    [parser scanString:@"{" intoString:nil];
    
    NSString *parsedTag = @"";
    NSString *parsedInitials = @"";
    NSString *parsedDateString = @"";
    
    [parser scanUpToString:INTERNAL_DELIMITER intoString:&parsedTag];
    [parser scanString:INTERNAL_DELIMITER intoString:nil];
    [parser scanUpToString:INTERNAL_DELIMITER intoString:&parsedInitials];
    [parser scanString:INTERNAL_DELIMITER intoString:nil];
    [parser scanUpToString:@"}" intoString:&parsedDateString];
    
    NSDate *parsedDate = [[NSDate alloc] initWithString:parsedDateString];
    return [self initWithTag:parsedTag
                 andInitials:parsedInitials
                     andDate:parsedDate];
}

-(id)initWithTag:(NSString *)aTag
     andInitials:(NSString *)aInitials
{
    NSDate *now = [[NSDate alloc] init];
    return [self initWithTag:aTag andInitials:aInitials andDate:now];
}

-(id)initWithTag:(NSString *)aTag
     andInitials:(NSString *)aInitials
         andDate:(NSDate *)aDate
{
    self = [super init];
    if (self) {
        tag = aTag;
        initials = aInitials;
        date = aDate;
    }
    return self;
}

-(NSString *)description
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateAsString = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"{%@%@%@%@%@}",
            tag, INTERNAL_DELIMITER, initials, INTERNAL_DELIMITER, dateAsString];
}

-(BOOL)isEqual:(id)object
{
    if (nil == object) {
        return NO;
    }
    
    if (![object isKindOfClass:[ProcedureTag class]]) {
        return NO;
    }
    
    ProcedureTag *other = (ProcedureTag *)object;
    
    return ([self.tag isEqualToString:other.tag] && [self.initials isEqualToString:other.initials]);
}

- (NSUInteger)hash
{
    NSUInteger hash = 1;
    hash += [self.tag hash];
    hash = hash * 37 + [self.initials hash];
    
    return hash;
}

@end
