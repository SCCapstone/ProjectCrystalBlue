//
//  SourcesWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesWindowController.h"
#import "SourcesTableViewController.h"
#import "SourcesDetailPanelViewController.h"
#import "SourcePhotosWindowController.h"
#import "AddNewSourceWindowController.h"
#import "SamplesWindowController.h"
#import "SimpleDBLibraryObjectStore.h"
#import "Source.h"
#import "SourceImportController.h"
#import "LibraryObjectExportController.h"
#import "LibraryObjectCSVWriter.h"
#import "Reachability.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourcesWindowController ()
{
    SourcesTableViewController *tableViewController;
    SourcesDetailPanelViewController *detailPanelController;
    enum subviews { tableSubview, detailPanelSubview };
    
    AbstractCloudLibraryObjectStore *dataStore;
    
    NSMutableArray *activeWindowControllers;
}

@end

@implementation SourcesWindowController

@synthesize splitView, searchField, syncToolbarButton;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if (self) {
        dataStore =  [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                             WithDatabaseName:@"ProjectCrystalBlueLocalData"];
        
        activeWindowControllers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if (!detailPanelController) {
        detailPanelController = [[SourcesDetailPanelViewController alloc] initWithNibName:@"SourcesDetailPanelViewController" bundle:nil];
        [detailPanelController setDataStore:dataStore];
    }
    
    if (!tableViewController) {
        tableViewController = [[SourcesTableViewController alloc] initWithNibName:@"SourcesTableViewController" bundle:nil];
        [tableViewController setDataStore:dataStore];
        [tableViewController setSearchField:searchField];
        [tableViewController setDetailPanel:detailPanelController];
    }    
    
    // Setup split view
    [self.splitView replaceSubview:[splitView.subviews objectAtIndex:tableSubview] with:tableViewController.view];
    [self.splitView replaceSubview:[splitView.subviews objectAtIndex:detailPanelSubview] with:detailPanelController.view];
    CGFloat dividerPosition = self.window.frame.size.width - 250;
    [self.splitView setPosition:dividerPosition ofDividerAtIndex:0];
    
    // Setup search field
    NSMenu *attrMenu = [[NSMenu alloc] initWithTitle:@"Attribute Names"];
    NSArray *attrNames = [SourceConstants attributeNames];
    for (int i=0; i<attrNames.count; i++) {
        NSMenuItem *attrItem = [[NSMenuItem alloc] initWithTitle:[attrNames objectAtIndex:i]
                                                          action:@selector(setSearchCategoryFrom:)
                                                   keyEquivalent:@""];
        [attrItem setTarget:self];
        [attrItem setTag:i];
        [attrMenu insertItem:attrItem atIndex:i];
    }
    [searchField.cell setSearchMenuTemplate:attrMenu];
    [self setSearchCategoryFrom:[attrMenu itemAtIndex:0]];
    
    // Setup notification for network changes
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
    if (![reach isReachable])
        [syncToolbarButton setEnabled:NO];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return [self.splitView maxPossiblePositionOfDividerAtIndex:0] - 250;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if ([subview isEqual:[self.splitView.subviews objectAtIndex:detailPanelSubview]])
        return YES;
    else
        return NO;
}

- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
    NSView *leftView = [splitView.subviews objectAtIndex:tableSubview];
    NSView *rightView = [splitView.subviews objectAtIndex:detailPanelSubview];
    
    if (![splitView isSubviewCollapsed:rightView]) {
        NSSize splitViewFrameSize = splitView.frame.size;
        CGFloat leftViewWidth = splitViewFrameSize.width - 250.0f - splitView.dividerThickness;
        leftView.frameSize = NSMakeSize(leftViewWidth, splitViewFrameSize.height);
        rightView.frame = NSMakeRect(leftViewWidth + splitView.dividerThickness, 0.0f, 250.0, splitViewFrameSize.height);
    }
    else
        [splitView adjustSubviews];
}


/*  Internet connectivity notification
 */
- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reach = [notification object];
    
    if ([reach isReachable]) {
        [syncToolbarButton setEnabled:YES];
    }
    else {
        [syncToolbarButton setEnabled:NO];
    }
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)item
{
    return [item isEnabled];
}


/*  Toolbar actions
 */

- (IBAction)openAddNewSourcesWindow:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    AddNewSourceWindowController *addNewSourceWindowController = [[AddNewSourceWindowController alloc] initWithWindowNibName:@"AddNewSourceWindowController"];
    [addNewSourceWindowController setSourcesTableViewController:tableViewController];
    [addNewSourceWindowController setDataStore:dataStore];
    [addNewSourceWindowController showWindow:self];
    [activeWindowControllers addObject:addNewSourceWindowController];
}

- (IBAction)deleteSource:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSIndexSet *selectedRows = [tableViewController.tableView selectedRowIndexes];
    if (selectedRows.count == -1)
        return;
    
    NSArray *selectedSources = [tableViewController.arrayController.arrangedObjects objectsAtIndexes:selectedRows];
    
    NSAlert *confirmation = [[NSAlert alloc] init];
    [confirmation setAlertStyle:NSWarningAlertStyle];
    
    NSString *message = [NSString stringWithFormat:@"Really delete %lu source(s)?",
                         selectedSources.count];
    [confirmation setMessageText:message];
    
    NSMutableString *info = [NSMutableString stringWithString:
                             @"These source(s) will be permanently deleted from the database:"];
    for (Source *s in selectedSources) {
        [info appendFormat:@"\n\t%@", s.key];
    }
    [confirmation setInformativeText:info];
    
    // If the order of buttons changes, the numerical constants below NEED to be swapped.
    [confirmation addButtonWithTitle:@"Delete"];
    short const DELETE_BUTTON = 1000;
    [confirmation addButtonWithTitle:@"Cancel"];
    short const CANCEL_BUTTON = 1001;
    
    [confirmation beginSheetModalForWindow:self.window
                         completionHandler:^(NSModalResponse returnCode) {
                             switch (returnCode) {
                                 case DELETE_BUTTON:
                                     for (Source *s in selectedSources) {
                                         [tableViewController deleteSourceWithKey:s.key];
                                     }
                                     break;
                                 case CANCEL_BUTTON:
                                     break;
                                 default:
                                     DDLogWarn(@"Unexpected return code %ld from DeleteSource Alert", (long)returnCode);
                                     break;
                             }
                             [tableViewController updateDisplayedSources];
                         }];
}

- (IBAction)viewSamples:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSInteger selectedRow = [tableViewController.tableView selectedRow];
    if (selectedRow < 0)
        return;
    
    Source *source = [tableViewController.arrayController.arrangedObjects objectAtIndex:selectedRow];
    
    SamplesWindowController *windowController = [[SamplesWindowController alloc] initWithWindowNibName:@"SamplesWindowController"];
    [windowController setSource:source];
    [windowController setDataStore:dataStore];
    [windowController showWindow:self];
    [activeWindowControllers addObject:windowController];
}

- (IBAction)sourcePhotos:(id)sender {
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);

    NSInteger selectedRow = [tableViewController.tableView selectedRow];
    if (selectedRow < 0) {
        return;
    }

    Source *source = [tableViewController.arrayController.arrangedObjects objectAtIndex:selectedRow];

    SourcePhotosWindowController *photosWindowController = [[SourcePhotosWindowController alloc] initWithWindowNibName:@"SourcePhotosWindowController"];
    [photosWindowController setSource:source];
    [photosWindowController setDataStore:dataStore];
    [photosWindowController showWindow:self];
    [activeWindowControllers addObject:photosWindowController];
}

- (IBAction)importExport:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSAlert *importExportOptions = [[NSAlert alloc] init];
    [importExportOptions setAlertStyle:NSInformationalAlertStyle];
    
    NSString *message = [NSString stringWithFormat:@"Import/Export Sources"];
    [importExportOptions setMessageText:message];
    
    NSString *info = @"Choose an option below:";
    [importExportOptions setInformativeText:info];
    
    // If the order of buttons changes, the numerical constants below NEED to be swapped.
    [importExportOptions addButtonWithTitle:@"Import CSV"];
    short __block const IMPORT_BUTTON = 1000;
    [importExportOptions addButtonWithTitle:@"Export CSV"];
    short __block const EXPORT_BUTTON = 1001;
    [importExportOptions addButtonWithTitle:@"Cancel"];
    short __block const CANCEL_BUTTON = 1002;
    
    void (^modalHandler)(NSModalResponse) = ^(NSModalResponse returnCode){
        
        if (returnCode == IMPORT_BUTTON) {
            LibraryObjectImportController *importController = [[SourceImportController alloc] init];
            [importController setLibraryObjectStore:dataStore];
            [importController setImportResultReporter:self];
            
            OSXFileSelector *importFileChooser = [OSXFileSelector CSVFileSelector];
            [importFileChooser setDelegate:importController];
            [importFileChooser presentFileSelectorToUser];
            
        }
        else if (returnCode == EXPORT_BUTTON) {
            LibraryObjectExportController *exportController = [[LibraryObjectExportController alloc] init];
            [exportController setWriter:[[LibraryObjectCSVWriter alloc] init]];
            [exportController setObjectsToWrite:[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]]];
            
            OSXSaveSelector *saveSelector = [[OSXSaveSelector alloc] init];
            [saveSelector setDelegate:exportController];
            [saveSelector presentSaveSelectorToUser];
            
        }
        else if (returnCode == CANCEL_BUTTON) {
            
        }
        else {
            DDLogWarn(@"Unexpected return code %ld from ImportExport Dialog", (long)returnCode);
        }
        [tableViewController updateDisplayedSources];
    };
    
    [importExportOptions beginSheetModalForWindow:self.window
                                completionHandler:modalHandler];
}

- (void) displayResults:(ImportResult *)result
{
    [tableViewController updateDisplayedSources];
}

- (IBAction)sync:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    [dataStore synchronizeWithCloud];
    [tableViewController updateDisplayedSources];
}

- (IBAction)setSearchCategoryFrom:(NSMenuItem *)menuItem
{
    searchField.tag = menuItem.tag;
    [searchField.cell setPlaceholderString:menuItem.title];
}

- (IBAction)searchSources:(id)sender
{
    [tableViewController updateDisplayedSources];
}

@end
