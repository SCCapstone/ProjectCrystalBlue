//
//  AddNewSourceViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/9/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SourcesViewController.h"

@interface AddNewSourceViewController : NSViewController

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
@property (weak) IBOutlet NSTextField *meterLevelTextField;
@property (weak) IBOutlet NSTextField *latitudeTextField;
@property (weak) IBOutlet NSTextField *longitudeTextField;
@property (weak) IBOutlet NSTextField *ageTextField;
@property (weak) IBOutlet NSTextField *ageBasis1TextField;
@property (weak) IBOutlet NSTextField *ageBasis2TextField;
@property (weak) IBOutlet NSTextField *dateCollectedTextField;
@property (weak) IBOutlet NSTextField *projectTextField;
@property (weak) IBOutlet NSTextField *subProjectTextField;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end