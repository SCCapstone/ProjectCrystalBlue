//
//  LibraryView.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewSelector.h"
#import "Sample.h"
#import "SQLiteWrapper.h"

@interface LibraryView : NSViewController {
    NSMutableArray *sampleLibrary;
    SQLiteWrapper *database;
}

@property (weak) ViewSelector *viewSelector;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *rockIdField;
@property (weak) IBOutlet NSMatrix *rockTypeField;
@property (weak) IBOutlet NSTextField *coordinatesField;
@property (weak) IBOutlet NSMatrix *pulverizedField;


- (id)initWithNibNameAndViewSelector:(NSString *)nibNameOrNil
                              bundle:(NSBundle *)nibBundleOrNil
                        viewSelector:(ViewSelector *)viewSelectorSelf;
- (IBAction)addSample:(id)sender;
- (IBAction)deleteSample:(id)sender;
- (IBAction)cloneSample:(id)sender;


@end
