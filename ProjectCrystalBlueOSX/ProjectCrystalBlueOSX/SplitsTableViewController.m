//
//  SplitsTableViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SplitsTableViewController.h"
#import "SplitsDetailPanelViewController.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "Sample.h"
#import "Split.h"
#import "Procedures.h"
#import "PCBLogWrapper.h"

@interface SplitsTableViewController ()

@end

@implementation SplitsTableViewController

@synthesize dataStore, tableView, sample, displayedSplits, arrayController, detailPanel, searchField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        displayedSplits = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self updateDisplayedSplits];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = [tableView selectedRow];
    if (selectedRow == -1) {
        [detailPanel setSplit:nil];
        return;
    }
    
    Split *split = [arrayController.arrangedObjects objectAtIndex:selectedRow];
    [detailPanel setSplit:split];
}

- (void)addSplit:(Split *)split
{
    [Procedures addFreshSplit:split inStore:dataStore];
    [self updateDisplayedSplits];
}

- (void)deleteSplitWithKey:(NSString *)key
{
    DDLogInfo(@"Deleting split with key \"%@\"", key);
    Split *split = (Split *)[dataStore getLibraryObjectForKey:key FromTable:[SplitConstants tableName]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DecrementSampleNotification"
                                                        object:self
                                                      userInfo:@{ @"sampleKey": [split sampleKey] }];
    
    [dataStore deleteLibraryObjectWithKey:key FromTable:[SplitConstants tableName]];
}

- (void)updateDisplayedSplits
{
    NSString *attrName = [[SampleConstants attributeNames] objectAtIndex:searchField.tag];
    
    if ([searchField.stringValue isEqualToString:@""])
        [self setDisplayedSplits:[[dataStore getAllSplitsForSampleKey:sample.key] mutableCopy]];
    else
        [self setDisplayedSplits:[[dataStore getAllSplitsForSampleKey:sample.key
                                                    AndForAttributeName:attrName
                                                     WithAttributeValue:searchField.stringValue] mutableCopy]];
}

@end
