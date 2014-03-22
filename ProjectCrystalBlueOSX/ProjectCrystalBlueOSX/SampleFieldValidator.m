//
//  SampleFieldValidator.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleFieldValidator.h"
#import "PrimitiveFieldValidator.h"

@implementation SampleFieldValidator

+ (BOOL)validateCurrentLocation:(NSString *)currentLocationValue
{
    const NSUInteger maxLength = 90;
    const NSUInteger minlength = 1;

    BOOL valid = !(nil == currentLocationValue);

    valid = valid && [PrimitiveFieldValidator validateField:currentLocationValue
                                      isNoMoreThanMaxLength:maxLength];

    valid = valid && [PrimitiveFieldValidator validateField:currentLocationValue
                                         isAtLeastMinLength:minlength];

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet punctuationCharacterSet]];

    valid = valid && [PrimitiveFieldValidator validateField:currentLocationValue
                                        containsOnlyCharSet:validCharacters];

    return valid;
}

@end
