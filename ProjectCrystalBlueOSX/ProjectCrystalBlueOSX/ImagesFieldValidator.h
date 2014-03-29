//
//  ImagesFieldValidator.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/29/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationResponse.h"

/// Validation for user-entered fields associated with Images.
@interface ImagesFieldValidator : NSObject

/// Validates that initials are no more than 30 characters, and contain only alphanumeric characters.
+(ValidationResponse *)validateImageTag:(NSString *)imageTag;

@end
