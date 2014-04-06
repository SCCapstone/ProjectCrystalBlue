//
//  BatchEditWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 4/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AbstractCloudLibraryObjectStore;

@interface BatchEditWindowController : NSWindowController

@property NSArray *selectedSources;
@property AbstractCloudLibraryObjectStore *dataStore;

@property (weak) IBOutlet NSTextField *continentTextField;
@property (weak) IBOutlet NSComboBox *rockTypeComboBox;
@property (weak) IBOutlet NSComboBox *lithologyComboBox;
@property (weak) IBOutlet NSComboBox *deposystemComboBox;
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
@property (weak) IBOutlet NSComboBox *ageMethodComboBox;
@property (weak) IBOutlet NSTextField *ageDataTypeTextField;
@property (unsafe_unretained) IBOutlet NSTextView *hyperlinkTextView;
@property (unsafe_unretained) IBOutlet NSTextView *notesTextView;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)rockTypeChanged:(id)sender;

@end
