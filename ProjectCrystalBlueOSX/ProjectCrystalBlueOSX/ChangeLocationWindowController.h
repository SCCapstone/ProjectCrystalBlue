//
//  ChangeLocationWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/5/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Sample;
@class AbstractLibraryObjectStore;
@class SamplesWindowController;

@interface ChangeLocationWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *currentLocation;
@property (weak) IBOutlet NSTextField *updatedLocation;

@property (strong) Sample *sample;
@property (weak) AbstractLibraryObjectStore *dataStore;
@property SamplesWindowController *samplesWindow;

- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;

@end
