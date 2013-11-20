//
//  Sample.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "Sample.h"

@implementation Sample

@synthesize rockType = _rockType;
@synthesize rockId = _rockId;
@synthesize coordinates = _coordinates;
@synthesize isPulverized = _isPulverized;

-(id) init {
    self = [super init];
    if (self) {
        _rockType = @"Igneous";
        _rockId = 0;
        _coordinates = @"234 234";
        _isPulverized = NO;
    }
    return self;
}

-(void) setRockType:(NSString *)rockType {
    _rockType = rockType;
}

-(void) setRockId:(int)rockId {
    _rockId = rockId;
}

-(void) setCoordinates:(NSString *)coordinates {
    _coordinates = coordinates;
}

-(void) setIsPulverized:(bool)isPulverized {
    _isPulverized = isPulverized;
}


@end
