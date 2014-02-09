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
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourcesViewController ()

@end

@implementation SourcesViewController

@synthesize sourcesStore;
@synthesize samplesStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Using local library object store for testing purposes right now - will switch to SimpleDB implementation eventually.
        LocalLibraryObjectStore *sources = [[LocalLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                                                WithDatabaseName:@"ProjectCrystalBlueSources"];
        [self setSourcesStore:sources];
        LocalLibraryObjectStore *samples = [[LocalLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                                                WithDatabaseName:@"ProjectCrystalBlueSamples"];
        [self setSamplesStore:samples];
        
        DDLogInfo(@"%@: Successfully initialized!", NSStringFromClass(self.class));
    }
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    if (!sourcesStore) {
        return 0;
    } else {
        return [[sourcesStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] count];
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    if ([tableView isEqualTo:self.sourceTable]) {
        Source *source = [[sourcesStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] objectAtIndex:row];
        return [source key];
    }
    return nil;
}

@end
