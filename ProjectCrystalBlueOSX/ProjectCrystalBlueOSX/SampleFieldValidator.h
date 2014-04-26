//
//  SampleFieldValidator.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationResponse.h"

@class AbstractLibraryObjectStore;

@interface SampleFieldValidator : NSObject

/// Validates that a sample key is between 1 and 90 characters, contains alphanumeric
/// characters and whitespace only, and it is a unique key
+(ValidationResponse *)validateSampleKey:(NSString *)key
                           WithDataStore:(AbstractLibraryObjectStore *)dataStore;

/// Validates that a continent is between 1 and 90 characters, and contains letters and spaces
/// only.
+(ValidationResponse *)validateContinent:(NSString *)continent;

/// Validates that type is an expected value.
+(ValidationResponse *)validateType:(NSString *)type;

// Validates that lithology is an expected value.
+(ValidationResponse *)validateLithology:(NSString *)lithology;

/// Validates that deposystem is an expected value.
+(ValidationResponse *)validateDeposystem:(NSString *)deposystem;

/// Validates that group is an expected value.
+(ValidationResponse *)validateGroup:(NSString *)group;

/// Validates that a formation is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateFormation:(NSString *)formation;

/// Validates that a member is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateMember:(NSString *)member;

/// Validates that a region is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateRegion:(NSString *)region;

/// Validates that a locality is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateLocality:(NSString *)locality;

/// Validates that a section is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateSection:(NSString *)section;

/// Validates that meters is a properly formatted decimal number.
+(ValidationResponse *)validateMeters:(NSString *)meters;

/// Validates that latitude is a properly formatted decimal number.
+(ValidationResponse *)validateLatitude:(NSString *)latitude;

/// Validates that longitude is a properly formatted decimal number.
+(ValidationResponse *)validateLongitude:(NSString *)longitude;

/// Validates that age is a properly formatted decimal number.
+(ValidationResponse *)validateAge:(NSString *)age;

/// Validates that ageMethod is an expected value.
+(ValidationResponse *)validateAgeMethod:(NSString *)ageMethod;

/// Validates that ageDataType is an expected value.
+(ValidationResponse *)validateAgeDatatype:(NSString *)ageDatatype;

/// Validates that dateCollected is an integral numerical value (UNIX TIME)
+(ValidationResponse *)validateDateCollected:(NSString *)dateCollected;

/// Validates that collected by is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateCollectedBy:(NSString *)collectedBy;

/// Validates that Notes is between 0 and 2000 characters.
+(ValidationResponse *)validateNotes:(NSString *)notes;

/// Validates that hyperlinks is between 0 and 2000 characters.
+(ValidationResponse *)validateHyperlinks:(NSString *)hyperlinks;

@end
