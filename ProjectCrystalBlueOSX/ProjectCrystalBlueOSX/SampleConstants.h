//
//  SampleConstants.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Attribute names
 */
static NSString *const SMP_KEY              = @"KEY";
static NSString *const SMP_CONTINENT        = @"CONTINENT";
static NSString *const SMP_TYPE             = @"ROCK_TYPE";
static NSString *const SMP_LITHOLOGY        = @"LITHOLOGY";
static NSString *const SMP_DEPOSYSTEM       = @"DEPOSYSTEM";
static NSString *const SMP_GROUP            = @"ROCK_GROUP";
static NSString *const SMP_FORMATION        = @"FORMATION";
static NSString *const SMP_MEMBER           = @"MEMBER";
static NSString *const SMP_REGION           = @"REGION";
static NSString *const SMP_LOCALITY         = @"LOCALITY";
static NSString *const SMP_SECTION          = @"SECTION";
static NSString *const SMP_METER            = @"METER";
static NSString *const SMP_LATITUDE         = @"LATITUDE";
static NSString *const SMP_LONGITUDE        = @"LONGITUDE";
static NSString *const SMP_AGE              = @"AGE";
static NSString *const SMP_AGE_METHOD       = @"AGE_METHOD";
static NSString *const SMP_AGE_DATATYPE     = @"AGE_DATA_TYPE";
static NSString *const SMP_DATE_COLLECTED   = @"DATE_COLLECTED";
static NSString *const SMP_COLLECTED_BY     = @"COLLECTED_BY";
static NSString *const SMP_NUM_SPLITS       = @"NUM_SPLITS";
static NSString *const SMP_NOTES            = @"NOTES";
static NSString *const SMP_HYPERLINKS       = @"HYPERLINKS";
static NSString *const SMP_IMAGES           = @"IMAGES";

/* Attribute default values
 */
static NSString *const SMP_DEF_VAL_KEY          = @"Key here";
static NSString *const SMP_DEF_VAL_CONTINENT    = @"Continent here";
static NSString *const SMP_DEF_VAL_TYPE         = @"Rock type here";
static NSString *const SMP_DEF_VAL_LITHOLOGY    = @"Lithology here";
static NSString *const SMP_DEF_VAL_DEPOSYSTEM   = @"Deposystem here";
static NSString *const SMP_DEF_VAL_GROUP        = @"Group here";
static NSString *const SMP_DEF_VAL_FORMATION    = @"Formation here";
static NSString *const SMP_DEF_VAL_MEMBER       = @"Member here";
static NSString *const SMP_DEF_VAL_REGION       = @"Region here";
static NSString *const SMP_DEF_VAL_LOCALITY     = @"Locality here";
static NSString *const SMP_DEF_VAL_SECTION      = @"Section here";
static NSString *const SMP_DEF_VAL_METER        = @"0.00";
static NSString *const SMP_DEF_VAL_LATITUDE     = @"0.00";
static NSString *const SMP_DEF_VAL_LONGITUDE    = @"0.00";
static NSString *const SMP_DEF_VAL_AGE          = @"0.00";
static NSString *const SMP_DEF_VAL_AGE_METHOD   = @"Age method here";
static NSString *const SMP_DEF_VAL_AGE_DATATYPE = @"Age data type here";
static NSString *const SMP_DEF_VAL_DATE_COLLECTED = @"01/01/1970, 12:01 AM";
static NSString *const SMP_DEF_VAL_COLLECTED_BY = @"Collected by here";
static NSString *const SMP_DEF_VAL_NUM_SPLITS   = @"0";
static NSString *const SMP_DEF_VAL_NOTES        = @"";
static NSString *const SMP_DEF_VAL_HYPERLINKS   = @"http://www.geol.sc.edu";
 /* default value for "Images" should be empty string, since this will be a list of image names */
static NSString *const SMP_DEF_VAL_IMAGES       = @"";

/*  Human-readable attribute names
 */
static NSString *const SMP_DISPLAY_KEY          = @"Sample";
static NSString *const SMP_DISPLAY_CONTINENT    = @"Continent";
static NSString *const SMP_DISPLAY_TYPE         = @"Rock Type";
static NSString *const SMP_DISPLAY_LITHOLOGY    = @"Lithology";
static NSString *const SMP_DISPLAY_DEPOSYSTEM   = @"Deposystem";
static NSString *const SMP_DISPLAY_GROUP        = @"Group";
static NSString *const SMP_DISPLAY_FORMATION    = @"Formation";
static NSString *const SMP_DISPLAY_MEMBER       = @"Member";
static NSString *const SMP_DISPLAY_REGION       = @"Region";
static NSString *const SMP_DISPLAY_LOCALITY     = @"Locality";
static NSString *const SMP_DISPLAY_SECTION      = @"Section";
static NSString *const SMP_DISPLAY_METER        = @"Meter";
static NSString *const SMP_DISPLAY_LATITUDE     = @"Latitude";
static NSString *const SMP_DISPLAY_LONGITUDE    = @"Longitude";
static NSString *const SMP_DISPLAY_AGE          = @"Age";
static NSString *const SMP_DISPLAY_AGE_METHOD   = @"Age Method";
static NSString *const SMP_DISPLAY_AGE_DATATYPE = @"Age Data Type";
static NSString *const SMP_DISPLAY_DATE_COLLECTED = @"Date Collected";
static NSString *const SMP_DISPLAY_COLLECTED_BY = @"Collected By";
static NSString *const SMP_DISPLAY_NUM_SPLITS   = @"Number of Splits";
static NSString *const SMP_DISPLAY_NOTES        = @"Notes";
static NSString *const SMP_DISPLAY_HYPERLINKS   = @"Hyperlinks";
static NSString *const SMP_DISPLAY_IMAGES       = @"Images";

@interface SampleConstants : NSObject

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

/// Returns the name of the local and remote table name for Sample
+ (NSString *)tableName;

/// Returns the string representation of the table schema
+ (NSString *)tableSchema;

/// Returns a comma separated list of attribute names
+ (NSString *)tableColumns;

/// Returns a comma separated list of attribute names prepended with ':', used
/// with local database to cleanly store database attributes
+ (NSString *)tableValueKeys;

+ (NSArray *)rockTypes;
+ (NSArray *)lithologiesForRockType:(NSString *)rockType;
+ (NSArray *)deposystemsForRockType:(NSString *)rockType;
+ (NSArray *)ageMethods;

@end
