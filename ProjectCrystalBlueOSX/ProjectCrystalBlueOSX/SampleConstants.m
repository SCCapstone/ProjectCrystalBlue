//
//  SampleConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleConstants.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/* Sample table name
 */
#ifdef DEBUG
static NSString *const SAMPLE_TABLE_NAME = @"test_sample_table";
#else
static NSString *const SAMPLE_TABLE_NAME = @"prod_sample_table";
#endif

@implementation SampleConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          SMP_KEY,
                          SMP_SOURCE_KEY,
                          SMP_CURRENT_LOCATION,
                          SMP_TAGS, nil];
    }
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  SMP_DEF_VAL_KEY,
                                  SMP_DEF_VAL_SOURCE_KEY,
                                  SMP_DEF_VAL_CURRENT_LOCATION,
                                  SMP_DEF_VAL_TAGS, nil];
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
                                  SMP_DISPLAY_KEY,
                                  SMP_DISPLAY_SOURCE_KEY,
                                  SMP_DISPLAY_CURRENT_LOCATION,
                                  SMP_DISPLAY_TAGS, nil];
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

    NSString *label = [[self.class humanReadableLabels] objectAtIndex:index];
    return label;
}

+ (NSString *)tableName
{
    return SAMPLE_TABLE_NAME;
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
                                                          attr, [attr isEqualToString:SMP_KEY] ? @" PRIMARY KEY" : @""]];
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
