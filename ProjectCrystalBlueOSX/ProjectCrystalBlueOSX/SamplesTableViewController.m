//
//  SamplesTableViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesTableViewController.h"
#import "SamplesDetailPanelViewController.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "Source.h"
#import "Sample.h"
#import "Procedures.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SamplesTableViewController ()

@end

@implementation SamplesTableViewController

@synthesize dataStore, tableView, source, displayedSamples, arrayController, detailPanel, searchField;

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
        //[detailPanel clear];
        return;
    }
    
    Sample *sample = [arrayController.arrangedObjects objectAtIndex:selectedRow];
    [detailPanel setSample:sample];
}

- (void)addSample:(Sample *)sample
{
    [Procedures addFreshSample:sample inStore:dataStore];
    [self updateDisplayedSamples];
}

- (void)deleteSampleWithKey:(NSString *)key
{
    DDLogInfo(@"Deleting sample with key \"%@\"", key);
    [dataStore deleteLibraryObjectWithKey:key FromTable:[SampleConstants tableName]];
}

- (void)updateDisplayedSamples
{
    NSString *attrName = [[SourceConstants attributeNames] objectAtIndex:searchField.tag];
    
    if ([searchField.stringValue isEqualToString:@""])
        [self setDisplayedSamples:[[dataStore getAllSamplesForSourceKey:source.key] mutableCopy]];
    else
        [self setDisplayedSamples:[[dataStore getAllSamplesForSourceKey:source.key
                                                    AndForAttributeName:attrName
                                                     WithAttributeValue:searchField.stringValue] mutableCopy]];
}

@end
