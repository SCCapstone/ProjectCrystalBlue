//
//  SourcesViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesViewController.h"
#import "LocalLibraryObjectStore.h"
#import "SourceConstants.h"
#import "Source.h"
#import "AddNewSourceViewController.h"
#import "EditSourceViewController.h"
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Using local library object store for testing purposes right now - will switch to SimpleDB implementation eventually.
        dataStore =  [[LocalLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
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
    
    [confirmation beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
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
    
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
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
}

- (void)importExport
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
}

@end
