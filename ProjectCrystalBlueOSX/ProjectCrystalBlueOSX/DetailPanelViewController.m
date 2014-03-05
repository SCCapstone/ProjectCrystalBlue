//
//  DetailPanelViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/23/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "DetailPanelViewController.h"

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
    NSMutableString *attributeLabels = [[NSMutableString alloc] init];
    NSMutableString *attributeValues = [[NSMutableString alloc] init];
    for (NSString *attribute in libraryObject.attributes.allKeys) {
        NSString *attributeLabel = [SourceConstants humanReadableLabelForAttribute:attribute];
        NSString *attributeVal = [libraryObject.attributes objectForKey:attribute];
        [attributeLabels appendFormat:@"%@: \n", attributeLabel];
        [attributeValues appendFormat:@" %@\n", attributeVal];
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
