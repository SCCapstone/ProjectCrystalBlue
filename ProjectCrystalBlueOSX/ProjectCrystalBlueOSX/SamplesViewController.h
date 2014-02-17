//
//  SamplesViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AbstractLibraryObjectStore.h"

@interface SamplesViewController : NSViewController <NSTableViewDataSource>

@property AbstractLibraryObjectStore *dataStore;

/// The source whose samples we are viewing.
@property Source *source;

@property (weak) IBOutlet NSTableView *sampleTable;

@end
