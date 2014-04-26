//
//  SplitsWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImportResult.h"

@class AbstractCloudLibraryObjectStore, Sample;

@interface SplitsWindowController : NSWindowController <NSSplitViewDelegate, ImportResultReporter>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSSearchField *searchField;

@property AbstractCloudLibraryObjectStore *dataStore;
@property Sample *sample;

// Toolbar actions
- (IBAction)newBlankSplit:(id)sender;
- (IBAction)deleteSplit:(id)sender;
- (IBAction)performProcedure:(id)sender;
- (IBAction)importExport:(id)sender;
- (IBAction)printBarcodes:(id)sender;

// Search functionality
- (IBAction)setSearchCategoryFrom:(NSMenuItem *)menuItem;
- (IBAction)searchSplits:(id)sender;

@end
