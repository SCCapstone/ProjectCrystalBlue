//
//  SampleFieldConstants.m
//  ProjectCrystalBlueOSX
//
//  A set of constants (e.g. valid field names and format strings) for use by the Sample class.
//
//  Created by Logan Hood on 12/3/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "SampleFieldConstants.h"

@implementation SampleFieldConstants

+(void) initialize {
    ROCK_TYPES = [[NSMutableSet alloc] init];
    [ROCK_TYPES addObject:@"Igneous"];
    [ROCK_TYPES addObject:@"Metamorphic"];
    [ROCK_TYPES addObject:@"Sedimentary"];
}

+(NSMutableSet*) getRockTypes {
    return ROCK_TYPES;
}

@end
