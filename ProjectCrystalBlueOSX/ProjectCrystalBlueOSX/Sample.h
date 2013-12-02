//
//  Sample.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sample : NSObject

@property(nonatomic) NSString* rockType;
@property(nonatomic) NSInteger rockId;
@property(nonatomic) NSString* coordinates;
@property(nonatomic) bool isPulverized;

-(id) initWithRockType:(NSString*)rockType
             AndRockId:(NSInteger)rockId
        AndCoordinates:(NSString*)coordinates
       AndIsPulverized:(bool)isPulverized;

-(id) initWithSample:(Sample*)sample;

@end
