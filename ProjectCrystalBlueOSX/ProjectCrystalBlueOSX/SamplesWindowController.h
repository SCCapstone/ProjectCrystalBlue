//
//  SamplesWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImportResult.h"

@interface SamplesWindowController : NSWindowController <NSSplitViewDelegate,
                                                         ImportResultReporter,
                                                         NSWindowDelegate>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSToolbarItem *syncToolbarButton;

// Toolbar buttons
- (IBAction)openAddNewSamplesWindow:(id)sender;
- (IBAction)openBatchEditSamplesWindow:(id)sender;
- (IBAction)deleteSample:(id)sender;
- (IBAction)viewSplits:(id)sender;
- (IBAction)samplePhotos:(id)sender;
- (IBAction)importExport:(id)sender;
- (IBAction)printBarcodes:(id)sender;
- (IBAction)sync:(id)sender;

// Search functionality
- (IBAction)setSearchCategoryFrom:(NSMenuItem *)menuItem;
- (IBAction)searchSamples:(id)sender;

@end
