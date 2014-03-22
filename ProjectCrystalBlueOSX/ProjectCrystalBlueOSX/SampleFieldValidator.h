//
//  SampleFieldValidator.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleFieldValidator : NSObject

/// Verify that a CurrentLocation value contains only alphanumeric, punctuation, and whitespace
/// characters, and its length is between 1 and 90 characters.
+ (BOOL)validateCurrentLocation:(NSString *)currentLocationValue;

@end
