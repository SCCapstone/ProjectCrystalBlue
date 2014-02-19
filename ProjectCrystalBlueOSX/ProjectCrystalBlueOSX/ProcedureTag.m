//
//  ProcedureTag.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProcedureTag.h"

@implementation ProcedureTag

@synthesize tag = tag;
@synthesize initials = initials;
@synthesize date = date;

- (id)init
{
    [NSException raise:@"Wrong init" format:@"Use initWithTagAndInitials"];
    return nil;
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
    return [NSString stringWithFormat:@"{%@|%@|%@}", tag, initials, dateAsString];
}

@end
