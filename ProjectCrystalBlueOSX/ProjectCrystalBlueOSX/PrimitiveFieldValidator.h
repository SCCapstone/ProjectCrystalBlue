//
//  FieldValidator.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AbstractLibraryObjectStore;

/// Various validation functions to use for validating string values in fields. These are primitive
/// operations that can generically be used for any sort of string - for validating specific fields,
/// these operations can be combined.
@interface PrimitiveFieldValidator : NSObject

/// Verify that this field contains only characters from the provided character set.
+ (BOOL)validateField:(const NSString *)field
  containsOnlyCharSet:(const NSCharacterSet *)charSet;

/// Verify that the field's length is greater than or equal to minLength.
+ (BOOL)validateField:(const NSString *)field
   isAtLeastMinLength:(const NSUInteger)minLength;

/// Verify that the field's length is less than or equal to maxLength.
+ (BOOL)validateField:(const NSString *)field
isNoMoreThanMaxLength:(const NSUInteger)maxLength;

/// Verify that a key (for a LibraryObject) is unique within a provided data store.
+ (BOOL)validateKey:(const NSString *)key
isUniqueInDataStore:(const AbstractLibraryObjectStore *)store
            inTable:(const NSString *)tableName;

@end
