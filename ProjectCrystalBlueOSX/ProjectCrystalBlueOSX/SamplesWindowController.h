//
//  SamplesWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImportResult.h"

@class AbstractCloudLibraryObjectStore, Source;

@interface SamplesWindowController : NSWindowController <NSSplitViewDelegate, ImportResultReporter>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSSearchField *searchField;

@property AbstractCloudLibraryObjectStore *dataStore;
@property Source *source;

// Toolbar actions
- (IBAction)newBlankSample:(id)sender;
- (IBAction)deleteSample:(id)sender;
- (IBAction)performProcedure:(id)sender;
- (IBAction)importExport:(id)sender;

// Search functionality
- (IBAction)setSearchCategoryFrom:(NSMenuItem *)menuItem;
- (IBAction)searchSamples:(id)sender;

@end
