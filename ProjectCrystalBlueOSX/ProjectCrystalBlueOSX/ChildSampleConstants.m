//
//  ChildSampleConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "ChildSampleConstants.h"

/* Attribute names
 */
NSString *const CURRENT_LOCATION = @"CurrentLocation";

/* Attribute default values
 */
NSString *const DEF_VAL_CURRENT_LOCATION = @"USC";

@implementation ChildSampleConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          CURRENT_LOCATION,
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
                                  DEF_VAL_CURRENT_LOCATION,
                                  nil];
    }
    return attributeDefaultValues;
}

@end
