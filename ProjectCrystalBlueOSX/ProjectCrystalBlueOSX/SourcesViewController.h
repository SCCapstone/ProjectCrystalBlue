//
//  SourcesViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AbstractLibraryObjectStore.h"
#import "Source.h"

@interface SourcesViewController : NSViewController <NSTableViewDataSource, NSToolbarDelegate> {
    // Holds any active windows that this view controller launches.
    NSMutableArray *activeWindows;
    
    // Holds any active view controllers that this view controller launches.
    NSMutableArray *activeViewControllers;
}

@property (weak) IBOutlet NSTableView *sourceTable;

@property AbstractLibraryObjectStore *sourcesStore;
@property AbstractLibraryObjectStore *samplesStore;

/// Add a new Source and reload the data table.
- (void)addSource:(Source *)source;

/*  These are methods that are called when the user clicks on the toolbar items.
 *  Due to the way the Windows/Views are set up in the app, the toolbar is actually
 *  part of the main menu window, not part of the SourcesView. So the AppDelegate will
 *  actually pass messages to this ViewController.
 */
- (void)showAddNewSourceDialog;
- (void)removeSource;
- (void)showEditSourceDialog;
- (void)viewSamples;
- (void)importExport;

@end
