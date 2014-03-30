//
//  SourcesDetailPanelViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Source, AbstractCloudLibraryObjectStore;

@interface SourcesDetailPanelViewController : NSViewController

@property (nonatomic) Source *source;
@property AbstractCloudLibraryObjectStore *dataStore;
@property (weak) IBOutlet NSTextField *googleMapsLink;
@property (weak) IBOutlet NSDatePicker *datePicker;
@property (nonatomic) NSDate *dateCollected;

@end
