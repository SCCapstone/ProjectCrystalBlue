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
@class Source;

@interface SamplesWindowController : NSWindowController <NSTableViewDataSource, ImportResultReporter>

@property AbstractLibraryObjectStore *dataStore;

/// The source whose samples we are viewing.
@property Source *source;

@property (weak) IBOutlet NSTableView *sampleTable;
@property (strong) NSWindowController *proceduresWindowController;

- (IBAction)newBlankSample:(id)sender;
- (IBAction)deleteSample:(id)sender;
- (IBAction)performProcedure:(id)sender;
- (IBAction)importExport:(id)sender;

- (void)reloadSamples;

@end
