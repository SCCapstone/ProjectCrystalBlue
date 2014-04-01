//
//  SourceFieldValidator.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceFieldValidator.h"
#import "PrimitiveFieldValidator.h"
#import "ValidationResponse.h"
#import "SourceConstants.h"

@implementation SourceFieldValidator

/// Validates that a source key is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateSourceKey:(NSString *)key
                           WithDataStore:(AbstractLibraryObjectStore *)dataStore
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 1;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];
    
    if (![PrimitiveFieldValidator validateKey:key
                          isUniqueInDataStore:dataStore
                                      inTable:[SourceConstants tableName]])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:@"%@ is not a unique source key.", key];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:key
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              key.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:key
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              key.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet punctuationCharacterSet]];
    [validCharacters removeCharactersInString:@"'"];

    if (![PrimitiveFieldValidator validateField:key
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    
    return valid;
}

/// Validates that a continent is between 1 and 90 characters, and contains letters and spaces
/// only.
+(ValidationResponse *)validateContinent:(NSString *)continent
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 0;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:continent
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              continent.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:continent
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              continent.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet letterCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:continent
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters and spaces"];
        [valid.errors addObject:errorStr];
    }
    
    return valid;

}

/// Validates that Type is no more than 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateType:(NSString *)type
{
    const NSUInteger maxLength = 90;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:type
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              type.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:type
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}


/// Validates that Lithology is no more than 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateLithology:(NSString *)lithology
{
    const NSUInteger maxLength = 90;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:lithology
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              lithology.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:lithology
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}

/// Validates that Deposystem is no more than 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateDeposystem:(NSString *)deposystem
{
    const NSUInteger maxLength = 90;
    
    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];
    
    if (![PrimitiveFieldValidator validateField:deposystem
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              deposystem.length];
        [valid.errors addObject:errorStr];
    }
    
    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];
    
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![PrimitiveFieldValidator validateField:deposystem
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}


/// Validates that Group is no more than 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateGroup:(NSString *)group
{
    const NSUInteger maxLength = 90;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:group
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              group.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:group
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}

/// Validates that a formation is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateFormation:(NSString *)formation
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 0;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:formation
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              formation.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:formation
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              formation.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:formation
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}

/// Validates that a member is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateMember:(NSString *)member
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 0;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:member
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              member.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:member
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              member.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:member
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}

/// Validates that a region is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateRegion:(NSString *)region
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 0;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:region
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              region.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:region
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              region.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:region
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}

/// Validates that a locality is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateLocality:(NSString *)locality
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 0;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:locality
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              locality.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:locality
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              locality.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:locality
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}

/// Validates that a section is between 1 and 90 characters, and contains alphanumeric
/// characters and whitespace only.
+(ValidationResponse *)validateSection:(NSString *)section
{
    const NSUInteger maxLength = 90;
    const NSUInteger minLength = 0;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:section
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              section.length];
        [valid.errors addObject:errorStr];
    }

    if (![PrimitiveFieldValidator validateField:section
                             isAtLeastMinLength:minLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MIN_CHARS copy],
                              minLength,
                              section.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:section
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;

}

/// Validates that meters is a properly formatted decimal number.
+(ValidationResponse *)validateMeters:(NSString *)meters
{
    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![meters isEqualToString:@""] && ![PrimitiveFieldValidator validateFieldIsDecimal:meters]) {
        [valid setIsValid:NO];
        [valid.errors addObject:@"Should be formatted as a decimal (e.g. -3.1415)"];
    }

    return valid;
}

/// Validates that latitude is a properly formatted decimal number.
+(ValidationResponse *)validateLatitude:(NSString *)latitude
{
    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![latitude isEqualToString:@""] && ![PrimitiveFieldValidator validateFieldIsDecimal:latitude]) {
        [valid setIsValid:NO];
        [valid.errors addObject:@"Should be formatted as a decimal (e.g. -3.1415)"];
    }

    return valid;
}

/// Validates that longitude is a properly formatted decimal number.
+(ValidationResponse *)validateLongitude:(NSString *)longitude
{
    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![longitude isEqualToString:@""] && ![PrimitiveFieldValidator validateFieldIsDecimal:longitude]) {
        [valid setIsValid:NO];
        [valid.errors addObject:@"Should be formatted as a decimal (e.g. -3.1415)"];
    }

    return valid;
}

/// Validates that age is a properly formatted decimal number.
+(ValidationResponse *)validateAge:(NSString *)age
{
    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![age isEqualToString:@""] && ![PrimitiveFieldValidator validateFieldIsDecimal:age]) {
        [valid setIsValid:NO];
        [valid.errors addObject:@"Should be formatted as a decimal (e.g. -3.1415)"];
    }

    return valid;
}

/// Validates that ageMethod is less than 90 characters long, and uses only alphanumeric and whitespace characters.
+(ValidationResponse *)validateAgeMethod:(NSString *)ageMethod
{
    const NSUInteger maxLength = 90;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:ageMethod
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              ageMethod.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![PrimitiveFieldValidator validateField:ageMethod
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}

/// Validates that ageDataType is less than 90 characters long, and uses only alphanumeric and whitespace characters.
+(ValidationResponse *)validateAgeDatatype:(NSString *)ageDatatype
{
    const NSUInteger maxLength = 90;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:ageDatatype
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              ageDatatype.length];
        [valid.errors addObject:errorStr];
    }

    NSMutableCharacterSet *validCharacters = [[NSMutableCharacterSet alloc] init];

    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]];
    [validCharacters formUnionWithCharacterSet:[NSMutableCharacterSet punctuationCharacterSet]];
    [validCharacters removeCharactersInString:@"'"];

    if (![PrimitiveFieldValidator validateField:ageDatatype
                            containsOnlyCharSet:validCharacters])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_INVALID_CHARACTERS copy],
                              @"letters, numbers, and spaces"];
        [valid.errors addObject:errorStr];
    }
    return valid;
}

/// Validates that dateCollected is an integral numerical value (UNIX TIME)
+(ValidationResponse *)validateDateCollected:(NSString *)dateCollected
{
    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    // TODO

    return valid;
}

/// Validates that Notes is between 0 and 2000 characters.
+(ValidationResponse *)validateNotes:(NSString *)notes
{
    const int maxLength = 2000;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:notes
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              maxLength,
                              notes.length];
        [valid.errors addObject:errorStr];
    }

    return valid;
}

/// Validates that hyperlinks is between 0 and 2000 characters.
+(ValidationResponse *)validateHyperlinks:(NSString *)hyperlinks
{
    const int maxLength = 2000;

    ValidationResponse *valid = [[ValidationResponse alloc] init];
    [valid setIsValid:YES];

    if (![PrimitiveFieldValidator validateField:hyperlinks
                          isNoMoreThanMaxLength:maxLength])
    {
        [valid setIsValid:NO];
        NSString *errorStr = [NSString stringWithFormat:[VALIDATION_FRMT_MAX_CHARS copy],
                              hyperlinks,
                              hyperlinks.length];
        [valid.errors addObject:errorStr];
    }

    return valid;
}

@end
