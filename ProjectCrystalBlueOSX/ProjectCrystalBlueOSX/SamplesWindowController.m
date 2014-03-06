//
//  SamplesWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/3/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesWindowController.h"

// Model
#import "SampleConstants.h"
#import "Sample.h"
#import "Source.h"
#import "AbstractLibraryObjectStore.h"
#import "Procedures.h"
#import "PrimitiveProcedures.h"

// Read/Write
#import "OSXFileSelector.h"
#import "OSXSaveSelector.h"
#import "SampleImportController.h"
#import "LibraryObjectCSVReader.h"
#import "LibraryObjectCSVWriter.h"
#import "LibraryObjectExportController.h"

// Views
#import "ProceduresWindowController.h"
#import "DetailPanelViewController.h"

// Logging
#import "DDLog.h"
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SamplesWindowController ()

@end

@implementation SamplesWindowController

@synthesize dataStore;
@synthesize source;
@synthesize detailPanelViewController;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        detailPanelViewController = [[DetailPanelViewController alloc] initWithNibName:@"DetailPanelViewController"
                                                                                bundle:nil];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self addColumnsToSamplesTable];
    NSString *windowTitle = [NSString stringWithFormat:@"Samples for %@", source.key];
    [self.window setTitle:windowTitle];
    [self.splitView addSubview:[detailPanelViewController view]];
}

- (void)addColumnsToSamplesTable
{
    NSArray *attributeNames = [SampleConstants attributeNames];
    for (NSString *attribute in attributeNames) {
        NSTableColumn *column = [[NSTableColumn alloc] init];
        NSCell *header = [[NSTableHeaderCell alloc] initTextCell:attribute];
        [column setHeaderCell:header];
        [self.sampleTable addTableColumn:column];
    }
    DDLogDebug(@"Set up the Sample tableview with %lu columns.", [[self.sampleTable tableColumns] count]);
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (!dataStore || !source) {
        return 0;
    } else {
        return [dataStore getAllSamplesForSourceKey:source.key].count;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    if ([tableView isEqualTo:self.sampleTable]) {
        Sample *sample = [[dataStore getAllSamplesForSourceKey:source.key] objectAtIndex:row];
        NSString *attributeKey = [[tableColumn headerCell] stringValue];
        return [[sample attributes] objectForKey:attributeKey];
    }
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    NSInteger selectedRow = [self.sampleTable selectedRow];
    if (selectedRow < 0) {
        [detailPanelViewController clear];
        return;
    }

    LibraryObject *object = [[dataStore getAllSamplesForSourceKey:source.key]
                                                    objectAtIndex:selectedRow];

    [detailPanelViewController displayInformationAboutLibraryObject:object];
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    return NO;
}

- (IBAction)newBlankSample:(id)sender {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    NSInteger selectedRow = self.sampleTable.selectedRow;

    Sample *sample;
    if (selectedRow >= 0) {
        sample = [[dataStore getAllSamplesForSourceKey:source.key ] objectAtIndex:selectedRow];
    } else {
        // If nothing is selected, we create a sample with default values.
        NSString *key = [PrimitiveProcedures uniqueKeyBasedOn:[NSString stringWithFormat:@"%@.001", source.key]
                                                      inStore:dataStore
                                                      inTable:[SampleConstants tableName]];

        sample = [[Sample alloc] initWithKey:key
                           AndWithAttributes:[SampleConstants attributeNames]
                                   AndValues:[SampleConstants attributeDefaultValues]];
        [sample.attributes setObject:source.key
                              forKey:SMP_SOURCE_KEY];
    }

    [Procedures addFreshSample:sample inStore:dataStore];
    [self.sampleTable reloadData];
}

- (IBAction)deleteSample:(id)sender {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    NSInteger selectedRow = [self.sampleTable selectedRow];
    if (selectedRow < 0) {
        return;
    }

    Sample *s = [[dataStore getAllSamplesForSourceKey:source.key ] objectAtIndex:selectedRow];

    NSAlert *confirmation = [[NSAlert alloc] init];
    [confirmation setAlertStyle:NSWarningAlertStyle];

    NSString *message = [NSString stringWithFormat:@"Really delete Sample \"%@\"?", s.key];
    [confirmation setMessageText:message];

    NSString *info = @"This sample will be permanently deleted from the database!";
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
                                     DDLogInfo(@"Deleting source with key \"%@\"", s.key);
                                     [dataStore deleteLibraryObjectWithKey:s.key FromTable:[SampleConstants tableName]];
                                     break;
                                 case CANCEL_BUTTON:
                                     break;
                                 default:
                                     DDLogWarn(@"Unexpected return code %ld from DeleteSource Alert", (long)returnCode);
                                     break;
                             }
                             [self.sampleTable reloadData];
                         }];

}

- (IBAction)performProcedure:(id)sender {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    NSInteger selectedRow = [self.sampleTable selectedRow];
    if (selectedRow < 0) {
        return;
    }

    Sample *s = [[dataStore getAllSamplesForSourceKey:source.key ] objectAtIndex:selectedRow];

    ProceduresWindowController *proceduresWindowController;
    proceduresWindowController = [[ProceduresWindowController alloc] initWithWindowNibName:@"ProceduresWindowController"];
    [proceduresWindowController setSample:s];
    [proceduresWindowController setDataStore:dataStore];
    [proceduresWindowController setSamplesWindow:self];
    [proceduresWindowController showWindow:self];
    [[proceduresWindowController window] makeKeyAndOrderFront:self];
    self.proceduresWindowController = proceduresWindowController;
}

- (IBAction)importExport:(id)sender {
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
        [self.sampleTable reloadData];
    };

    [importExportOptions beginSheetModalForWindow:self.window
                                completionHandler:modalHandler];
}

-(void) displayResults:(ImportResult *)result
{
    // to-do
    [self.sampleTable reloadData];
}

- (void)reloadSamples
{
    [self.sampleTable reloadData];
}

@end
