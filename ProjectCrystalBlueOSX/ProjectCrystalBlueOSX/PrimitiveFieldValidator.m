//
//  FieldValidator.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "PrimitiveFieldValidator.h"
#import "AbstractLibraryObjectStore.h"
#import "PCBLogWrapper.h"

@implementation PrimitiveFieldValidator

/// Verify that this field contains only characters from the provided character set.
+ (BOOL)validateField:(const NSString *)field
  containsOnlyCharSet:(const NSCharacterSet *)charSet
{
    if (nil == field) {
        return NO;
    }

    NSCharacterSet *fieldCharSet = [NSCharacterSet characterSetWithCharactersInString:[field copy]];

    return ([charSet isSupersetOfSet:fieldCharSet]);
}

+ (BOOL)validateFieldIsDecimal:(const NSString *)field
{
    NSScanner *scanner = [NSScanner scannerWithString:[field copy]];
    double d;
    BOOL parsedAsDouble = [scanner scanDouble:&d];
    BOOL parsedEntireStr = [scanner isAtEnd];

    return parsedAsDouble && parsedEntireStr;
}

+ (BOOL)validateFieldIsIntegral:(const NSString *)field
{
    NSScanner *scanner = [NSScanner scannerWithString:[field copy]];
    long long l;
    BOOL parsedAsLongLong = [scanner scanLongLong:&l];

    return parsedAsLongLong;
}

/// Verify that the field's length is greater than or equal to minLength.
+ (BOOL)validateField:(const NSString *)field
   isAtLeastMinLength:(const NSUInteger)minLength
{
    if (nil == field) {
        return NO;
    }
    return (field.length >= minLength);
}

/// Verify that the field's length is less than or equal to maxLength.
+ (BOOL)validateField:(const NSString *)field
isNoMoreThanMaxLength:(const NSUInteger)maxLength
{
    if (nil == field) {
        return NO;
    }
    return (field.length <= maxLength);
}

/// Verify that a field is contained in a list of valid values.
+ (BOOL)validateField:(const NSString *)field
   isOneOfValidValues:(const NSArray *)listOfValidValues
{
    if (nil == field || [listOfValidValues count] <= 0) {
        return NO;
    }

    return ([listOfValidValues containsObject:field]);
}

/// Verify that a key (for a LibraryObject) is unique within a provided data store.
+ (BOOL)validateKey:(const NSString *)key
isUniqueInDataStore:(const AbstractLibraryObjectStore *)store
            inTable:(const NSString *)tableName
{
    if (nil == key || nil == store) {
        return NO;
    }
    BOOL keyExists = [store libraryObjectExistsForKey:[key copy]
                                            FromTable:[tableName copy]];
    return !keyExists;
}

@end
