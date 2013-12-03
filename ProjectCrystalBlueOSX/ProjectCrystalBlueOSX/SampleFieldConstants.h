//
//  SampleFieldConstants.m
//  ProjectCrystalBlueOSX
//
//  A set of constants (e.g. valid field names and format strings) for use by the Sample class.
//
//  Created by Logan Hood on 12/3/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSMutableSet* ROCK_TYPES;

@interface SampleFieldConstants : NSObject

+(NSMutableSet*) getRockTypes;

@end
