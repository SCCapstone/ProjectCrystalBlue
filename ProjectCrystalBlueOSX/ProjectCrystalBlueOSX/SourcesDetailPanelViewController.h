//
//  SourcesDetailPanelViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Source, AbstractCloudLibraryObjectStore, SourcesTableViewController;

@interface SourcesDetailPanelViewController : NSViewController

@property (nonatomic) Source *source;
@property (nonatomic) NSDate *dateCollected;
@property AbstractCloudLibraryObjectStore *dataStore;
@property SourcesTableViewController *tableViewController;
@property (weak) IBOutlet NSTextField *googleMapsLink;
@property (weak) IBOutlet NSDatePicker *datePicker;
@property (weak) IBOutlet NSComboBox *rockTypeComboBox;
@property (weak) IBOutlet NSComboBox *lithologyComboBox;
@property (weak) IBOutlet NSComboBox *ageMethodComboBox;
@property (weak) IBOutlet NSComboBox *deposystemComboBox;

@end
