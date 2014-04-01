//
//  Source.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Source.h"
#import "SourceFieldValidator.h"
#import "ValidationResponse.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation Source

- (id)initWithKey:(NSString *)key
    AndWithValues:(NSArray *)attributeValues
{
    return [super initWithKey:key
            AndWithAttributes:[SourceConstants attributeNames]
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
    if ([attr isEqualToString:SRC_REGION])
        response = [SourceFieldValidator validateRegion:newValue];
    else if ([attr isEqualToString:SRC_CONTINENT])
        response = [SourceFieldValidator validateContinent:newValue];
    else if ([attr isEqualToString:SRC_LOCALITY])
        response = [SourceFieldValidator validateLocality:newValue];
    else if ([attr isEqualToString:SRC_LATITUDE])
        response = [SourceFieldValidator validateLatitude:newValue];
    else if ([attr isEqualToString:SRC_LONGITUDE])
        response = [SourceFieldValidator validateLongitude:newValue];
    else if ([attr isEqualToString:SRC_DATE_COLLECTED])
        response = [SourceFieldValidator validateDateCollected:newValue];
    else if ([attr isEqualToString:SRC_AGE])
        response = [SourceFieldValidator validateAge:newValue];
    else if ([attr isEqualToString:SRC_AGE_DATATYPE])
        response = [SourceFieldValidator validateAgeDatatype:newValue];
    else if ([attr isEqualToString:SRC_GROUP])
        response = [SourceFieldValidator validateGroup:newValue];
    else if ([attr isEqualToString:SRC_FORMATION])
        response = [SourceFieldValidator validateFormation:newValue];
    else if ([attr isEqualToString:SRC_MEMBER])
        response = [SourceFieldValidator validateMember:newValue];
    else if ([attr isEqualToString:SRC_SECTION])
        response = [SourceFieldValidator validateSection:newValue];
    else if ([attr isEqualToString:SRC_METER])
        response = [SourceFieldValidator validateMeters:newValue];
    else if ([attr isEqualToString:SRC_HYPERLINKS])
        response = [SourceFieldValidator validateHyperlinks:newValue];
    else if ([attr isEqualToString:SRC_NOTES])
        response = [SourceFieldValidator validateNotes:newValue];
    else if ([attr isEqualToString:SRC_TYPE])
        response = [SourceFieldValidator validateType:newValue];
    else if ([attr isEqualToString:SRC_LITHOLOGY])
        response = [SourceFieldValidator validateLithology:newValue];
    else if ([attr isEqualToString:SRC_DEPOSYSTEM])
        response = [SourceFieldValidator validateDeposystem:newValue];
    else if ([attr isEqualToString:SRC_AGE_METHOD])
        response = [SourceFieldValidator validateAgeMethod:newValue];
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
