//
//  LibraryObject.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObject.h"

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
        attributes = [[NSMutableDictionary alloc] initWithObjects:attributeDefaultValues
                                                   forKeys:attributeNames];
    }
    return self;
}

@end
