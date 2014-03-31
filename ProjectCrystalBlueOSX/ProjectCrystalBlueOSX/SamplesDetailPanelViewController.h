//
//  SamplesDetailPanelViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Sample, AbstractCloudLibraryObjectStore;

@interface SamplesDetailPanelViewController : NSViewController

@property (weak) IBOutlet NSTextField *recentProceduresTextField;

@property (nonatomic) Sample *sample;
@property AbstractCloudLibraryObjectStore *dataStore;

@end
