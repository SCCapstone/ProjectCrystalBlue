//
//  SamplesWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/3/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesWindowController.h"
#import "SampleConstants.h"
#import "Sample.h"
#import "Source.h"
#import "AbstractLibraryObjectStore.h"
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

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
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

- (IBAction)newBlankSample:(id)sender {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)deleteSample:(id)sender {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)performProcedure:(id)sender {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)importExport:(id)sender {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}
@end
