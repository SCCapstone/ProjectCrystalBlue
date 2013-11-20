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

-(int)rockId {
    return rockId;
}

-(void) setRockId:(int)newRockId {
    // TODO: Validate field
    rockId = newRockId;
}

-(NSString *) rockType {
    return rockType;
}

-(void) setRockType:(NSString *)newRockType {
    // TODO: Validate field
    if (rockType == newRockType) {
        return;
    }
    rockType = newRockType;
}

-(NSString *) coordinates {
    return coordinates;
}

-(void) setCoordinates:(NSString *)newCoordinates {
    // TODO: validate field
    if (coordinates == newCoordinates) {
        return;
    }
    
    coordinates = newCoordinates;
}

-(bool) isPulverized {
    return isPulverized;
}

-(void) setIsPulverized:(bool)newIsPulverized {
    isPulverized = newIsPulverized;
}

@end
