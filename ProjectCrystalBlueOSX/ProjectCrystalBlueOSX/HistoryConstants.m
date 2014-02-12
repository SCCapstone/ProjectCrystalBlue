//
//  HistoryConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/11/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "HistoryConstants.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/* Attribute names
 */
static NSString *const TIMESTAMP = @"timestamp";
static NSString *const LIBRARY_OBJECT_KEY = @"libraryObjectKey";
static NSString *const SQL_COMMAND_TYPE = @"sqlCommandType";

/* Attribute default values
 */
static NSString *const DEF_VAL_TIMESTAMP = @"unique timestamp";
static NSString *const DEF_VAL_LIBRARY_OBJECT_KEY = @"library object key here";
static NSString *const DEF_VAL_SQL_COMMAND_TYPE = @"PUT,UPDATE,DELETE here";

/* Sample table name
 */
static NSString *const HISTORY_TABLE_NAME = @"test_history_table";

@implementation HistoryConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          TIMESTAMP, LIBRARY_OBJECT_KEY, SQL_COMMAND_TYPE, nil];
    }
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  DEF_VAL_TIMESTAMP, DEF_VAL_LIBRARY_OBJECT_KEY, DEF_VAL_SQL_COMMAND_TYPE, nil];
    }
    return attributeDefaultValues;
}

+ (NSString *)tableName
{
    return HISTORY_TABLE_NAME;
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
            if ([attr isEqualToString:@"timestamp"])
                [attrNames replaceObjectAtIndex:i withObject:@"timestamp INTEGER PRIMARY KEY"];
            else
                [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@ TEXT", attr]];
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
