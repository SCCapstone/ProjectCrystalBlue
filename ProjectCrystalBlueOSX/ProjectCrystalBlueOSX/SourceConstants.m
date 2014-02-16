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
                          SRC_KEY,
                          SRC_CONTINENT,
                          SRC_TYPE,
                          SRC_LITHOLOGY,
                          SRC_DEPOSYSTEM,
                          SRC_GROUP,
                          SRC_FORMATION,
                          SRC_MEMBER,
                          SRC_REGION,
                          SRC_LOCALITY,
                          SRC_SECTION,
                          SRC_METER_LEVEL,
                          SRC_LATITUDE,
                          SRC_LONGITUDE,
                          SRC_AGE,
                          SRC_AGE_BASIS1,
                          SRC_AGE_BASIS2,
                          SRC_DATE_COLLECTED,
                          SRC_PROJECT,
                          SRC_SUBPROJECT, nil];
    }
    
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  SRC_DEF_VAL_KEY,
                                  SRC_DEF_VAL_CONTINENT,
                                  SRC_DEF_VAL_TYPE,
                                  SRC_DEF_VAL_LITHOLOGY,
                                  SRC_DEF_VAL_DEPOSYSTEM,
                                  SRC_DEF_VAL_GROUP,
                                  SRC_DEF_VAL_FORMATION,
                                  SRC_DEF_VAL_MEMBER,
                                  SRC_DEF_VAL_REGION,
                                  SRC_DEF_VAL_LOCALITY,
                                  SRC_DEF_VAL_SECTION,
                                  SRC_DEF_VAL_METER_LEVEL,
                                  SRC_DEF_VAL_LATITUDE,
                                  SRC_DEF_VAL_LONGITUDE,
                                  SRC_DEF_VAL_AGE,
                                  SRC_DEF_VAL_AGE_BASIS1,
                                  SRC_DEF_VAL_AGE_BASIS2,
                                  SRC_DEF_VAL_DATE_COLLECTED,
                                  SRC_DEF_VAL_PROJECT,
                                  SRC_DEF_VAL_SUBPROJECT, nil];
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
            [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@ TEXT%@",
                                                          attr, [attr isEqualToString:@"key"] ? @" PRIMARY KEY" : @""]];
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
