//
//  OriginalSample.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "OriginalSample.h"

@implementation OriginalSample

@synthesize key;
@synthesize attributes;

- (id)initWithAttributes:(NSArray *)attributeNames
    AndWithDefaultValues:(NSArray *)attributeDefaultValues
{
    self = [super init];
    if (self)
    {
        NSArray *attributeNames = [OriginalSampleConstants attributeNames];
        NSArray *attributeDefaultValues = [OriginalSampleConstants attributeDefaultValues];
        if ([attributeNames count] != [attributeDefaultValues count])
            [NSException raise:@"Invalid attribute constants."
                        format:@"attributeNames is of length %lu and attributeDefaultValues is of length %lu", [attributeNames count], [attributeDefaultValues count]];
        for (NSUInteger i=0; i<[attributeNames count]; i++)
        {
            [attributes setValue:[attributeDefaultValues objectAtIndex:i] forKey:[attributeNames objectAtIndex:i]];
        }
    }
    return self;
}

@end
