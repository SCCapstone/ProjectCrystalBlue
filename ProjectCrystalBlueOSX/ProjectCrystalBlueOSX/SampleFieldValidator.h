//
//  SampleFieldValidator.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationResponse.h"

@interface SampleFieldValidator : NSObject

/// Verify that a SampleKey value contains only alphanumeric, punctuation, and whitespace
/// characters, and its length is between 1 and 90 characters.
+ (ValidationResponse *)validateSampleKey:(NSString *)key;

/// Verify that a CurrentLocation value contains only alphanumeric, punctuation, and whitespace
/// characters, and its length is between 1 and 90 characters.
+ (ValidationResponse *)validateCurrentLocation:(NSString *)currentLocationValue;

/// Verify that the OriginalSourceKey field fits the requirements of a SourceKey, as defined in
/// SourceFieldValidator.
+ (ValidationResponse *)validateOriginalSourceKey:(NSString *)sourceKey;

@end
