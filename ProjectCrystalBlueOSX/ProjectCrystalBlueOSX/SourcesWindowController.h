//
//  SourcesWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImportResult.h"

@interface SourcesWindowController : NSWindowController <NSSplitViewDelegate, ImportResultReporter>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSToolbarItem *syncToolbarButton;

// Toolbar buttons
- (IBAction)openAddNewSourcesWindow:(id)sender;
- (IBAction)openBatchEditSourcesWindow:(id)sender;
- (IBAction)deleteSource:(id)sender;
- (IBAction)viewSamples:(id)sender;
- (IBAction)sourcePhotos:(id)sender;
- (IBAction)importExport:(id)sender;
- (IBAction)sync:(id)sender;

// Search functionality
- (IBAction)setSearchCategoryFrom:(NSMenuItem *)menuItem;
- (IBAction)searchSources:(id)sender;

@end
