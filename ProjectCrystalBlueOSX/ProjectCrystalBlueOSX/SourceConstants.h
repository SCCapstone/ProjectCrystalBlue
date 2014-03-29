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
static NSString *const SRC_KEY              = @"KEY";
static NSString *const SRC_CONTINENT        = @"CONTINENT";
static NSString *const SRC_TYPE             = @"ROCK_TYPE";
static NSString *const SRC_LITHOLOGY        = @"LITHOLOGY";
static NSString *const SRC_DEPOSYSTEM       = @"DEPOSYSTEM";
static NSString *const SRC_GROUP            = @"ROCK_GROUP";
static NSString *const SRC_FORMATION        = @"FORMATION";
static NSString *const SRC_MEMBER           = @"MEMBER";
static NSString *const SRC_REGION           = @"REGION";
static NSString *const SRC_LOCALITY         = @"LOCALITY";
static NSString *const SRC_SECTION          = @"SECTION";
static NSString *const SRC_METER            = @"METER";
static NSString *const SRC_LATITUDE         = @"LATITUDE";
static NSString *const SRC_LONGITUDE        = @"LONGITUDE";
static NSString *const SRC_AGE              = @"AGE";
static NSString *const SRC_AGE_METHOD       = @"AGE_METHOD";
static NSString *const SRC_AGE_DATATYPE     = @"AGE_DATA_TYPE";
static NSString *const SRC_DATE_COLLECTED   = @"DATE_COLLECTED";
static NSString *const SRC_NOTES            = @"NOTES";
static NSString *const SRC_HYPERLINKS       = @"HYPERLINKS";
static NSString *const SRC_IMAGES           = @"IMAGES";

/* Attribute default values
 */
static NSString *const SRC_DEF_VAL_KEY          = @"Key here";
static NSString *const SRC_DEF_VAL_CONTINENT    = @"Continent here";
static NSString *const SRC_DEF_VAL_TYPE         = @"Rock type here";
static NSString *const SRC_DEF_VAL_LITHOLOGY    = @"Lithology here";
static NSString *const SRC_DEF_VAL_DEPOSYSTEM   = @"Deposystem here";
static NSString *const SRC_DEF_VAL_GROUP        = @"Group here";
static NSString *const SRC_DEF_VAL_FORMATION    = @"Formation here";
static NSString *const SRC_DEF_VAL_MEMBER       = @"Member here";
static NSString *const SRC_DEF_VAL_REGION       = @"Region here";
static NSString *const SRC_DEF_VAL_LOCALITY     = @"Locality here";
static NSString *const SRC_DEF_VAL_SECTION      = @"Section here";
static NSString *const SRC_DEF_VAL_METER        = @"Meter here";
static NSString *const SRC_DEF_VAL_LATITUDE     = @"0";
static NSString *const SRC_DEF_VAL_LONGITUDE    = @"0";
static NSString *const SRC_DEF_VAL_AGE          = @"Age here";
static NSString *const SRC_DEF_VAL_AGE_METHOD   = @"Age method here";
static NSString *const SRC_DEF_VAL_AGE_DATATYPE = @"Age data type here";
static NSString *const SRC_DEF_VAL_DATE_COLLECTED = @"Date collected here";
static NSString *const SRC_DEF_VAL_NOTES        = @"Notes here";
static NSString *const SRC_DEF_VAL_HYPERLINKS   = @"Hyperlinks here";
 /* default value for "Images" should be empty string, since this will be a list of image names */
static NSString *const SRC_DEF_VAL_IMAGES       = @"";

/*  Human-readable attribute names
 */
static NSString *const SRC_DISPLAY_KEY          = @"Key";
static NSString *const SRC_DISPLAY_CONTINENT    = @"Continent";
static NSString *const SRC_DISPLAY_TYPE         = @"Rock Type";
static NSString *const SRC_DISPLAY_LITHOLOGY    = @"Lithology";
static NSString *const SRC_DISPLAY_DEPOSYSTEM   = @"Deposystem";
static NSString *const SRC_DISPLAY_GROUP        = @"Group";
static NSString *const SRC_DISPLAY_FORMATION    = @"Formation";
static NSString *const SRC_DISPLAY_MEMBER       = @"Member";
static NSString *const SRC_DISPLAY_REGION       = @"Region";
static NSString *const SRC_DISPLAY_LOCALITY     = @"Locality";
static NSString *const SRC_DISPLAY_SECTION      = @"Section";
static NSString *const SRC_DISPLAY_METER        = @"Meter";
static NSString *const SRC_DISPLAY_LATITUDE     = @"Latitude";
static NSString *const SRC_DISPLAY_LONGITUDE    = @"Longitude";
static NSString *const SRC_DISPLAY_AGE          = @"Age";
static NSString *const SRC_DISPLAY_AGE_METHOD   = @"Age Method";
static NSString *const SRC_DISPLAY_AGE_DATATYPE = @"Age Data Type";
static NSString *const SRC_DISPLAY_DATE_COLLECTED = @"Date Collected";
static NSString *const SRC_DISPLAY_NOTES        = @"Notes";
static NSString *const SRC_DISPLAY_HYPERLINKS   = @"Hyperlinks";
static NSString *const SRC_DISPLAY_IMAGES       = @"Images";

@interface SourceConstants : NSObject

/// Array of all attributes stored in the database
+ (NSArray *)attributeNames;

/// Array of default values for each attribute
+ (NSArray *)attributeDefaultValues;

/// Array of human-readable labels for each attribute
+ (NSArray *)humanReadableLabels;

/// Return the human-readable label corresponding to an attribute name
+ (NSString *)humanReadableLabelForAttribute:(NSString *)attributeName;

/// Returns the attribute name corresponding to a human-readable label
+ (NSString *)attributeNameForHumanReadableLabel:(NSString *)label;

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
