//
//  ProcedureFieldValidator.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/29/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProcedureFieldValidator.h"
#import "PrimitiveFieldValidator.h"
#import "PCBLogWrapper.h"

@implementation ProcedureFieldValidator

/// Validates that initials are between 1-10 characters, and contain only alphanumeric characters
/// and spaces.
+(ValidationResponse *)validateInitials:(NSString *)initials
{
    const NSUInteger maxLength = 10;
    const NSUInteger minLength = 1;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:initials
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              initials.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:initials
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              initials.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];

    if (![PrimitiveFieldValidator validateField:initials
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters and numbers"];
        [valid.errors addObject:errorStr];
    }
    
    return valid;
}

@end
