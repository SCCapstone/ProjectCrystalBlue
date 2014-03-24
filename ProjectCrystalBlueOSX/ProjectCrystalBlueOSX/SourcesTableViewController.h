//
//  SourcesTableViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AbstractLibraryObjectStore, Source;

@interface SourcesTableViewController : NSViewController <NSTableViewDelegate>

@property NSMutableArray *sources;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSTableView *tableView;
@property AbstractLibraryObjectStore *dataStore;

- (IBAction)addSource:(Source *)source;

@end
