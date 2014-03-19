//
//  AddNewSourceWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SourcesViewController;

@interface AddNewSourceWindowController : NSWindowController

@property SourcesViewController *sourcesViewController;

@property (weak) IBOutlet NSTextField *keyTextField;
@property (weak) IBOutlet NSTextField *continentTextField;
@property (weak) IBOutlet NSTextField *typeTextField;
@property (weak) IBOutlet NSTextField *lithologyTextField;
@property (weak) IBOutlet NSTextField *deposystemTextField;
@property (weak) IBOutlet NSTextField *groupTextField;
@property (weak) IBOutlet NSTextField *formationTextField;
@property (weak) IBOutlet NSTextField *memberTextField;
@property (weak) IBOutlet NSTextField *regionTextField;
@property (weak) IBOutlet NSTextField *localityTextField;
@property (weak) IBOutlet NSTextField *sectionTextField;
@property (weak) IBOutlet NSTextField *meterTextField;
@property (weak) IBOutlet NSTextField *latitudeTextField;
@property (weak) IBOutlet NSTextField *longitudeTextField;
@property (weak) IBOutlet NSTextField *ageTextField;
@property (weak) IBOutlet NSTextField *ageMethodTextField;
@property (weak) IBOutlet NSTextField *ageDataTypeTextField;
@property (weak) IBOutlet NSDatePicker *dateCollectedPicker;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
