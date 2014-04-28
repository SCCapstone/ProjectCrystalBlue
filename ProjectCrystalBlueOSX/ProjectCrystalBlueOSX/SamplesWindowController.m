//
//  SamplesWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesWindowController.h"
#import "SamplesTableViewController.h"
#import "SamplesDetailPanelViewController.h"
#import "SamplePhotosWindowController.h"
#import "AddNewSampleWindowController.h"
#import "BatchEditWindowController.h"
#import "SplitsWindowController.h"
#import "LoadingSheet.h"
#import "SimpleDBLibraryObjectStore.h"
#import "Sample.h"
#import "FileSystemUtils.h"
#import "SampleImportController.h"
#import "LibraryObjectExportController.h"
#import "LibraryObjectCSVWriter.h"
#import "CredentialsInputWindowController.h"
#import "Reachability.h"
#import "PDFRenderer.h"
#import "SamplesDeleteController.h"
#import "PCBLogWrapper.h"

@interface SamplesWindowController ()
{
    SamplesTableViewController *tableViewController;
    SamplesDetailPanelViewController *detailPanelController;
    enum subviews { tableSubview, detailPanelSubview };
    
    AbstractCloudLibraryObjectStore *dataStore;
    
    NSMutableArray *activeWindowControllers;
}

@end

@implementation SamplesWindowController

@synthesize splitView, searchField, syncToolbarButton;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if (self) {
        dataStore =  [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:[FileSystemUtils localDataDirectory]
                                                             WithDatabaseName:@"ProjectCrystalBlueLocalData"];
        
        activeWindowControllers = [[NSMutableArray alloc] init];
        
        // Add increment/decrement sample observers
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incrementSampleCount:) name:@"IncrementSampleNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decrementSampleCount:) name:@"DecrementSampleNotification" object:nil];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setDelegate:self];

    if (!detailPanelController) {
        detailPanelController = [[SamplesDetailPanelViewController alloc] initWithNibName:@"SamplesDetailPanelViewController" bundle:nil];
        [detailPanelController setDataStore:dataStore];
    }
    
    if (!tableViewController) {
        tableViewController = [[SamplesTableViewController alloc] initWithNibName:@"SamplesTableViewController" bundle:nil];
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
    NSArray *attrNames = [SampleConstants humanReadableLabels];
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
    
    [self openCredentialsWindow];
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

- (void)windowWillClose:(NSNotification *)notification
{
    [NSApp terminate:self];
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

- (void)openCredentialsWindow
{
    // Display credentials input window
    CredentialsInputWindowController *credentialsInput = [[CredentialsInputWindowController alloc] initWithWindowNibName:@"CredentialsInputWindowController"];
    [credentialsInput setDataStore:dataStore];
    
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
    [activeWindowControllers addObject:credentialsInput];
    [credentialsInput showWindow:self];
    [credentialsInput.window center];
    // The delayed call is necessary because otherwise the samples window will appear in front. The delay of 0.0
    // just means that it will be deferred until the very next run loop.
    [credentialsInput.window performSelector:@selector(makeKeyAndOrderFront:) withObject:nil afterDelay:0.0];
}

/*  NSNotifications
 */

- (void)incrementSampleCount:(NSNotification *)notification
{
    NSString *sampleKey = [notification.userInfo objectForKey:@"sampleKey"];
    Sample *sample = (Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];
    
    NSNumber *count = [sample.attributes objectForKey:SMP_NUM_SPLITS];
    count = [NSNumber numberWithInt:[count intValue] + 1];
    [sample.attributes setObject:count.stringValue forKey:SMP_NUM_SPLITS];
    [dataStore updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
    
    [tableViewController updateDisplayedSamples];
}

- (void)decrementSampleCount:(NSNotification *)notification
{
    NSString *sampleKey = [notification.userInfo objectForKey:@"sampleKey"];
    Sample *sample = (Sample *)[dataStore getLibraryObjectForKey:sampleKey FromTable:[SampleConstants tableName]];
    
    NSNumber *count = [sample.attributes objectForKey:SMP_NUM_SPLITS];
    count = [NSNumber numberWithInt:[count intValue] - 1];
    [sample.attributes setObject:count.stringValue forKey:SMP_NUM_SPLITS];
    [dataStore updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
    
    [tableViewController updateDisplayedSamples];
}


/*  Toolbar actions
 */

- (IBAction)openAddNewSamplesWindow:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    AddNewSampleWindowController *addNewSampleWindowController = [[AddNewSampleWindowController alloc] initWithWindowNibName:@"AddNewSampleWindowController"];
    [addNewSampleWindowController setSamplesTableViewController:tableViewController];
    [addNewSampleWindowController setDataStore:dataStore];
    [addNewSampleWindowController showWindow:self];
    [activeWindowControllers addObject:addNewSampleWindowController];
}

- (IBAction)openBatchEditSamplesWindow:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSIndexSet *selectedRows = [tableViewController.tableView selectedRowIndexes];
    if (selectedRows.count == 0)
        return;
    
    NSArray *selectedSamples = [tableViewController.arrayController.arrangedObjects objectsAtIndexes:selectedRows];
    
    BatchEditWindowController *batchEditSampleWindowController = [[BatchEditWindowController alloc] initWithWindowNibName:@"BatchEditWindowController"];
    [batchEditSampleWindowController setSelectedSamples:selectedSamples];
    [batchEditSampleWindowController setDataStore:dataStore];
    [batchEditSampleWindowController showWindow:self];
    [activeWindowControllers addObject:batchEditSampleWindowController];
}

- (IBAction)deleteSample:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSIndexSet *selectedRows = [tableViewController.tableView selectedRowIndexes];
    if (selectedRows.count == 0)
        return;
    
    NSArray *selectedSamples = [tableViewController.arrayController.arrangedObjects objectsAtIndexes:selectedRows];
    SamplesDeleteController *deleteController = [[SamplesDeleteController alloc] init];

    const BOOL didDelete = [deleteController presentDeletionDialogInWindow:self.window
                                                           toDeleteSamples:selectedSamples
                                                   fromTableViewController:tableViewController];
    if (didDelete) {
        // Update detail panel selection
        NSUInteger row = [tableViewController.tableView selectedRow];
        if (row == -1)
            [detailPanelController setSample:nil];
        else
            [detailPanelController setSample:[tableViewController.arrayController.arrangedObjects objectAtIndex:row]];
    }
}

- (IBAction)viewSplits:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSInteger selectedRow = [tableViewController.tableView selectedRow];
    if (selectedRow < 0)
        return;
    
    Sample *sample = [tableViewController.arrayController.arrangedObjects objectAtIndex:selectedRow];
    
    SplitsWindowController *windowController = [[SplitsWindowController alloc] initWithWindowNibName:@"SplitsWindowController"];
    [windowController setSample:sample];
    [windowController setDataStore:dataStore];
    [windowController showWindow:self];
    [activeWindowControllers addObject:windowController];
}

- (IBAction)samplePhotos:(id)sender {
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);

    NSInteger selectedRow = [tableViewController.tableView selectedRow];
    if (selectedRow < 0) {
        return;
    }

    Sample *sample = [tableViewController.arrayController.arrangedObjects objectAtIndex:selectedRow];

    SamplePhotosWindowController *photosWindowController = [[SamplePhotosWindowController alloc] initWithWindowNibName:@"SamplePhotosWindowController"];
    [photosWindowController setSample:sample];
    [photosWindowController setDataStore:dataStore];
    [photosWindowController showWindow:self];
    [activeWindowControllers addObject:photosWindowController];
}

- (IBAction)importExport:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSAlert *importExportOptions = [[NSAlert alloc] init];
    [importExportOptions setAlertStyle:NSInformationalAlertStyle];
    
    NSString *message = [NSString stringWithFormat:@"Import/Export Samples"];
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
            LibraryObjectImportController *importController = [[SampleImportController alloc] init];
            [importController setLibraryObjectStore:dataStore];
            [importController setImportResultReporter:self];
            
            OSXFileSelector *importFileChooser = [OSXFileSelector CSVFileSelector];
            [importFileChooser setDelegate:importController];
            [importFileChooser presentFileSelectorToUser];
            
        }
        else if (returnCode == EXPORT_BUTTON) {
            LibraryObjectExportController *exportController = [[LibraryObjectExportController alloc] init];
            [exportController setWriter:[[LibraryObjectCSVWriter alloc] init]];
            [exportController setObjectsToWrite:[dataStore getAllLibraryObjectsFromTable:[SampleConstants tableName]]];
            
            OSXSaveSelector *saveSelector = [[OSXSaveSelector alloc] init];
            [saveSelector setDelegate:exportController];
            [saveSelector presentSaveSelectorToUser];
            
        }
        else if (returnCode == CANCEL_BUTTON) {
            
        }
        else {
            DDLogWarn(@"Unexpected return code %ld from ImportExport Dialog", (long)returnCode);
        }
        [tableViewController updateDisplayedSamples];
    };
    
    [importExportOptions beginSheetModalForWindow:self.window
                                completionHandler:modalHandler];
}

- (void) displayResults:(ImportResult *)result
{
    [tableViewController updateDisplayedSamples];
    NSAlert *importResultAlert = [result alertWithResults];
    [importResultAlert runModal];
}

- (IBAction)printBarcodes:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSIndexSet *selectedRows = [tableViewController.tableView selectedRowIndexes];
    if (selectedRows.count == 0)
        return;
    
    NSArray *selectedSamples = [tableViewController.arrayController.arrangedObjects objectsAtIndexes:selectedRows];
    
    [PDFRenderer printQRWithLibraryObjects:selectedSamples WithWindow:self.window];
}

- (IBAction)sync:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    [dataStore synchronizeWithCloud];
    [tableViewController updateDisplayedSamples];
}

- (IBAction)setSearchCategoryFrom:(NSMenuItem *)menuItem
{
    searchField.tag = menuItem.tag;
    [searchField.cell setPlaceholderString:menuItem.title];
}

- (IBAction)searchSamples:(id)sender
{
    [tableViewController updateDisplayedSamples];
}

@end
