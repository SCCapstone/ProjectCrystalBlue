//
//  NewSampleController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "AddSampleController.h"

@implementation AddSampleController

- (IBAction)addSample:(id)sender {
    NSString *coords = [_addSampleCoordinates stringValue];
    NSString *rockType = [[_addSampleRockType selectedCell] stringValue];
    long identifier = [_addSampleIdentifier integerValue];
    bool isPulverized = [[_addSamplePulverized selectedCell] stringValue];
    
    Sample *newSample = [[Sample alloc] init];
    [newSample setRockId: identifier];
    [newSample setRockType: rockType];
    [newSample setCoordinates: coords];
    [newSample setIsPulverized: YES];
    
    [_arrayController addObject:newSample];
}
@end
