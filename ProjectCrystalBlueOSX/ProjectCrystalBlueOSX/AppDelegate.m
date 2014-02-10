//
//  AppDelegate.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AppDelegate.h"
#import "SourcesViewController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "DDFileLogger.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    NSDate *now = [[NSDate alloc] init];
    DDLogInfo(@"Launched app %@", now);
    
    initialViewController = [self getInitialViewController];
    NSView *initialView = [initialViewController view];
    [self.window setContentView:initialView];
}

/// Set up and return the initial view controller for the Application.
- (SourcesViewController *)getInitialViewController
{
    SourcesViewController *libraryView = [[SourcesViewController alloc] initWithNibName:@"SourcesViewController" bundle:nil];
    return libraryView;
}


/* Since the toolbar resides in the main window (not in the libraryview) we have to pass these
 * messages manually from the app delegate to the view controller.
 */

- (IBAction)newSource:(id)sender {
    [initialViewController showAddNewSourceDialog];
}

- (IBAction)editSource:(id)sender {
    [initialViewController showEditSourceDialog];
}

- (IBAction)viewSamples:(id)sender {
    [initialViewController viewSamples];
}

- (IBAction)importExport:(id)sender {
    [initialViewController importExport];
}

- (IBAction)deleteSource:(id)sender {
    [initialViewController removeSource];
}
@end
