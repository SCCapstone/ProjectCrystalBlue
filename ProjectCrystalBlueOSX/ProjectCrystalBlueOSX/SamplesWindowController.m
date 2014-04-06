//
//  SamplesWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesWindowController.h"
#import "SamplesTableViewController.h"
#import "SamplesDetailPanelViewController.h"
#import "ProceduresWindowController.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "Source.h"
#import "Sample.h"
#import "Procedures.h"
#import "PrimitiveProcedures.h"
#import "SampleImportController.h"
#import "LibraryObjectExportController.h"
#import "LibraryObjectCSVWriter.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SamplesWindowController ()
{
    SamplesTableViewController *tableViewController;
    SamplesDetailPanelViewController *detailPanelController;
    enum subviews { tableSubview, detailPanelSubview };
    
    ProceduresWindowController *proceduresWindowController;
}
@end

@implementation SamplesWindowController

@synthesize splitView, searchField, dataStore, source;

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
    
    NSString *windowTitle = [NSString stringWithFormat:@"Samples For '%@'", source.key];
    [self.window setTitle:windowTitle];
    
    if (!detailPanelController) {
        detailPanelController = [[SamplesDetailPanelViewController alloc] initWithNibName:@"SamplesDetailPanelViewController" bundle:nil];
        [detailPanelController setDataStore:dataStore];
    }
    
    if (!tableViewController) {
        tableViewController = [[SamplesTableViewController alloc] initWithNibName:@"SamplesTableViewController" bundle:nil];
        [tableViewController setDataStore:dataStore];
        [tableViewController setSource:source];
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

- (void)newBlankSample:(id)sender
{
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    Sample *sample;
    NSInteger selectedRow = tableViewController.tableView.selectedRow;
    
    if (selectedRow != -1)
        sample = [tableViewController.arrayController.arrangedObjects objectAtIndex:selectedRow];
    
    // If nothing is selected, we create a sample with default values.
    else {
        NSString *key = [PrimitiveProcedures uniqueKeyBasedOn:[NSString stringWithFormat:@"%@.001", source.key]
                                                      inStore:dataStore
                                                      inTable:[SampleConstants tableName]];
        
        sample = [[Sample alloc] initWithKey:key
                           AndWithAttributes:[SampleConstants attributeNames]
                                   AndValues:[SampleConstants attributeDefaultValues]];
        [sample.attributes setObject:source.key
                              forKey:SMP_SOURCE_KEY];
    }
    
    [tableViewController addSample:sample];
}

- (void)deleteSample:(id)sender
{
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    NSIndexSet *selectedRows = [tableViewController.tableView selectedRowIndexes];
    if (selectedRows.count <= 0) {
        return;
    }
    
    NSArray *selectedSamples = [tableViewController.arrayController.arrangedObjects objectsAtIndexes:selectedRows];
    
    NSAlert *confirmation = [[NSAlert alloc] init];
    [confirmation setAlertStyle:NSWarningAlertStyle];
    
    NSString *message = [NSString stringWithFormat:@"Really delete %lu sample(s)?",
                         selectedSamples.count];
    [confirmation setMessageText:message];
    
    NSMutableString *info = [NSMutableString stringWithString:
                             @"These samples will be permanently deleted from the database:"];
    
    for (Sample *s in selectedSamples) {
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
                                     for (Sample *s in selectedSamples) {
                                         DDLogInfo(@"Deleting source with key \"%@\"", s.key);
                                         [tableViewController deleteSampleWithKey:s.key];
                                     }
                                     break;
                                 case CANCEL_BUTTON:
                                     break;
                                 default:
                                     DDLogWarn(@"Unexpected return code %ld from DeleteSource Alert", (long)returnCode);
                                     break;
                             }
                             [tableViewController updateDisplayedSamples];
                         }];
}

- (void)performProcedure:(id)sender
{
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    NSInteger selectedRow = [tableViewController.tableView selectedRow];
    if (selectedRow == -1) {
        return;
    }
    
    Sample *s = [tableViewController.arrayController.arrangedObjects objectAtIndex:selectedRow];
    
    proceduresWindowController = [[ProceduresWindowController alloc] initWithWindowNibName:@"ProceduresWindowController"];
    [proceduresWindowController setSample:s];
    [proceduresWindowController setDataStore:dataStore];
    [proceduresWindowController setSamplesTableViewController:tableViewController];
    [proceduresWindowController showWindow:self];
    [[proceduresWindowController window] makeKeyAndOrderFront:self];
}

- (void)importExport:(id)sender
{
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
            
        } else if (returnCode == EXPORT_BUTTON) {
            LibraryObjectExportController *exportController = [[LibraryObjectExportController alloc] init];
            [exportController setWriter:[[LibraryObjectCSVWriter alloc] init]];
            [exportController setObjectsToWrite:[dataStore getAllLibraryObjectsFromTable:[SampleConstants tableName]]];
            
            OSXSaveSelector *saveSelector = [[OSXSaveSelector alloc] init];
            [saveSelector setDelegate:exportController];
            [saveSelector presentSaveSelectorToUser];
            
        } else if (returnCode == CANCEL_BUTTON) {
            
        } else {
            DDLogWarn(@"Unexpected return code %ld from ImportExport Dialog", (long)returnCode);
        }
        [tableViewController updateDisplayedSamples];
    };
    
    [importExportOptions beginSheetModalForWindow:self.window
                                completionHandler:modalHandler];
}

-(void) displayResults:(ImportResult *)result
{
    // to-do
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
