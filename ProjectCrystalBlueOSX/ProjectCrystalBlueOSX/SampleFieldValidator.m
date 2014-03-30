//
//  SampleFieldValidator.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleFieldValidator.h"
#import "SourceFieldValidator.h"
#import "PrimitiveFieldValidator.h"
#import "ValidationResponse.h"
#import "SampleConstants.h"
#import "SourceConstants.h"

@implementation SampleFieldValidator

+ (ValidationResponse *)validateSampleKey:(NSString *)key
                            WithDataStore:(AbstractLibraryObjectStore *)dataStore
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 1;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];
    
    if (![PrimitiveFieldValidator validateKey:key
                          isUniqueInDataStore:dataStore
                                      inTable:[SampleConstants tableName]])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:@"%@ is not a unique sample key.", key];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:key
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              key.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:key
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              key.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet punctuationCharacterSet]];

    if (![PrimitiveFieldValidator validateField:key
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, punctuation, and spaces"];
        [valid.errors addObject:errorStr];
    }

    return valid;
}

+ (ValidationResponse *)validateOriginalSourceKey:(NSString *)sourceKey
                                    WithDataStore:(AbstractLibraryObjectStore *)dataStore
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 1;
    
    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];
    
    if ([PrimitiveFieldValidator validateKey:sourceKey
                        isUniqueInDataStore:dataStore
                                    inTable:[SourceConstants tableName]])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:@"This sample's source key %@ does not exist in the database.", sourceKey];
        [valid.errors addObject:errorStr];
    }
    
    if (![PrimitiveFieldValidator validateField:sourceKey
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              sourceKey.length];
        [valid.errors addObject:errorStr];
    }
    
    if (![PrimitiveFieldValidator validateField:sourceKey
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              sourceKey.length];
        [valid.errors addObject:errorStr];
    }
    
    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];
    
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![PrimitiveFieldValidator validateField:sourceKey
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    
    return valid;
}

+ (ValidationResponse *)validateCurrentLocation:(NSString *)currentLocationValue
{
    const NSUInteger maxLength = 90;
    const NSUInteger minlength = 0;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:currentLocationValue
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                                                         maxLength,
                                                         currentLocationValue.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:currentLocationValue
                             isAtLeastMinLength:minlength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                                                         minlength,
                                                         currentLocationValue.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet punctuationCharacterSet]];

    if (![PrimitiveFieldValidator validateField:currentLocationValue
                                  containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, spaces, and punctuation"];
        [valid.errors addObject:errorStr];
    }

    return valid;
}

@end
