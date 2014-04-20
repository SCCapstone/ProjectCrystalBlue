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
#import "ProcedureNameConstants.h"

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

- (void)awakeFromNib
{
    [self updateRecentProcedures];
}

- (void)setSample:(Sample *)newSample
{
    if (sample != nil)
        [self removeObserversFromSelectedSample];
    
    sample = newSample;
    
    if (sample != nil) {
        [self addObserversToSelectedSample];
        [self updateRecentProcedures];
    }
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
    NSArray *procedureList = [ProcedureRecordParser procedureRecordArrayFromList:[sample.attributes objectForKey:SMP_TAGS]];
    NSMutableString *history = [[NSMutableString alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 29;
    
    for (int i=(int)procedureList.count-1; i>=0; i--) {
        ProcedureRecord *procedure = [procedureList objectAtIndex:i];
        NSString *procedureName = [ProcedureNameConstants procedureNameForTag:procedure.tag];
        NSString *date = [formatter stringFromDate:procedure.date];
        
        [history appendFormat:@"\u2022\t%@ on %@ by %@\n", procedureName, date, procedure.initials];
    }
    
    [self.recentProceduresTextField setAttributedStringValue:[[NSAttributedString alloc] initWithString:history attributes:@{ NSParagraphStyleAttributeName:paragraphStyle }]];
}

@end
