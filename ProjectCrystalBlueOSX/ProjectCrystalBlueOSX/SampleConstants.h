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
static NSString *const SMP_KEY = @"key";
static NSString *const SMP_SOURCE_KEY = @"sourceKey";
static NSString *const SMP_CURRENT_LOCATION = @"currentLocation";
static NSString *const SMP_TAGS = @"tags";

/* Attribute default values
 */
static NSString *const SMP_DEF_VAL_KEY = @"key here";
static NSString *const SMP_DEF_VAL_SOURCE_KEY = @"sourceKey here";
static NSString *const SMP_DEF_VAL_CURRENT_LOCATION = @"USC";

// default tags is intentionally empty string, since a fresh sample has had no procedures performed on it.
static NSString *const SMP_DEF_VAL_TAGS = @"";

/*  Human readable attribute labels
 */
static NSString *const SMP_DISPLAY_KEY = @"Sample Key";
static NSString *const SMP_DISPLAY_SOURCE_KEY = @"Original Source";
static NSString *const SMP_DISPLAY_CURRENT_LOCATION = @"Current Location";
static NSString *const SMP_DISPLAY_TAGS = @"Procedure Log";

@interface SampleConstants : NSObject

/// Array of all attributes stored in the database
+ (NSArray *)attributeNames;

/// Array of default values for each attribute
+ (NSArray *)attributeDefaultValues;

/// Array of human-readable labels for each attribute
+ (NSArray *)humanReadableLabels;

/// Return the human-readable label corresponding to an attribute name
+ (NSString *)humanReadableLabelForAttribute:(NSString *)attributeName;

/// Returns the name of the local and remote table name for Sample
+ (NSString *)tableName;

/// Returns the string representation of the table schema
+ (NSString *)tableSchema;

/// Returns a comma separated list of attribute names
+ (NSString *)tableColumns;

/// Returns a comma separated list of attribute names prepended with ':', used
/// with local database to cleanly store database attributes
+ (NSString *)tableValueKeys;

@end
