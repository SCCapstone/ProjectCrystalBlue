//
//  DetailPanelViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/23/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LibraryObject.h"
#import "Sample.h"
#import "Source.h"

@interface DetailPanelViewController : NSViewController

@property (weak) IBOutlet NSTextField *objectInfoLabel;
@property (weak) IBOutlet NSImageView *image;

-(void)displayInformationAboutLibraryObject:(LibraryObject *)libraryObject;
-(void)clear;

@end