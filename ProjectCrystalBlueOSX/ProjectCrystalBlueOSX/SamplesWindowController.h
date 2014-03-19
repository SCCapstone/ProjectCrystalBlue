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
@class ChangeLocationWindowController;
@class Source;

@interface SamplesWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate, ImportResultReporter> {

    // Holds all samples currently displayed
    NSArray *displayedSamples;
}

@property AbstractLibraryObjectStore *dataStore;

/// The source whose samples we are viewing.
@property Source *source;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSTableView *sampleTable;
@property (weak) IBOutlet NSSearchField *searchField;
@property (strong) NSWindowController *proceduresWindowController;
@property (strong) ChangeLocationWindowController *changeLocationController;
@property (strong) DetailPanelViewController *detailPanelViewController;

- (IBAction)newBlankSample:(id)sender;
- (IBAction)deleteSample:(id)sender;
- (IBAction)performProcedure:(id)sender;
- (IBAction)importExport:(id)sender;
- (IBAction)changeLocation:(id)sender;
- (IBAction)searchSamples:(id)sender;

- (void)updateDisplayedSamples;

@end
