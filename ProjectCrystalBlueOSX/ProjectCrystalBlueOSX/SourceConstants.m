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

/* Attribute names
 */
NSString *const KEY = @"key";
NSString *const CONTINENT = @"continent";
NSString *const TYPE = @"type";
NSString *const LITHOLOGY = @"lithology";
NSString *const DEPOSYSTEM = @"deposystem";
NSString *const GROUP = @"group";
NSString *const FORMATION = @"formation";
NSString *const MEMBER = @"member";
NSString *const REGION = @"region";
NSString *const LOCALITY = @"locality";
NSString *const SECTION = @"section";
NSString *const METER_LEVEL = @"meterLevel";
NSString *const LATITUDE = @"latitude";
NSString *const LONGITUDE = @"longitude";
NSString *const AGE = @"age";
NSString *const AGE_BASIS1 = @"ageBasis1";
NSString *const AGE_BASIS2 = @"ageBasis2";
NSString *const DATE_COLLECTED = @"dateCollected";
NSString *const PROJECT = @"project";
NSString *const SUBPROJECT = @"subproject";

/* Attribute default values
 */
NSString *const DEF_VAL_KEY = @"key here";
NSString *const DEF_VAL_CONTINENT = @"continent here";
NSString *const DEF_VAL_TYPE = @"Type here";
NSString *const DEF_VAL_LITHOLOGY = @"Lithology here";
NSString *const DEF_VAL_DEPOSYSTEM = @"Deposystem here";
NSString *const DEF_VAL_GROUP = @"Group here";
NSString *const DEF_VAL_FORMATION = @"Formation here";
NSString *const DEF_VAL_MEMBER = @"Member here";
NSString *const DEF_VAL_REGION = @"Region here";
NSString *const DEF_VAL_LOCALITY = @"Locality here";
NSString *const DEF_VAL_SECTION = @"Section here";
NSString *const DEF_VAL_METER_LEVEL = @"Meter_Level here";
NSString *const DEF_VAL_LATITUDE = @"Latitude here";
NSString *const DEF_VAL_LONGITUDE = @"Longitude here";
NSString *const DEF_VAL_AGE = @"Age here";
NSString *const DEF_VAL_AGE_BASIS1 = @"Age_Basis1 here";
NSString *const DEF_VAL_AGE_BASIS2 = @"Age_Basis2 here";
NSString *const DEF_VAL_DATE_COLLECTED = @"Date_Collected here";
NSString *const DEF_VAL_PROJECT = @"Project here";
NSString *const DEF_VAL_SUBPROJECT = @"Subproject here";

/* Source table name
 */
NSString *const SOURCE_TABLE_NAME = @"test_source_table";

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

+ (NSString *)sourceTableName
{
    return SOURCE_TABLE_NAME;
}

@end
