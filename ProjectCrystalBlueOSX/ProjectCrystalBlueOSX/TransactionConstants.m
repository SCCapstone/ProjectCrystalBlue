//
//  TransactionConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/11/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "TransactionConstants.h"
#import "PCBLogWrapper.h"

/* Transaction table name
 */
#ifdef DEBUG
static NSString *const TRANSACTION_TABLE_NAME = @"test_transaction_table";
#else
static NSString *const TRANSACTION_TABLE_NAME = @"prod_transaction_table";
#endif

@implementation TransactionConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          TRN_TIMESTAMP, TRN_LIBRARY_OBJECT_KEY, TRN_LIBRARY_OBJECT_TABLE, TRN_SQL_COMMAND_TYPE, nil];
    }
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  TRN_DEF_VAL_TIMESTAMP, TRN_DEF_VAL_LIBRARY_OBJECT_KEY, TRN_DEF_VAL_LIBRARY_OBJECT_TABLE, TRN_DEF_VAL_SQL_COMMAND_TYPE, nil];
    }
    return attributeDefaultValues;
}

+ (NSString *)tableName
{
    return TRANSACTION_TABLE_NAME;
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
            if ([attr isEqualToString:TRN_TIMESTAMP])
                [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@ REAL PRIMARY KEY", TRN_TIMESTAMP]];
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
