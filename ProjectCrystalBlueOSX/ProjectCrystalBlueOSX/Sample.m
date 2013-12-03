//
//  Sample.m
//  ProjectCrystalBlueOSX
//
//  This is a class to represent a single Sample.
//  For example, in the context of Geology, this refers to an individual rock or soil sample.
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

-(id) initWithRockType:(NSString*)rockType
             AndRockId:(NSInteger)rockId
        AndCoordinates:(NSString*)coordinates
       AndIsPulverized:(bool)isPulverized
{
    self = [super init];
    if (self) {
        _rockType = rockType;
        _rockId = rockId;
        _coordinates = coordinates;
        _isPulverized = isPulverized;
    }
    return self;
}

-(id) initWithSample:(Sample*)sample {
    self = [self initWithRockType:sample.rockType
                 AndRockId:sample.rockId
            AndCoordinates:sample.coordinates
           AndIsPulverized:sample.isPulverized];
    return self;
}

-(id) init {
    return [self initWithRockType:@"Igneous"
                        AndRockId:0
                   AndCoordinates:@"123,123"
                  AndIsPulverized:NO];
}

-(void) setRockType:(NSString *)rockType {
    _rockType = rockType;
}

-(void) setRockId:(NSInteger)rockId {
    _rockId = rockId;
}

-(void) setCoordinates:(NSString *)coordinates {
    _coordinates = coordinates;
}

-(void) setIsPulverized:(bool)isPulverized {
    _isPulverized = isPulverized;
}

// Compare this Sample to another object.
-(BOOL) isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        return [self isEqualToSample:other];
    }
}

// Compare this Sample to another Sample.
// This generally shouldn't be called directly - use isEqual.
-(BOOL) isEqualToSample:(Sample *)other {
    if (self == other) {
        return YES;
    } else if (self.rockId == other.rockId) {
        // For now, samples are considered equal if they have the same ID.
        return YES;
    } else {
        return NO;
    }
}

// For now, hash is just based on the sample's ID.
-(NSUInteger) hash {
    NSUInteger hashcode = 0;
    hashcode += self.rockId;
    return hashcode;
}

@end
