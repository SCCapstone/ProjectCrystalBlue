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
static NSString *const KEY = @"key";
static NSString *const CONTINENT = @"continent";
static NSString *const TYPE = @"type";
static NSString *const LITHOLOGY = @"lithology";
static NSString *const DEPOSYSTEM = @"deposystem";
static NSString *const GROUP = @"group";
static NSString *const FORMATION = @"formation";
static NSString *const MEMBER = @"member";
static NSString *const REGION = @"region";
static NSString *const LOCALITY = @"locality";
static NSString *const SECTION = @"section";
static NSString *const METER_LEVEL = @"meterLevel";
static NSString *const LATITUDE = @"latitude";
static NSString *const LONGITUDE = @"longitude";
static NSString *const AGE = @"age";
static NSString *const AGE_BASIS1 = @"ageBasis1";
static NSString *const AGE_BASIS2 = @"ageBasis2";
static NSString *const DATE_COLLECTED = @"dateCollected";
static NSString *const PROJECT = @"project";
static NSString *const SUBPROJECT = @"subproject";

/* Attribute default values
 */
static NSString *const DEF_VAL_KEY = @"key here";
static NSString *const DEF_VAL_CONTINENT = @"continent here";
static NSString *const DEF_VAL_TYPE = @"Type here";
static NSString *const DEF_VAL_LITHOLOGY = @"Lithology here";
static NSString *const DEF_VAL_DEPOSYSTEM = @"Deposystem here";
static NSString *const DEF_VAL_GROUP = @"Group here";
static NSString *const DEF_VAL_FORMATION = @"Formation here";
static NSString *const DEF_VAL_MEMBER = @"Member here";
static NSString *const DEF_VAL_REGION = @"Region here";
static NSString *const DEF_VAL_LOCALITY = @"Locality here";
static NSString *const DEF_VAL_SECTION = @"Section here";
static NSString *const DEF_VAL_METER_LEVEL = @"Meter_Level here";
static NSString *const DEF_VAL_LATITUDE = @"Latitude here";
static NSString *const DEF_VAL_LONGITUDE = @"Longitude here";
static NSString *const DEF_VAL_AGE = @"Age here";
static NSString *const DEF_VAL_AGE_BASIS1 = @"Age_Basis1 here";
static NSString *const DEF_VAL_AGE_BASIS2 = @"Age_Basis2 here";
static NSString *const DEF_VAL_DATE_COLLECTED = @"Date_Collected here";
static NSString *const DEF_VAL_PROJECT = @"Project here";
static NSString *const DEF_VAL_SUBPROJECT = @"Subproject here";

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

+ (NSString *)sourceTableName
{
    return SOURCE_TABLE_NAME;
}

@end
