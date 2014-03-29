//
//  AddNewSourceWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SourcesTableViewController;

@interface AddNewSourceWindowController : NSWindowController

@property SourcesTableViewController *sourcesTableViewController;

@property (weak) IBOutlet NSTextField *keyTextField;
@property (weak) IBOutlet NSTextField *continentTextField;
@property (weak) IBOutlet NSPopUpButton *typeDropDownField;
@property (weak) IBOutlet NSPopUpButton *lithologyDropDownField;
@property (weak) IBOutlet NSPopUpButton *deposystemDropDownField;
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
@property (weak) IBOutlet NSPopUpButton *ageMethodDropDownField;
@property (weak) IBOutlet NSTextField *ageDataTypeTextField;
@property (weak) IBOutlet NSDatePicker *dateCollectedPicker;
@property (unsafe_unretained) IBOutlet NSTextView *hyperlinkTextView;
@property (unsafe_unretained) IBOutlet NSTextView *notesTextView;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
