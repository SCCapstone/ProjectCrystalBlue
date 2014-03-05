//
//  SamplesWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/3/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImportResult.h"
@class AbstractLibraryObjectStore;
@class DetailPanelViewController;
@class Source;

@interface SamplesWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate, ImportResultReporter>

@property AbstractLibraryObjectStore *dataStore;

/// The source whose samples we are viewing.
@property Source *source;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSTableView *sampleTable;
@property (strong) NSWindowController *proceduresWindowController;
@property (strong) DetailPanelViewController *detailPanelViewController;

- (IBAction)newBlankSample:(id)sender;
- (IBAction)deleteSample:(id)sender;
- (IBAction)performProcedure:(id)sender;
- (IBAction)importExport:(id)sender;

- (void)reloadSamples;

@end
