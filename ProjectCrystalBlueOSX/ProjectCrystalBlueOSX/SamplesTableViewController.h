//
//  SamplesTableViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AbstractCloudLibraryObjectStore, SamplesDetailPanelViewController, Source, Sample;

@interface SamplesTableViewController : NSViewController <NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *arrayController;

@property (weak) NSSearchField *searchField;
@property AbstractCloudLibraryObjectStore *dataStore;
@property Source *source;
@property NSMutableArray *displayedSamples;
@property SamplesDetailPanelViewController *detailPanel;

- (void)addSample:(Sample *)sample;
- (void)deleteSampleWithKey:(NSString *)key;
- (void)updateDisplayedSamples;

@end
