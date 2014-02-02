//
//  LibraryObject.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObject.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LibraryObject

@synthesize key;
@synthesize attributes;

- (id)initWithKey:(NSString *)aKey
AndWithAttributes:(NSArray *)attributeNames
AndWithDefaultValues:(NSArray *)attributeDefaultValues
{
    self = [super init];
    if (self)
    {
        if ([attributeNames count] != [attributeDefaultValues count])
            [NSException raise:@"Invalid attribute constants."
                        format:@"attributeNames is of length %lu and attributeDefaultValues is of length %lu", (unsigned long)[attributeNames count], (unsigned long)[attributeDefaultValues count]];
        key = aKey;
        attributes = [[NSDictionary alloc] initWithObjects:attributeDefaultValues
                                                   forKeys:attributeNames];
    }
    return self;
}

@end
