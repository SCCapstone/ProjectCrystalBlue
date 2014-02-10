//
//  SourceConstants.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Attribute names
 */
static NSString *const KEY = @"key";
static NSString *const CONTINENT = @"continent";
static NSString *const TYPE = @"type";
static NSString *const LITHOLOGY = @"lithology";
static NSString *const DEPOSYSTEM = @"deposystem";
static NSString *const GROUP = @"rockGroup";
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

@interface SourceConstants : NSObject

/// Array of all attributes stored in the database
+ (NSArray *)attributeNames;

/// Array of default values for each attribute
+ (NSArray *)attributeDefaultValues;

/// Returns the name of the local and remote table name for Source
+ (NSString *)tableName;

/// Returns the string representation of the table schema
+ (NSString *)tableSchema;

/// Returns a comma separated list of attribute names
+ (NSString *)tableColumns;

/// Returns a comma separated list of attribute names prepended with ':', used
/// with local database to cleanly store database attributes
+ (NSString *)tableValueKeys;

@end
