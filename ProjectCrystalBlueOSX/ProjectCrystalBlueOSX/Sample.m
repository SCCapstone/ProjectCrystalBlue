//
//  Sample.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "Sample.h"

@implementation Sample

@synthesize rockType;
@synthesize rockId;
@synthesize coordinates;
@synthesize isPulverized;

-(id) init {
    self = [super init];
    if (self) {
        rockType = @"Igneous";
        rockId = 0;
        coordinates = @"234 234";
        isPulverized = NO;
    }
    return self;
}



@end
