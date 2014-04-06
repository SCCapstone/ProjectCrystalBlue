//
//  SourcesTableViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AbstractCloudLibraryObjectStore, Source, SourcesDetailPanelViewController;

@interface SourcesTableViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, NSComboBoxCellDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSComboBoxCell *rockTypeComboBoxCell;
@property (weak) IBOutlet NSComboBoxCell *lithologyComboBoxCell;
@property (weak) IBOutlet NSComboBoxCell *ageMethodComboBoxCell;
@property (weak) IBOutlet NSComboBoxCell *deposystemComboBoxCell;

@property (weak) NSSearchField *searchField;
@property AbstractCloudLibraryObjectStore *dataStore;
@property NSMutableArray *displayedSources;
@property SourcesDetailPanelViewController *detailPanel;


- (void)updateComboBoxesWithRockType:(NSString *)rockType;
- (void)addSource:(Source *)source;
- (void)deleteSourceWithKey:(NSString *)key;
- (void)updateDisplayedSources;

@end
