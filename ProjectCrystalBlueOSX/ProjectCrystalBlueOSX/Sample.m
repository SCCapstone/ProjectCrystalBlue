//
//  Sample.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Sample.h"
#import "SampleFieldValidator.h"
#import "ValidationResponse.h"
#import "PCBLogWrapper.h"

@implementation Sample

- (id)initWithKey:(NSString *)key
    AndWithValues:(NSArray *)attributeValues
{
    return [super initWithKey:key
            AndWithAttributes:[SampleConstants attributeNames]
                    AndValues:attributeValues];
}

/// This method is called automatically via data binding. Should not manually call this method.
- (BOOL)validateValue:(inout __autoreleasing id *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError *__autoreleasing *)outError
{
    NSString *newValue = (NSString *)*ioValue;
    ValidationResponse *response;
    NSString *attr = [inKeyPath isEqualToString:@"key"] ? @"key" : [inKeyPath substringFromIndex:11];
    
    // If empty value then skip validation
    if (!newValue)
        return YES;
    
    // Validate depending on attribute
    if ([attr isEqualToString:SMP_REGION])
        response = [SampleFieldValidator validateRegion:newValue];
    else if ([attr isEqualToString:SMP_CONTINENT])
        response = [SampleFieldValidator validateContinent:newValue];
    else if ([attr isEqualToString:SMP_LOCALITY])
        response = [SampleFieldValidator validateLocality:newValue];
    else if ([attr isEqualToString:SMP_LATITUDE])
        response = [SampleFieldValidator validateLatitude:newValue];
    else if ([attr isEqualToString:SMP_LONGITUDE])
        response = [SampleFieldValidator validateLongitude:newValue];
    else if ([attr isEqualToString:SMP_DATE_COLLECTED])
        response = [SampleFieldValidator validateDateCollected:newValue];
    else if ([attr isEqualToString:SMP_COLLECTED_BY])
        response = [SampleFieldValidator validateCollectedBy:newValue];
    else if ([attr isEqualToString:SMP_AGE])
        response = [SampleFieldValidator validateAge:newValue];
    else if ([attr isEqualToString:SMP_AGE_DATATYPE])
        response = [SampleFieldValidator validateAgeDatatype:newValue];
    else if ([attr isEqualToString:SMP_GROUP])
        response = [SampleFieldValidator validateGroup:newValue];
    else if ([attr isEqualToString:SMP_FORMATION])
        response = [SampleFieldValidator validateFormation:newValue];
    else if ([attr isEqualToString:SMP_MEMBER])
        response = [SampleFieldValidator validateMember:newValue];
    else if ([attr isEqualToString:SMP_SECTION])
        response = [SampleFieldValidator validateSection:newValue];
    else if ([attr isEqualToString:SMP_METER])
        response = [SampleFieldValidator validateMeters:newValue];
    else if ([attr isEqualToString:SMP_HYPERLINKS])
        response = [SampleFieldValidator validateHyperlinks:newValue];
    else if ([attr isEqualToString:SMP_NOTES])
        response = [SampleFieldValidator validateNotes:newValue];
    else if ([attr isEqualToString:SMP_TYPE])
        response = [SampleFieldValidator validateType:newValue];
    else if ([attr isEqualToString:SMP_LITHOLOGY])
        response = [SampleFieldValidator validateLithology:newValue];
    else if ([attr isEqualToString:SMP_DEPOSYSTEM])
        response = [SampleFieldValidator validateDeposystem:newValue];
    else if ([attr isEqualToString:SMP_AGE_METHOD])
        response = [SampleFieldValidator validateAgeMethod:newValue];
    else
        return YES;
    
    if (response.isValid)
        return YES;
    
    NSString *errorString = NSLocalizedString([response.errors componentsJoinedByString:@"\n"], @"Validation: Invalid value");
    NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey: errorString };
    *outError = [[NSError alloc] initWithDomain:@"Error domain" code:0 userInfo:userInfoDict];
    return NO;
}

@end
