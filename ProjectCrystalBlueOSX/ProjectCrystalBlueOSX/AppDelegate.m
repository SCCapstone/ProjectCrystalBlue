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
    
    leftViewController = [self getSourcesViewController];
    NSView *leftView = [leftViewController view];
    
    rightViewController = [self getDetailViewController];
    NSView *rightView = [rightViewController view];
    
    [leftViewController setDetailPanel:rightViewController];
    
    NSSplitView *splitView = [[NSSplitView alloc] init];
    [splitView setVertical:YES];
    [splitView setSubviews:[[NSArray alloc] initWithObjects:leftView, rightView, nil]];
    [self.window setContentView:splitView];
    
    NSMenu *attrMenu = [[NSMenu alloc] initWithTitle:@"Search Menu"];
    NSArray *attrNames = [SourceConstants attributeNames];
    for (int i=0; i<attrNames.count; i++) {
        NSMenuItem *attrItem = [[NSMenuItem alloc] initWithTitle:[attrNames objectAtIndex:i]
                                                          action:@selector(setSearchCategoryFrom:)
                                                   keyEquivalent:@""];
        [attrItem setTarget:self];
        [attrItem setTag:i];
        [attrMenu insertItem:attrItem atIndex:i];
    }
    [self.searchField.cell setSearchMenuTemplate:attrMenu];
    searchCategoryIndex = 0;
}

/// Set up and return a detailPanelViewController
- (DetailPanelViewController *)getDetailViewController
{
    DetailPanelViewController *detailView = [[DetailPanelViewController alloc] initWithNibName:@"DetailPanelViewController" bundle:nil];
    return detailView;
}

/// Set up and return a sourcesViewController for the Application.
- (SourcesViewController *)getSourcesViewController
{
    SourcesViewController *libraryView = [[SourcesViewController alloc] initWithNibName:@"SourcesViewController" bundle:nil];
    return libraryView;
}


/* Since the toolbar resides in the main window (not in the libraryview) we have to pass these
 * messages manually from the app delegate to the view controller.
 */

- (IBAction)newSource:(id)sender {
    [leftViewController showAddNewSourceDialog];
}

- (IBAction)editSource:(id)sender {
    [leftViewController showEditSourceDialog];
}

- (IBAction)viewSamples:(id)sender {
    [leftViewController viewSamples];
}

- (IBAction)importExport:(id)sender {
    [leftViewController importExport];
}

- (IBAction)deleteSource:(id)sender {
    [leftViewController removeSource];
}

- (IBAction)sync:(id)sender {
    [leftViewController sync];
}

- (IBAction)setSearchCategoryFrom:(NSMenuItem *)menuItem {
    self.searchField.tag = menuItem.tag;
    [self.searchField.cell setPlaceholderString:menuItem.title];
}

- (IBAction)searchSources:(id)sender {
    [leftViewController updateDisplayedSources];
}


@end
