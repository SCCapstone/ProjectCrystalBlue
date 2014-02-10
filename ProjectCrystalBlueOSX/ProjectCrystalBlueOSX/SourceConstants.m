//
//  SourceConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceConstants.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/* Source table name
 */
static NSString *const SOURCE_TABLE_NAME = @"test_source_table";

@implementation SourceConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          KEY, CONTINENT, TYPE, LITHOLOGY, DEPOSYSTEM, GROUP, FORMATION, MEMBER, REGION, LOCALITY, SECTION, METER_LEVEL, LATITUDE, LONGITUDE, AGE, AGE_BASIS1, AGE_BASIS2, DATE_COLLECTED, PROJECT, SUBPROJECT, nil];
    }
    
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  DEF_VAL_KEY, DEF_VAL_CONTINENT, DEF_VAL_TYPE, DEF_VAL_LITHOLOGY, DEF_VAL_DEPOSYSTEM, DEF_VAL_GROUP, DEF_VAL_FORMATION, DEF_VAL_MEMBER, DEF_VAL_REGION, DEF_VAL_LOCALITY, DEF_VAL_SECTION, DEF_VAL_METER_LEVEL, DEF_VAL_LATITUDE, DEF_VAL_LONGITUDE, DEF_VAL_AGE, DEF_VAL_AGE_BASIS1, DEF_VAL_AGE_BASIS2, DEF_VAL_DATE_COLLECTED, DEF_VAL_PROJECT, DEF_VAL_SUBPROJECT, nil];
    }
    return attributeDefaultValues;
}

+ (NSString *)tableName
{
    return SOURCE_TABLE_NAME;
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
            [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@ TEXT%@", attr, [attr isEqualToString:@"key"] ? @" PRIMARY KEY" : @""]];
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
