//
//  SplitConstants.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Attribute names
 */
static NSString *const SPL_KEY = @"KEY";
static NSString *const SPL_SAMPLE_KEY = @"SAMPLE_KEY";
static NSString *const SPL_CURRENT_LOCATION = @"CURRENT_LOCATION";
static NSString *const SPL_TAGS = @"TAGS";

/* Attribute default values
 */
static NSString *const SPL_DEF_VAL_KEY = @"key here";
static NSString *const SPL_DEF_VAL_SAMPLE_KEY = @"sampleKey here";
static NSString *const SPL_DEF_VAL_CURRENT_LOCATION = @"USC";

// default tags is intentionally empty string, since a fresh split has had no procedures performed on it.
static NSString *const SPL_DEF_VAL_TAGS = @"";

/*  Human readable attribute labels
 */
static NSString *const SPL_DISPLAY_KEY = @"Split Key";
static NSString *const SPL_DISPLAY_SAMPLE_KEY = @"Original Sample";
static NSString *const SPL_DISPLAY_CURRENT_LOCATION = @"Current Location";
static NSString *const SPL_DISPLAY_TAGS = @"Procedure Log";

@interface SplitConstants : NSObject

/// Array of all attributes stored in the database
+ (NSArray *)attributeNames;

/// Array of default values for each attribute
+ (NSArray *)attributeDefaultValues;

/// Array of human-readable labels for each attribute
+ (NSArray *)humanReadableLabels;

/// Returns the human-readable label corresponding to an attribute name
+ (NSString *)humanReadableLabelForAttribute:(NSString *)attributeName;

/// Returns the attribute name corresponding to a human-readable label
+ (NSString *)attributeNameForHumanReadableLabel:(NSString *)label;

/// Returns the name of the local and remote table name for Split
+ (NSString *)tableName;

/// Returns the string representation of the table schema
+ (NSString *)tableSchema;

/// Returns a comma separated list of attribute names
+ (NSString *)tableColumns;

/// Returns a comma separated list of attribute names prepended with ':', used
/// with local database to cleanly store database attributes
+ (NSString *)tableValueKeys;

@end
