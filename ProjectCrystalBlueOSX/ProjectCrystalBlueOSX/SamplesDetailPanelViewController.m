//
//  SamplesDetailPanelViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesDetailPanelViewController.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "Sample.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SamplesDetailPanelViewController ()

@end

@implementation SamplesDetailPanelViewController

@synthesize dataStore, sample;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setSample:(Sample *)newSample
{
    if (sample != nil)
        [self removeObserversFromSelectedSample];
    
    sample = newSample;
    [self addObserversToSelectedSample];
}

- (void)addObserversToSelectedSample
{
    NSArray *attributes = [SampleConstants attributeNames];
    for (NSString *attr in attributes) {
        [sample addObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.%@", attr] options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObserversFromSelectedSample
{
    NSArray *attributes = [SampleConstants attributeNames];
    for (NSString *attr in attributes) {
        [sample removeObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.%@", attr]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [dataStore updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
}

@end
