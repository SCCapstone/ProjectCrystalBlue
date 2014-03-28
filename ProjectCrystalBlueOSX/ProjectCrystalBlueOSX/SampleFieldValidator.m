//
//  SampleFieldValidator.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleFieldValidator.h"
#import "PrimitiveFieldValidator.h"
#import "ValidationResponse.h"

@implementation SampleFieldValidator

+ (ValidationResponse *)validateCurrentLocation:(NSString *)currentLocationValue
{
    const NSUInteger maxLength = 90;
    const NSUInteger minlength = 1;

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
