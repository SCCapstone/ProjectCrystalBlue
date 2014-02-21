//
//  AppDelegate.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SourcesViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    SourcesViewController *initialViewController;
}

@property (assign) IBOutlet NSWindow *window;

/* Since the toolbar resides in the main window (not in the libraryview) we have to pass these
 * messages manually from the app delegate to the view controller.
 */
- (IBAction)newSource:(id)sender;
- (IBAction)editSource:(id)sender;
- (IBAction)viewSamples:(id)sender;
- (IBAction)importExport:(id)sender;
- (IBAction)deleteSource:(id)sender;
- (IBAction)sync:(id)sender;

@end
