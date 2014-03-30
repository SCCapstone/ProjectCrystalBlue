//
//  ValidationResponse.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Object to wrap information about a string validation result.
 */
@interface ValidationResponse : NSObject

/// Whether the validation of the string resulted in any errors or not.
@property BOOL isValid;

/// If there were errors, list the error strings in a user-readable form.
@property NSMutableArray *errors;

/// Generates an NSAlert containing the information from this ValidationResponse.
/// Returns nil if there are no errors.
-(NSAlert *)alertWithFieldName:(NSString *)fieldName
                    fieldValue:(NSString *)fieldValue;

@end

/// Format string for an error message about a field being too short. The format args are
/// the minimum length for this field and the length of the user's input.
static const NSString *VALIDATION_FRMT_MIN_CHARS =
    @"Minimum of %d characters; your entry was %d characters long.";

/// Format string for an error message about a field being too long. The format args are
/// the maximum length for this field and the length of the user's input.
static const NSString *VALIDATION_FRMT_MAX_CHARS =
    @"Maximum of %d characters; your input was %d characters long.";

/// Format string for an error message about a field containing invalid characters. The format
/// arg is a description of the set of valid characters, e.g. "alphanumeric characters" or
/// "letters, spaces, and punctuation".
static const NSString *VALIDATION_FRMT_INVALID_CHARACTERS = @"This field only allows %@.";