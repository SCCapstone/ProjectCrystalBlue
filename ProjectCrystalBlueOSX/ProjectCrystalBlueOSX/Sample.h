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

#import <Foundation/Foundation.h>
#import "SampleFieldConstants.h"

@interface Sample : NSObject

@property(nonatomic) NSString* rockType;
@property(nonatomic) long rockId;
@property(nonatomic) NSString* coordinates;
@property(nonatomic) bool isPulverized;

-(id) initWithRockType:(NSString*)rockType
             AndRockId:(long)rockId
        AndCoordinates:(NSString*)coordinates
       AndIsPulverized:(bool)isPulverized;

-(id) initWithSample:(Sample*)sample;

@end
