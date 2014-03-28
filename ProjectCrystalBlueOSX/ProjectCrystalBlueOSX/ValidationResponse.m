//
//  ValidationResponse.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ValidationResponse.h"

@implementation ValidationResponse

- (instancetype)init
{
    self = [super init];
    if (self) {
        isValid = YES;
        errors = [[NSMutableArray alloc] init];
    }
    return self;
}

@synthesize isValid;
@synthesize errors;

@end
