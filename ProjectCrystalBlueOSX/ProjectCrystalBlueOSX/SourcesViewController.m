//
//  SourcesViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesViewController.h"
#import "SimpleDBLibraryObjectStore.h"
#import "SourceConstants.h"
#import "Source.h"
#import "SampleConstants.h"
#import "Sample.h"
#import "OSXFileSelector.h"
#import "LibraryObjectCSVWriter.h"
#import "AddNewSourceViewController.h"
#import "EditSourceViewController.h"
#import "SamplesViewController.h"
#import "SourceImportController.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourcesViewController ()

@end

@implementation SourcesViewController

@synthesize dataStore;
@synthesize detailPanel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Using local library object store for testing purposes right now - will switch to SimpleDB implementation eventually.
        dataStore =  [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                             WithDatabaseName:@"ProjectCrystalBlueLocalData"];
        // Set up an empty array for active windows that the view controller launches
        activeWindows = [[NSMutableArray alloc] init];
        activeViewControllers = [[NSMutableArray alloc] init];
        
        DDLogInfo(@"%@: Successfully initialized with nibname %@ and nibbundle %@", NSStringFromClass(self.class), nibNameOrNil, nibBundleOrNil);
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self addColumnsToTable];
}

- (void)addColumnsToTable
{
    NSArray *attributeNames = [SourceConstants attributeNames];
    for (NSString *attribute in attributeNames) {
        NSTableColumn *column = [[NSTableColumn alloc] init];
        NSCell *header = [[NSTableHeaderCell alloc] initTextCell:attribute];
        [column setHeaderCell:header];
        [self.sourceTable addTableColumn:column];
    }
    DDLogDebug(@"Set up the Source tableview with %lu columns.", [[self.sourceTable tableColumns] count]);
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (!dataStore) {
        return 0;
    } else {
        return [[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] count];
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    if ([tableView isEqualTo:self.sourceTable]) {
        Source *source = [[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] objectAtIndex:row];
        NSString *attributeKey = [[tableColumn headerCell] stringValue];
        return [[source attributes] objectForKey:attributeKey];
    }
    return nil;
}

- (void)addSource:(Source *)source
{
    [dataStore putLibraryObject:source IntoTable:[SourceConstants tableName]];
    [self.sourceTable reloadData];
    
    // We also need to add a starting sample for this Source.
    NSString *sampleKey = [NSString stringWithFormat:@"%@.%03d", source.key, 1];
    Sample *sample = [[Sample alloc] initWithKey:sampleKey
                               AndWithAttributes:[SampleConstants attributeNames]
                                       AndValues:[SampleConstants attributeDefaultValues]];
    [sample.attributes setObject:source.key forKey:SMP_SOURCE_KEY];
    [dataStore putLibraryObject:sample IntoTable:[SampleConstants tableName]];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    NSInteger selectedRow = [self.sourceTable selectedRow];
    if (selectedRow < 0) {
        [detailPanel clear];
        return;
    }
    LibraryObject *object = [[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] objectAtIndex:selectedRow];
    
    [detailPanel displayInformationAboutLibraryObject:object];
}

/*  These are methods that are called when the user clicks on the toolbar items.
 *  Due to the way the Windows/Views are set up in the app, the toolbar is actually
 *  part of the main menu window, not part of the SourcesView. So the AppDelegate will
 *  actually pass messages to this ViewController.
 */
- (void)showAddNewSourceDialog
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    AddNewSourceViewController *viewController = [[AddNewSourceViewController alloc] initWithNibName:@"AddNewSourceViewController"
                                                                                              bundle:nil];
    [viewController setSourcesViewController:self];
    [activeViewControllers addObject:viewController];
    
    NSRect newWindowBounds = [[NSScreen mainScreen] visibleFrame];
    newWindowBounds.origin.x = [[NSScreen mainScreen] visibleFrame].size.width * 0.3;
    newWindowBounds.origin.y = [[NSScreen mainScreen] visibleFrame].size.height * 0.4 - [activeWindows count] * 30;
    newWindowBounds.size.width *= 0.4;
    newWindowBounds.size.height *= 0.4;

    int styleMask = (NSTitledWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask);
    
    NSWindow *window = [[NSWindow alloc] initWithContentRect:newWindowBounds
                                                   styleMask:styleMask
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    [window setContentView:viewController.view];
    [window makeKeyAndOrderFront:NSApp];
    [activeWindows addObject:window];
}

- (void)removeSource
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    NSInteger selectedRow = [self.sourceTable selectedRow];
    if (selectedRow < 0) {
        return;
    }
    
    Source *s = [[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] objectAtIndex:selectedRow];
    
    NSAlert *confirmation = [[NSAlert alloc] init];
    [confirmation setAlertStyle:NSWarningAlertStyle];
    
    NSString *message = [NSString stringWithFormat:@"Really delete Source \"%@\"?", s.key];
    [confirmation setMessageText:message];
                        
    NSString *info = @"This source will be permanently deleted from the database!";
    [confirmation setInformativeText:info];
    
    // If the order of buttons changes, the numerical constants below NEED to be swapped.
    [confirmation addButtonWithTitle:@"Delete"];
    short const DELETE_BUTTON = 1000;
    [confirmation addButtonWithTitle:@"Cancel"];
    short const CANCEL_BUTTON = 1001;
    
    [confirmation beginSheetModalForWindow:self.view.window
                         completionHandler:^(NSModalResponse returnCode) {
        switch (returnCode) {
            case DELETE_BUTTON:
                DDLogInfo(@"Deleting source with key \"%@\"", s.key);
                [dataStore deleteLibraryObjectWithKey:s.key FromTable:[SourceConstants tableName]];
                break;
            case CANCEL_BUTTON:
                break;
            default:
                DDLogWarn(@"Unexpected return code %ld from DeleteSource Alert", (long)returnCode);
                break;
        }
        [self.sourceTable reloadData];
    }];
}

- (void)showEditSourceDialog
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSInteger selectedRow = [self.sourceTable selectedRow];
    if (selectedRow < 0) {
        return;
    }
    Source *s = [[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] objectAtIndex:selectedRow];
    
    EditSourceViewController *editViewController;
    editViewController = [[EditSourceViewController alloc] initWithNibName:@"EditSourceViewController"
                                                                     bundle:nil];
    [editViewController setSourcesViewController:self];
    [editViewController setSource:s];
    [activeViewControllers addObject:editViewController];
    
    NSRect newWindowBounds = [[NSScreen mainScreen] visibleFrame];
    newWindowBounds.origin.x = [[NSScreen mainScreen] visibleFrame].size.width * 0.3;
    newWindowBounds.origin.y = [[NSScreen mainScreen] visibleFrame].size.height * 0.4 - [activeWindows count] * 30;
    newWindowBounds.size.width *= 0.4;
    newWindowBounds.size.height *= 0.4;
    NSWindow *window = [[NSWindow alloc] initWithContentRect:newWindowBounds
                                                   styleMask:(NSTitledWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    [window makeKeyAndOrderFront:NSApp];
    [window setContentView:editViewController.view];
    [activeWindows addObject:window];
}

- (void)viewSamples
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    NSInteger selectedRow = [self.sourceTable selectedRow];
    if (selectedRow < 0) {
        return;
    }
    
    Source *source = [[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] objectAtIndex:selectedRow];
    SamplesViewController *samplesViewController;
    samplesViewController = [[SamplesViewController alloc] initWithNibName:@"SamplesViewController"
                                                                    bundle:nil];
    [samplesViewController setSource:source];
    [samplesViewController setDataStore:dataStore];
    [activeViewControllers addObject:samplesViewController];
    
    NSRect newWindowBounds = [[NSScreen mainScreen] visibleFrame];
    newWindowBounds.origin.x = [[NSScreen mainScreen] visibleFrame].size.width * 0.3;
    newWindowBounds.origin.y = [[NSScreen mainScreen] visibleFrame].size.height * 0.4 - [activeWindows count] * 30;
    newWindowBounds.size.width *= 0.4;
    newWindowBounds.size.height *= 0.4;
    NSWindow *window = [[NSWindow alloc] initWithContentRect:newWindowBounds
                                                   styleMask:(NSTitledWindowMask |
                                                              NSResizableWindowMask |
                                                              NSMiniaturizableWindowMask |
                                                              NSClosableWindowMask)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    
    [window makeKeyAndOrderFront:NSApp];
    [window setContentView:samplesViewController.view];
    [activeWindows addObject:window];
}

- (void)importExport
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
            
        } else if (returnCode == EXPORT_BUTTON) {
            
            // Temporarily hard-coding file name and destination.
            NSDate *now = [[NSDate alloc] init];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterMediumStyle];
            NSString *filename = [[formatter stringFromDate:now] stringByAppendingString:@".csv"];
            LibraryObjectCSVWriter *writer = [[LibraryObjectCSVWriter alloc] init];
            
            NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [documentDirectories objectAtIndex:0];
            
            [writer writeObjects:[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]]
                    ToFileAtPath:[documentDirectory stringByAppendingFormat:@"/%@", filename]];
            
        } else if (returnCode == CANCEL_BUTTON) {
            
        } else {
            DDLogWarn(@"Unexpected return code %ld from ImportExport Dialog", (long)returnCode);
        }
        [self.sourceTable reloadData];
    };
    
    [importExportOptions beginSheetModalForWindow:self.view.window
                                completionHandler:modalHandler];
}

-(void) displayResults:(ImportResult *)result
{
    [self.sourceTable reloadData];
}

- (void)sync
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    [dataStore synchronizeWithCloud];
    [self.sourceTable reloadData];
}

@end
