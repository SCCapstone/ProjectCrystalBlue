//
//  SplitFieldValidator.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SplitFieldValidator.h"
#import "SampleFieldValidator.h"
#import "PrimitiveFieldValidator.h"
#import "ValidationResponse.h"
#import "SplitConstants.h"
#import "SampleConstants.h"
#import "PCBLogWrapper.h"

@implementation SplitFieldValidator

+ (ValidationResponse *)validateSplitKey:(NSString *)key
                            WithDataStore:(AbstractLibraryObjectStore *)dataStore
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 1;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];
    
    if (![PrimitiveFieldValidator validateKey:key
                          isUniqueInDataStore:dataStore
                                      inTable:[SplitConstants tableName]])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:@"%@ is not a unique split key.", key];
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
    [validCharacters removeCharactersInString:@"'"];

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

+ (ValidationResponse *)validateOriginalSampleKey:(NSString *)sampleKey
                                    WithDataStore:(AbstractLibraryObjectStore *)dataStore
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 1;
    
    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];
    
    if ([PrimitiveFieldValidator validateKey:sampleKey
                        isUniqueInDataStore:dataStore
                                    inTable:[SampleConstants tableName]])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:@"This split's sample key %@ does not exist in the database.", sampleKey];
        [valid.errors addObject:errorStr];
    }
    
    if (![PrimitiveFieldValidator validateField:sampleKey
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              sampleKey.length];
        [valid.errors addObject:errorStr];
    }
    
    if (![PrimitiveFieldValidator validateField:sampleKey
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              sampleKey.length];
        [valid.errors addObject:errorStr];
    }
    
    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];
    
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet punctuationCharacterSet]];
    [validCharacters removeCharactersInString:@"'"];
    
    if (![PrimitiveFieldValidator validateField:sampleKey
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
    [validCharacters removeCharactersInString:@"'"];

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
