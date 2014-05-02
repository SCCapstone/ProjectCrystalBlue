//
//  SplitsWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SplitsWindowController.h"
#import "SplitsTableViewController.h"
#import "SplitsDetailPanelViewController.h"
#import "ProceduresWindowController.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "Sample.h"
#import "Split.h"
#import "Procedures.h"
#import "PrimitiveProcedures.h"
#import "SplitImportController.h"
#import "LibraryObjectExportController.h"
#import "LibraryObjectCSVWriter.h"
#import "PDFRenderer.h"
#import "PCBLogWrapper.h"

@interface SplitsWindowController ()
{
    SplitsTableViewController *tableViewController;
    SplitsDetailPanelViewController *detailPanelController;
    enum subviews { tableSubview, detailPanelSubview };
    
    ProceduresWindowController *proceduresWindowController;
}
@end

@implementation SplitsWindowController

@synthesize splitView, searchField, dataStore, sample;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSString *windowTitle = [NSString stringWithFormat:@"Splits For '%@'", sample.key];
    [self.window setTitle:windowTitle];
    
    if (!detailPanelController) {
        detailPanelController = [[SplitsDetailPanelViewController alloc] initWithNibName:@"SplitsDetailPanelViewController" bundle:nil];
        [detailPanelController setDataStore:dataStore];
    }
    
    if (!tableViewController) {
        tableViewController = [[SplitsTableViewController alloc] initWithNibName:@"SplitsTableViewController" bundle:nil];
        [tableViewController setDataStore:dataStore];
        [tableViewController setSample:sample];
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
    NSArray *attrNames = [SplitConstants humanReadableLabels];
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


/*  Toolbar actions
 */

- (void)newBlankSplit:(id)sender
{
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    Split *split;
    NSInteger selectedRow = tableViewController.tableView.selectedRow;
    
    if (selectedRow != -1)
        split = [tableViewController.arrayController.arrangedObjects objectAtIndex:selectedRow];
    
    // If nothing is selected, we create a split with default values.
    else {
        NSString *key = [PrimitiveProcedures uniqueKeyBasedOn:[NSString stringWithFormat:@"%@.001", sample.key]
                                                      inStore:dataStore
                                                      inTable:[SplitConstants tableName]];
        
        split = [[Split alloc] initWithKey:key
                         AndWithAttributes:[SplitConstants attributeNames]
                                 AndValues:[SplitConstants attributeDefaultValues]];
        [split.attributes setObject:sample.key forKey:SPL_SAMPLE_KEY];
    }
    
    [tableViewController addSplit:split];
}

- (void)deleteSplit:(id)sender
{
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    NSIndexSet *selectedRows = [tableViewController.tableView selectedRowIndexes];
    if (selectedRows.count <= 0) {
        return;
    }
    
    NSArray *selectedSplits = [tableViewController.arrayController.arrangedObjects objectsAtIndexes:selectedRows];
    
    NSAlert *confirmation = [[NSAlert alloc] init];
    [confirmation setAlertStyle:NSWarningAlertStyle];
    
    NSString *message = [NSString stringWithFormat:@"Really delete %lu split(s)?",
                         selectedSplits.count];
    [confirmation setMessageText:message];
    
    NSMutableString *info = [NSMutableString stringWithString:
                             @"These splits will be permanently deleted from the database:"];
    
    for (Split *s in selectedSplits) {
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
                                     for (Split *s in selectedSplits) {
                                         DDLogInfo(@"Deleting split with key \"%@\"", s.key);
                                         [tableViewController deleteSplitWithKey:s.key];
                                     }
                                     break;
                                 case CANCEL_BUTTON:
                                     break;
                                 default:
                                     DDLogWarn(@"Unexpected return code %ld from DeleteSplit Alert", (long)returnCode);
                                     break;
                             }
                             [tableViewController updateDisplayedSplits];
                             
                             // Update detail panel selection
                             NSUInteger row = [tableViewController.tableView selectedRow];
                             if (row == -1)
                                 [detailPanelController setSplit:nil];
                             else
                                 [detailPanelController setSplit:[tableViewController.arrayController.arrangedObjects objectAtIndex:row]];
                         }];
}

- (void)performProcedure:(id)sender
{
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    NSInteger selectedRow = [tableViewController.tableView selectedRow];
    if (selectedRow == -1) {
        return;
    }
    
    Split *s = [tableViewController.arrayController.arrangedObjects objectAtIndex:selectedRow];
    
    proceduresWindowController = [[ProceduresWindowController alloc] initWithWindowNibName:@"ProceduresWindowController"];
    [proceduresWindowController setSplit:s];
    [proceduresWindowController setDataStore:dataStore];
    [proceduresWindowController setSplitsTableViewController:tableViewController];
    [proceduresWindowController showWindow:self];
    [[proceduresWindowController window] makeKeyAndOrderFront:self];
}

- (void)importExport:(id)sender
{
    NSAlert *importExportOptions = [[NSAlert alloc] init];
    [importExportOptions setAlertStyle:NSInformationalAlertStyle];
    
    NSString *message = [NSString stringWithFormat:@"Import/Export Splits"];
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
            LibraryObjectImportController *importController = [[SplitImportController alloc] init];
            [importController setLibraryObjectStore:dataStore];
            [importController setImportResultReporter:self];
            
            OSXFileSelector *importFileChooser = [OSXFileSelector CSVFileSelector];
            [importFileChooser setDelegate:importController];
            [importFileChooser presentFileSelectorToUser];
            
        } else if (returnCode == EXPORT_BUTTON) {
            LibraryObjectExportController *exportController = [[LibraryObjectExportController alloc] init];
            [exportController setWriter:[[LibraryObjectCSVWriter alloc] init]];
            [exportController setObjectsToWrite:[dataStore getAllLibraryObjectsFromTable:[SplitConstants tableName]]];
            
            OSXSaveSelector *saveSelector = [[OSXSaveSelector alloc] init];
            [saveSelector setDelegate:exportController];
            [saveSelector presentSaveSelectorToUser];
            
        } else if (returnCode == CANCEL_BUTTON) {
            
        } else {
            DDLogWarn(@"Unexpected return code %ld from ImportExport Dialog", (long)returnCode);
        }
        [tableViewController updateDisplayedSplits];
    };
    
    [importExportOptions beginSheetModalForWindow:self.window
                                completionHandler:modalHandler];
}

- (IBAction)printBarcodes:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSIndexSet *selectedRows = [tableViewController.tableView selectedRowIndexes];
    if (selectedRows.count == 0)
        return;
    
    NSArray *selectedSplits = [tableViewController.arrayController.arrangedObjects objectsAtIndexes:selectedRows];
    
    [PDFRenderer printQRWithLibraryObjects:selectedSplits WithWindow:self.window];
}

-(void) displayResults:(ImportResult *)result
{
    // to-do
    [tableViewController updateDisplayedSplits];
}

- (IBAction)setSearchCategoryFrom:(NSMenuItem *)menuItem
{
    searchField.tag = menuItem.tag;
    [searchField.cell setPlaceholderString:menuItem.title];
}

- (IBAction)searchSplits:(id)sender
{
    [tableViewController updateDisplayedSplits];
}

@end
