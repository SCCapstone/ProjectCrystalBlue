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
static NSString *const SRC_KEY              = @"key";
static NSString *const SRC_CONTINENT        = @"continent";
static NSString *const SRC_TYPE             = @"type";
static NSString *const SRC_LITHOLOGY        = @"lithology";
static NSString *const SRC_DEPOSYSTEM       = @"deposystem";
static NSString *const SRC_GROUP            = @"rockGroup";
static NSString *const SRC_FORMATION        = @"formation";
static NSString *const SRC_MEMBER           = @"member";
static NSString *const SRC_REGION           = @"region";
static NSString *const SRC_LOCALITY         = @"locality";
static NSString *const SRC_SECTION          = @"section";
static NSString *const SRC_METER_LEVEL      = @"meterLevel";
static NSString *const SRC_LATITUDE         = @"latitude";
static NSString *const SRC_LONGITUDE        = @"longitude";
static NSString *const SRC_AGE              = @"age";
static NSString *const SRC_AGE_BASIS1       = @"ageBasis1";
static NSString *const SRC_AGE_BASIS2       = @"ageBasis2";
static NSString *const SRC_DATE_COLLECTED   = @"dateCollected";
static NSString *const SRC_PROJECT          = @"project";
static NSString *const SRC_SUBPROJECT       = @"subproject";

/* Attribute default values
 */
static NSString *const SRC_DEF_VAL_KEY          = @"key here";
static NSString *const SRC_DEF_VAL_CONTINENT    = @"continent here";
static NSString *const SRC_DEF_VAL_TYPE         = @"Type here";
static NSString *const SRC_DEF_VAL_LITHOLOGY    = @"Lithology here";
static NSString *const SRC_DEF_VAL_DEPOSYSTEM   = @"Deposystem here";
static NSString *const SRC_DEF_VAL_GROUP        = @"Group here";
static NSString *const SRC_DEF_VAL_FORMATION    = @"Formation here";
static NSString *const SRC_DEF_VAL_MEMBER       = @"Member here";
static NSString *const SRC_DEF_VAL_REGION       = @"Region here";
static NSString *const SRC_DEF_VAL_LOCALITY     = @"Locality here";
static NSString *const SRC_DEF_VAL_SECTION      = @"Section here";
static NSString *const SRC_DEF_VAL_METER_LEVEL  = @"Meter_Level here";
static NSString *const SRC_DEF_VAL_LATITUDE     = @"Latitude here";
static NSString *const SRC_DEF_VAL_LONGITUDE    = @"Longitude here";
static NSString *const SRC_DEF_VAL_AGE          = @"Age here";
static NSString *const SRC_DEF_VAL_AGE_BASIS1   = @"Age_Basis1 here";
static NSString *const SRC_DEF_VAL_AGE_BASIS2   = @"Age_Basis2 here";
static NSString *const SRC_DEF_VAL_DATE_COLLECTED = @"Date_Collected here";
static NSString *const SRC_DEF_VAL_PROJECT      = @"Project here";
static NSString *const SRC_DEF_VAL_SUBPROJECT   = @"Subproject here";

/*  Human-readable attribute names
 */
static NSString *const SRC_DISPLAY_KEY          = @"Key";
static NSString *const SRC_DISPLAY_CONTINENT    = @"Continent";
static NSString *const SRC_DISPLAY_TYPE         = @"Type";
static NSString *const SRC_DISPLAY_LITHOLOGY    = @"Lithology";
static NSString *const SRC_DISPLAY_DEPOSYSTEM   = @"Deposystem";
static NSString *const SRC_DISPLAY_GROUP        = @"Group";
static NSString *const SRC_DISPLAY_FORMATION    = @"Formation";
static NSString *const SRC_DISPLAY_MEMBER       = @"Member";
static NSString *const SRC_DISPLAY_REGION       = @"Region";
static NSString *const SRC_DISPLAY_LOCALITY     = @"Locality";
static NSString *const SRC_DISPLAY_SECTION      = @"Section";
static NSString *const SRC_DISPLAY_METER_LEVEL  = @"Meter level";
static NSString *const SRC_DISPLAY_LATITUDE     = @"Latitude";
static NSString *const SRC_DISPLAY_LONGITUDE    = @"Longitude";
static NSString *const SRC_DISPLAY_AGE          = @"Age";
static NSString *const SRC_DISPLAY_AGE_BASIS1   = @"Age Basis 1";
static NSString *const SRC_DISPLAY_AGE_BASIS2   = @"Age Basis 2";
static NSString *const SRC_DISPLAY_DATE_COLLECTED = @"Date Collected";
static NSString *const SRC_DISPLAY_PROJECT      = @"Project";
static NSString *const SRC_DISPLAY_SUBPROJECT   = @"Subproject";

@interface SourceConstants : NSObject

/// Array of all attributes stored in the database
+ (NSArray *)attributeNames;

/// Array of default values for each attribute
+ (NSArray *)attributeDefaultValues;

/// Array of human-readable labels for each attribute
+ (NSArray *)humanReadableLabels;

/// Return the human-readable label corresponding to an attribute name
+ (NSString *)humanReadableLabelForAttribute:(NSString *)attributeName;

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
