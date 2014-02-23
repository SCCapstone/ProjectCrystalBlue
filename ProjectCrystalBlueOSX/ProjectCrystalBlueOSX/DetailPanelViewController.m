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
    NSMutableString *infoString = [[NSMutableString alloc] init];
    for (NSString *attribute in libraryObject.attributes.allKeys) {
        NSString *attributeVal = [libraryObject.attributes objectForKey:attribute];
        [infoString appendFormat:@"%@: %@\n", attribute, attributeVal];
    }
    [self.objectInfoLabel setStringValue:infoString];
}

-(void)clear
{
    self.objectInfoLabel.stringValue = @"No object selected";
}

@end
