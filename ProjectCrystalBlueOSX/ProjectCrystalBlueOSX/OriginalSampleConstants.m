//
//  OriginalSampleConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "OriginalSampleConstants.h"

/* Attribute names
 */
NSString *const CONTINENT = @"Continent";

/* Attribute default values
 */
NSString *const DEF_VAL_CONTINENT = @"continent here";

@implementation OriginalSampleConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          CONTINENT,
                          nil];
    }
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                          DEF_VAL_CONTINENT,
                          nil];
    }
    return attributeDefaultValues;
}

@end
