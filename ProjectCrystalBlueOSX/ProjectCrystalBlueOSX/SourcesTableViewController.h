//
//  SourcesTableViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AbstractCloudLibraryObjectStore, Source;

@interface SourcesTableViewController : NSViewController <NSTableViewDelegate>

@property NSMutableArray *displayedSources;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) NSSearchField *searchField;
@property AbstractCloudLibraryObjectStore *dataStore;

- (void)addSource:(Source *)source;
- (void)deleteSourceWithKey:(NSString *)key;
- (void)updateDisplayedSources;

@end
