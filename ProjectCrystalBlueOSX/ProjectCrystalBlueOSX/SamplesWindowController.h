//
//  SamplesWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/3/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AbstractLibraryObjectStore;
@class Source;

@interface SamplesWindowController : NSWindowController

@property AbstractLibraryObjectStore *dataStore;

/// The source whose samples we are viewing.
@property Source *source;

@property (weak) IBOutlet NSTableView *sampleTable;

- (IBAction)newBlankSample:(id)sender;
- (IBAction)deleteSample:(id)sender;
- (IBAction)performProcedure:(id)sender;
- (IBAction)importExport:(id)sender;

@end
