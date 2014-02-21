//
//  TransactionConstants.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/11/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Attribute names
 */
static NSString *const TRN_TIMESTAMP = @"timestamp";
static NSString *const TRN_LIBRARY_OBJECT_KEY = @"libraryObjectKey";
static NSString *const TRN_LIBRARY_OBJECT_TABLE = @"tableName";
static NSString *const TRN_SQL_COMMAND_TYPE = @"sqlCommandType";

/* Attribute default values
 */
static NSString *const TRN_DEF_VAL_TIMESTAMP = @"unique timestamp";
static NSString *const TRN_DEF_VAL_LIBRARY_OBJECT_KEY = @"library object key here";
static NSString *const TRN_DEF_VAL_LIBRARY_OBJECT_TABLE = @"tableName here";
static NSString *const TRN_DEF_VAL_SQL_COMMAND_TYPE = @"PUT,UPDATE,DELETE here";

@interface TransactionConstants : NSObject

/// Array of all attributes stored in the database
+ (NSArray *)attributeNames;

/// Array of default values for each attribute
+ (NSArray *)attributeDefaultValues;

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
