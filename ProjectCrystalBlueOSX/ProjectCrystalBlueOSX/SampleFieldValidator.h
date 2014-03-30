//
//  SampleFieldValidator.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationResponse.h"

@class AbstractLibraryObjectStore;

@interface SampleFieldValidator : NSObject

/// Verify that a SampleKey value contains only alphanumeric, punctuation, and whitespace
/// characters, its length is between 1 and 90 characters, and it is a unique key.
+ (ValidationResponse *)validateSampleKey:(NSString *)key
                            WithDataStore:(AbstractLibraryObjectStore *)dataStore;

/// Verify that a CurrentLocation value contains only alphanumeric, punctuation, and whitespace
/// characters, and its length is between 1 and 90 characters.
+ (ValidationResponse *)validateCurrentLocation:(NSString *)currentLocationValue;

/// Verify that the OriginalSourceKey field fits the requirements of a SourceKey, and the source
/// key already exists in the database.
+ (ValidationResponse *)validateOriginalSourceKey:(NSString *)sourceKey
                                    WithDataStore:(AbstractLibraryObjectStore *)dataStore;

@end
