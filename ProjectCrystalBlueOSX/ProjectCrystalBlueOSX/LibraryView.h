//
//  LibraryView.m
//  ProjectCrystalBlueOSX
//
//  View and controller functions for viewing a sample library.
//  Displays the database contents in tabular form and allows basic operations.
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewSelector.h"
#import "Sample.h"
#import "SQLiteWrapper.h"

@interface LibraryView : NSViewController {
    NSMutableArray *sampleLibrary;
    SQLiteWrapper *database;
}

@property (weak) ViewSelector *viewSelector;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *rockIdField;
@property (weak) IBOutlet NSMatrix *rockTypeField;
@property (weak) IBOutlet NSTextField *coordinatesField;
@property (weak) IBOutlet NSMatrix *pulverizedField;


- (id)initWithNibNameAndViewSelector:(NSString *)nibNameOrNil
                              bundle:(NSBundle *)nibBundleOrNil
                        viewSelector:(ViewSelector *)viewSelectorSelf;
- (BOOL)canAddSampleToLibrary:(Sample *) sample;
- (NSInteger)nextValidRockId:(NSInteger) rockId;

- (IBAction)addSample:(id)sender;
- (IBAction)deleteSample:(id)sender;
- (IBAction)cloneSample:(id)sender;
- (IBAction)updateAll:(id)sender;



@end
