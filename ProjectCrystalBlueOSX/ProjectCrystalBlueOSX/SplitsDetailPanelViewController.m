//
//  SplitsDetailPanelViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SplitsDetailPanelViewController.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "Split.h"
#import "ProcedureRecord.h"
#import "ProcedureRecordParser.h"
#import "ProcedureNameConstants.h"
#import "PCBLogWrapper.h"

@interface SplitsDetailPanelViewController ()

@end

@implementation SplitsDetailPanelViewController

@synthesize dataStore, split;

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

- (void)setSplit:(Split *)newSplit
{
    if (split != nil)
        [self removeObserversFromSelectedSplit];
    
    split = newSplit;
    
    if (split != nil) {
        [self addObserversToSelectedSplit];
        [self updateRecentProcedures];
    }
}

- (void)addObserversToSelectedSplit
{
    [split addObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.CURRENT_LOCATION"] options:NSKeyValueObservingOptionNew context:nil];
    [split addObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.TAGS"] options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserversFromSelectedSplit
{
    [split removeObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.CURRENT_LOCATION"]];
    [split removeObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.TAGS"]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSString *attr = [keyPath substringFromIndex:11];
    
    if ([attr isEqualToString:SPL_TAGS]) {
        [self updateRecentProcedures];
    }
    
    [dataStore updateLibraryObject:split IntoTable:[SplitConstants tableName]];
}

- (void)updateRecentProcedures
{
    NSArray *procedureList = [ProcedureRecordParser procedureRecordArrayFromList:[split.attributes objectForKey:SPL_TAGS]];
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
        
        if (i == procedureList.count-1) {
            NSString *lastProc = [NSString stringWithFormat:@"%@ on %@ by %@", procedureName, date, procedure.initials];
            [split.attributes setObject:lastProc forKey:SPL_LAST_PROC];
        }
    }
    
    [self.recentProceduresTextField setAttributedStringValue:[[NSAttributedString alloc] initWithString:history attributes:@{ NSParagraphStyleAttributeName:paragraphStyle }]];
}

@end
