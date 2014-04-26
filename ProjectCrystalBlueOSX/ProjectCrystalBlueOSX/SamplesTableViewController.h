//
//  SamplesTableViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AbstractCloudLibraryObjectStore, Sample, SamplesDetailPanelViewController;

@interface SamplesTableViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, NSComboBoxCellDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSComboBoxCell *rockTypeComboBoxCell;
@property (weak) IBOutlet NSComboBoxCell *lithologyComboBoxCell;
@property (weak) IBOutlet NSComboBoxCell *ageMethodComboBoxCell;
@property (weak) IBOutlet NSComboBoxCell *deposystemComboBoxCell;

@property (weak) NSSearchField *searchField;
@property AbstractCloudLibraryObjectStore *dataStore;
@property NSMutableArray *displayedSamples;
@property SamplesDetailPanelViewController *detailPanel;


- (void)addSample:(Sample *)sample;
- (void)deleteSampleWithKey:(NSString *)key;
- (void)updateDisplayedSamples;

@end
