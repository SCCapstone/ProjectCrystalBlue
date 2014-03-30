//
//  ImagesFieldValidator.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/29/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ImagesFieldValidator.h"
#import "PrimitiveFieldValidator.h"

@implementation ImagesFieldValidator

+(ValidationResponse *)validateImageTag:(NSString *)imageTag
{
    const NSUInteger maxLength = 30;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:imageTag
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              imageTag.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];

    if (![PrimitiveFieldValidator validateField:imageTag
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
