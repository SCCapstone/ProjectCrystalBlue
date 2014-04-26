//
//  SplitsTableViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AbstractCloudLibraryObjectStore, SplitsDetailPanelViewController, Source, Split;

@interface SplitsTableViewController : NSViewController <NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *arrayController;

@property (weak) NSSearchField *searchField;
@property AbstractCloudLibraryObjectStore *dataStore;
@property Source *source;
@property NSMutableArray *displayedSplits;
@property SplitsDetailPanelViewController *detailPanel;

- (void)addSplit:(Split *)split;
- (void)deleteSplitWithKey:(NSString *)key;
- (void)updateDisplayedSplits;

@end
