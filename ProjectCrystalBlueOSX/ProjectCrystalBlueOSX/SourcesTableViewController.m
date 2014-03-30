//
//  SourcesTableViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesTableViewController.h"
#import "SourcesDetailPanelViewController.h"
#import "Source.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourcesTableViewController ()
{
    
}
@end

@implementation SourcesTableViewController

@synthesize displayedSources, tableView, searchField, dataStore, detailPanel, arrayController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        displayedSources = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self updateDisplayedSources];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = [tableView selectedRow];
    if (selectedRow == -1) {
        //[detailPanel clear];
        return;
    }
    
    Source *source = [arrayController.arrangedObjects objectAtIndex:selectedRow];
    [detailPanel setSource:source];
}

- (BOOL)tableView:(NSTableView *)mTableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Use custom date picker for date cell
    if ([[tableColumn.headerCell stringValue] isEqualToString:@"Date Collected"]) {
    
        // Create a frame which covers the cell to be edited
        NSRect frame = [tableView frameOfCellAtColumn:[[tableView tableColumns] indexOfObject:tableColumn] row:row];
        frame.origin.x -= [tableView intercellSpacing].width * 0.5;
        frame.origin.y -= [tableView intercellSpacing].height * 0.5;
        frame.size.width += 50;
        frame.size.height = 23;
        
        // Set up a date picker with no border or background
        NSDatePicker *datePicker = [[NSDatePicker alloc] initWithFrame:frame];
        [datePicker setBordered:NO];
        [datePicker setDrawsBackground:NO];
        [datePicker setDatePickerElements:NSHourMinuteDatePickerElementFlag | NSYearMonthDayDatePickerElementFlag];
        [datePicker setDatePickerStyle:NSTextFieldDatePickerStyle];
        
        Source *source = [arrayController.arrangedObjects objectAtIndex:row];
        [datePicker setDateValue:[NSDate dateWithNaturalLanguageString:[source.attributes objectForKey:SRC_DATE_COLLECTED]]];
        
        // Create a menu with a single menu item, and set the date picker as the menu item's view
        id menu = [[NSMenu alloc] initWithTitle:@"Title"];
        id item = [[NSMenuItem alloc] initWithTitle:@"Item Title" action:NULL keyEquivalent:@""];
        [item setView:datePicker];
        [menu addItem:item];
        
        // Display the menu
        [menu popUpMenuPositioningItem:nil atLocation:frame.origin inView:tableView];
        
        // Set new date value
        [detailPanel setDateCollected:[datePicker dateValue]];
        
        return NO;
    }
    
    return YES;
}

- (void)addSource:(Source *)source
{
    [dataStore putLibraryObject:source IntoTable:[SourceConstants tableName]];
    [self updateDisplayedSources];
    
    // We also need to add a starting sample for this Source.
    NSString *sampleKey = [NSString stringWithFormat:@"%@.%03d", source.key, 1];
    Sample *sample = [[Sample alloc] initWithKey:sampleKey
                               AndWithAttributes:[SampleConstants attributeNames]
                                       AndValues:[SampleConstants attributeDefaultValues]];
    [sample.attributes setObject:source.key forKey:SMP_SOURCE_KEY];
    [dataStore putLibraryObject:sample IntoTable:[SampleConstants tableName]];
}

- (void)deleteSourceWithKey:(NSString *)key
{
    DDLogInfo(@"Deleting source with key \"%@\"", key);
    [dataStore deleteLibraryObjectWithKey:key FromTable:[SourceConstants tableName]];
}

- (void)updateDisplayedSources
{
    NSString *attrName = [[SourceConstants attributeNames] objectAtIndex:searchField.tag];
    
    if ([searchField.stringValue isEqualToString:@""])
        [self setDisplayedSources:[[dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] mutableCopy]];
    else
        [self setDisplayedSources:[[dataStore getAllLibraryObjectsForAttributeName:attrName
                                                                WithAttributeValue:searchField.stringValue
                                                                         FromTable:[SourceConstants tableName]] mutableCopy]];
}

@end
