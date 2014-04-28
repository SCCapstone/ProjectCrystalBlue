//
//  SplitConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SplitConstants.h"
#import "PCBLogWrapper.h"

/* Split table name
 */
#ifdef DEBUG
static NSString *const SPLIT_TABLE_NAME = @"test_split_table";
#else
static NSString *const SPLIT_TABLE_NAME = @"prod_split_table";
#endif

@implementation SplitConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          SPL_KEY,
                          SPL_SAMPLE_KEY,
                          SPL_CURRENT_LOCATION,
                          SPL_TAGS, nil];
    }
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  SPL_DEF_VAL_KEY,
                                  SPL_DEF_VAL_SAMPLE_KEY,
                                  SPL_DEF_VAL_CURRENT_LOCATION,
                                  SPL_DEF_VAL_TAGS, nil];
    }
    return attributeDefaultValues;
}

/// Array of human-readable labels for each attribute
+ (NSArray *)humanReadableLabels
{
    static NSArray *humanReadableLabels = nil;
    if (!humanReadableLabels)
    {
        humanReadableLabels = [NSArray arrayWithObjects:
                                  SPL_DISPLAY_KEY,
                                  SPL_DISPLAY_SAMPLE_KEY,
                                  SPL_DISPLAY_CURRENT_LOCATION,
                                  SPL_DISPLAY_TAGS, nil];
    }
    return humanReadableLabels;
}

/// Return the human-readable label corresponding to an attribute name
+ (NSString *)humanReadableLabelForAttribute:(NSString *)attributeName
{
    NSUInteger index = [[self.class attributeNames] indexOfObject:attributeName];
    if (index == NSNotFound) {
        DDLogWarn(@"%@: %@ attribute is unknown.", NSStringFromClass(self.class), attributeName);
        return attributeName;
    }

    return [[self.class humanReadableLabels] objectAtIndex:index];
}

+ (NSString *)attributeNameForHumanReadableLabel:(NSString *)label
{
    NSUInteger index = [[self.class humanReadableLabels] indexOfObject:label];
    if (index == NSNotFound) {
        DDLogWarn(@"%@: %@ attribute is unknown.", NSStringFromClass(self.class), label);
        return label;
    }
    
    return [[self.class attributeNames] objectAtIndex:index];
}

+ (NSString *)tableName
{
    return SPLIT_TABLE_NAME;
}

+ (NSString *)tableSchema
{
    static NSString *schema = nil;
    if (!schema)
    {
        NSMutableArray *attrNames = [[self attributeNames] mutableCopy];
        
        // Append column info to each attribute name
        for (int i=0; i<[attrNames count];  i++)
        {
            NSString *attr = [attrNames objectAtIndex:i];
            [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@ TEXT%@",
                                                          attr, [attr isEqualToString:SPL_KEY] ? @" PRIMARY KEY" : @""]];
        }
        schema = [attrNames componentsJoinedByString:@","];
    }
    return schema;
}

+ (NSString *)tableColumns
{
    static NSString *columns = nil;
    if (!columns)
    {
        columns = [[self attributeNames] componentsJoinedByString:@","];
    }
    return columns;
}

+ (NSString *)tableValueKeys
{
    static NSString *valueKeys = nil;
    if (!valueKeys)
    {
        NSMutableArray *attrNames = [[self attributeNames] mutableCopy];
        
        // Prepend ':' to each attribute name
        for (int i=0; i<[attrNames count];  i++)
        {
            [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@":%@", [attrNames objectAtIndex:i]]];
        }
        valueKeys = [attrNames componentsJoinedByString:@","];
    }
    return valueKeys;
}

@end
