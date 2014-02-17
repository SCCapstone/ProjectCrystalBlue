//
//  SamplesViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesViewController.h"
#import "SampleConstants.h"
#import "Sample.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SamplesViewController ()

@end

@implementation SamplesViewController

@synthesize dataStore;
@synthesize source;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self addColumnsToSamplesTable];
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
        return [dataStore getAllSamplesForSource:source].count;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    if ([tableView isEqualTo:self.sampleTable]) {
        Sample *sample = [[dataStore getAllSamplesForSource:source] objectAtIndex:row];
        NSString *attributeKey = [[tableColumn headerCell] stringValue];
        return [[sample attributes] objectForKey:attributeKey];
    }
    return nil;
}

@end
