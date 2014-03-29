//
//  ProcedureFieldValidator.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/29/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationResponse.h"

/// Validation for user-entered fields associated with Procedures.
@interface ProcedureFieldValidator : NSObject

/// Validates that initials are between 1-10 characters, and contain only alphanumeric characters.
+(ValidationResponse *)validateInitials:(NSString *)initials;

@end
