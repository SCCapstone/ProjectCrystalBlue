//
//  SourcesTableViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesTableViewController.h"
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

@synthesize displayedSources, tableView, searchField, dataStore;

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
        [self setDisplayedSources:[[self.dataStore getAllLibraryObjectsFromTable:[SourceConstants tableName]] mutableCopy]];
    else
        [self setDisplayedSources:[[self.dataStore getAllLibraryObjectsForAttributeName:attrName
                                                             WithAttributeValue:searchField.stringValue
                                                                      FromTable:[SourceConstants tableName]] mutableCopy]];
}

@end
