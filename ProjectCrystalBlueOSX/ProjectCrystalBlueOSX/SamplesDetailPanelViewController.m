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
#import "ProcedureRecord.h"
#import "ProcedureRecordParser.h"
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
    [self updateRecentProcedures];
}

- (void)addObserversToSelectedSample
{
    [sample addObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.CURRENT_LOCATION"] options:NSKeyValueObservingOptionNew context:nil];
    [sample addObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.TAGS"] options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserversFromSelectedSample
{
    [sample removeObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.CURRENT_LOCATION"]];
    [sample removeObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.TAGS"]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSString *attr = [keyPath substringFromIndex:11];
    
    if ([attr isEqualToString:SMP_TAGS]) {
        [self updateRecentProcedures];
    }
    
    [dataStore updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
}

- (void)updateRecentProcedures
{
    NSArray *procedureList = [ProcedureRecordParser nameArrayFromRecordList:[sample.attributes objectForKey:SMP_TAGS]];
//    NSMutableString *history = [[NSMutableString alloc] init];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MM/dd/yy"];
//    for (ProcedureRecord *procedure in procedureList) {
//        NSString *date = [formatter stringFromDate:procedure.date];
//        [history appendString:[NSString stringWithFormat:@"%@ on %@ by %@", procedure.tag, date, procedure.initials]];
//    }
    NSString *history = [procedureList componentsJoinedByString:@"\n"];
    [self setRecentProcedures:history];
}

@end
