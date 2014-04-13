//
//  Sample.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Sample.h"
#import "ValidationResponse.h"
#import "SampleFieldValidator.h"

@implementation Sample

- (id)initWithKey:(NSString *)key
    AndWithValues:(NSArray *)attributeValues
{
    return [super initWithKey:key
            AndWithAttributes:[SampleConstants attributeNames]
                    AndValues:attributeValues];
}

- (NSString *)sourceKey
{
    return [[self attributes] objectForKey:SMP_SOURCE_KEY];
}

/// This method is called automatically via data binding. Should not manually call this method.
- (BOOL)validateValue:(inout __autoreleasing id *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError *__autoreleasing *)outError
{
    NSString *newValue = (NSString *)*ioValue;
    ValidationResponse *response;
    NSString *attr = [inKeyPath isEqualToString:@"key"] ? @"key" : [inKeyPath substringFromIndex:11];
    
    // Validate depending on attribute
    if ([attr isEqualToString:SMP_CURRENT_LOCATION])
        response = [SampleFieldValidator validateCurrentLocation:newValue];
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
