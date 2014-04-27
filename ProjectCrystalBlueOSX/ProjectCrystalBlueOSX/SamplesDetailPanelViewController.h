//
//  SamplesDetailPanelViewController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Sample, AbstractCloudLibraryObjectStore, SamplesTableViewController;

@interface SamplesDetailPanelViewController : NSViewController <NSComboBoxDataSource, NSTextViewDelegate>

@property (weak) IBOutlet NSTextField *googleMapsLink;
@property (weak) IBOutlet NSDatePicker *datePicker;
@property (weak) IBOutlet NSComboBox *rockTypeComboBox;
@property (weak) IBOutlet NSComboBox *lithologyComboBox;
@property (weak) IBOutlet NSComboBox *ageMethodComboBox;
@property (weak) IBOutlet NSComboBox *deposystemComboBox;
@property (weak) IBOutlet NSImageCell *imageCell;
@property (unsafe_unretained) IBOutlet NSTextView *hyperlinksTextView;

@property (nonatomic) Sample *sample;
@property (nonatomic) NSDate *dateCollected;
@property AbstractCloudLibraryObjectStore *dataStore;

@end
