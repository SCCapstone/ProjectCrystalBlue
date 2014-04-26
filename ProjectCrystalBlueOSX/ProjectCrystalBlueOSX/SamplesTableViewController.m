//
//  SamplesTableViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesTableViewController.h"
#import "SamplesDetailPanelViewController.h"
#import "Sample.h"
#import "Split.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SamplesTableViewController ()
{
    enum comboBoxTags { rockTypeTag, lithologyTag, deposystemTag, ageMethodTag };
}
@end

@implementation SamplesTableViewController

@synthesize displayedSamples, tableView, searchField, dataStore, detailPanel, arrayController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        displayedSamples = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self updateDisplayedSamples];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = [tableView selectedRow];
    if (selectedRow == -1) {
        [detailPanel setSample:nil];
        return;
    }
    
    Sample *sample = [arrayController.arrangedObjects objectAtIndex:selectedRow];
    [detailPanel setSample:sample];
    
    // Update the combo box values
    [self.lithologyComboBoxCell reloadData];
    [self.deposystemComboBoxCell reloadData];
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
        
        Sample *sample = [arrayController.arrangedObjects objectAtIndex:row];
        [datePicker setDateValue:[NSDate dateWithNaturalLanguageString:[sample.attributes objectForKey:SMP_DATE_COLLECTED]]];
        
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

- (NSInteger)numberOfItemsInComboBoxCell:(NSComboBoxCell *)comboBoxCell
{
    NSString *rockType = nil;
    if (tableView.selectedRow != -1)
        rockType = [((Sample *)[displayedSamples objectAtIndex:tableView.selectedRow]).attributes objectForKey:SMP_TYPE];
    
    if (comboBoxCell.tag == rockTypeTag)
        return [[SampleConstants rockTypes] count];
    else if (comboBoxCell.tag == lithologyTag) {
        NSArray *lithologies = [SampleConstants lithologiesForRockType:rockType];
        return lithologies == nil ? 0 : lithologies.count;
    }
    else if (comboBoxCell.tag == deposystemTag){
        NSArray *deposystems = [SampleConstants deposystemsForRockType:rockType];
        return deposystems == nil ? 0 : deposystems.count;
    }
    else if (comboBoxCell.tag == ageMethodTag)
        return [[SampleConstants ageMethods] count];
    else
        return 0;
}

- (id)comboBoxCell:(NSComboBoxCell *)comboBoxCell objectValueForItemAtIndex:(NSInteger)index
{
    NSString *rockType = nil;
    if (tableView.selectedRow != -1)
        rockType = [((Sample *)[displayedSamples objectAtIndex:tableView.selectedRow]).attributes objectForKey:SMP_TYPE];
    
    if (comboBoxCell.tag == rockTypeTag)
        return [[SampleConstants rockTypes] objectAtIndex:index];
    else if (comboBoxCell.tag == lithologyTag)
        return [[SampleConstants lithologiesForRockType:rockType] objectAtIndex:index];
    else if (comboBoxCell.tag == deposystemTag)
        return [[SampleConstants deposystemsForRockType:rockType] objectAtIndex:index];
    else if (comboBoxCell.tag == ageMethodTag)
        return [[SampleConstants ageMethods] objectAtIndex:index];
    else
        return nil;
}

- (NSString *)comboBoxCell:(NSComboBoxCell *)comboBoxCell completedString:(NSString *)enteredValue
{
    NSString *rockType = nil;
    if (tableView.selectedRow != -1)
        rockType = [((Sample *)[displayedSamples objectAtIndex:tableView.selectedRow]).attributes objectForKey:SMP_TYPE];
    
    NSArray *prefilledValues;
    if (comboBoxCell.tag == rockTypeTag)
        prefilledValues = [SampleConstants rockTypes];
    else if (comboBoxCell.tag == lithologyTag)
        prefilledValues = [SampleConstants lithologiesForRockType:rockType];
    else if (comboBoxCell.tag == deposystemTag)
        prefilledValues = [SampleConstants deposystemsForRockType:rockType];
    else if (comboBoxCell.tag == ageMethodTag)
        prefilledValues = [SampleConstants ageMethods];
    
    // Check if entered value is prefix of one of the prefilled values
    for (NSString *value in prefilledValues) {
        if ([value.lowercaseString hasPrefix:enteredValue.lowercaseString])
            return value;
    }
    return nil;
}

- (void)addSample:(Sample *)sample
{
    [dataStore putLibraryObject:sample IntoTable:[SampleConstants tableName]];
    [self updateDisplayedSamples];
    
    // We also need to add a starting split for this Sample.
    NSString *splitKey = [NSString stringWithFormat:@"%@.%03d", sample.key, 1];
    Split *split = [[Split alloc] initWithKey:splitKey
                               AndWithAttributes:[SplitConstants attributeNames]
                                       AndValues:[SplitConstants attributeDefaultValues]];
    [split.attributes setObject:sample.key forKey:SPL_SAMPLE_KEY];
    [dataStore putLibraryObject:split IntoTable:[SplitConstants tableName]];
}

- (void)deleteSampleWithKey:(NSString *)key
{
    DDLogInfo(@"Deleting sample with key \"%@\"", key);
    [dataStore deleteLibraryObjectWithKey:key FromTable:[SampleConstants tableName]];
}

- (void)updateDisplayedSamples
{
    NSString *attrName = [[SampleConstants attributeNames] objectAtIndex:searchField.tag];
    
    if ([searchField.stringValue isEqualToString:@""])
        [self setDisplayedSamples:[[dataStore getAllLibraryObjectsFromTable:[SampleConstants tableName]] mutableCopy]];
    else
        [self setDisplayedSamples:[[dataStore getAllLibraryObjectsForAttributeName:attrName
                                                                WithAttributeValue:searchField.stringValue
                                                                         FromTable:[SampleConstants tableName]] mutableCopy]];
}

@end
