//
//  DetailPanelViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/23/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "DetailPanelViewController.h"
#import "ProcedureRecordParser.h"

#define DISPLAYING_SOURCE 1
#define DISPLAYING_SAMPLE 2
#define DISPLAYING_OTHER -1

@interface DetailPanelViewController ()

@end

@implementation DetailPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    [self clear];
}

-(void)displayInformationAboutLibraryObject:(LibraryObject *)libraryObject
{
    NSUInteger kind = DISPLAYING_OTHER;
    if ([libraryObject isKindOfClass:[Source class]]) {
        kind = DISPLAYING_SOURCE;
    } else if ([libraryObject isKindOfClass:[Sample class]]) {
        kind = DISPLAYING_SAMPLE;
    }

    NSMutableString *attributeLabels = [[NSMutableString alloc] init];
    NSMutableString *attributeValues = [[NSMutableString alloc] init];
    for (NSString *attribute in libraryObject.attributes.allKeys) {
        NSString *attributeLabel;
        if (kind == DISPLAYING_SOURCE) {
            attributeLabel = [SourceConstants humanReadableLabelForAttribute:attribute];
        } else if (kind == DISPLAYING_SAMPLE) {
            attributeLabel = [SampleConstants humanReadableLabelForAttribute:attribute];
        } else {
            attributeLabel = attribute;
        }
        NSString *attributeVal = [libraryObject.attributes objectForKey:attribute];
        [attributeLabels appendFormat:@"%@: \n", attributeLabel];
        [attributeValues appendFormat:@" %@\n", attributeVal];
    }
    if (kind == DISPLAYING_SAMPLE) {
        NSString *mostRecent = [ProcedureRecordParser mostRecentProcedurePerformedOnSample:(Sample *)libraryObject];
        [attributeLabels appendFormat:@"\nMost Recent Procedure:\n"];
        [attributeValues appendFormat:@"\n %@\n", mostRecent];
    }

    [self.objectAttributeLabels setStringValue:attributeLabels];
    [self.objectAttributeValues setStringValue:attributeValues];
}

-(void)clear
{
    self.objectAttributeLabels.stringValue = @"No object selected";
    self.objectAttributeValues.stringValue = @"";
}

@end
