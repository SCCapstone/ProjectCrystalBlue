//
//  SourcesViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AbstractLibraryObjectStore.h"

@interface SourcesViewController : NSViewController <NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *sourceTable;

@property AbstractLibraryObjectStore *sourcesStore;
@property AbstractLibraryObjectStore *samplesStore;

@end
