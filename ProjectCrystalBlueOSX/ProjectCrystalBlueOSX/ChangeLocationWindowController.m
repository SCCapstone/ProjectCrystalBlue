//
//  ChangeLocationWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/5/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ChangeLocationWindowController.h"
#import "Sample.h"
#import "SampleConstants.h"
#import "AbstractLibraryObjectStore.h"
#import "SamplesWindowController.h"

@interface ChangeLocationWindowController ()

@end

@implementation ChangeLocationWindowController

@synthesize updatedLocation;
@synthesize currentLocation;
@synthesize sample;
@synthesize dataStore;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSString *location = [sample.attributes objectForKey:SMP_CURRENT_LOCATION];
    [currentLocation setStringValue:location];
}

- (IBAction)submit:(id)sender
{
    NSString *newLocation = [updatedLocation stringValue];
    [sample.attributes setValue:newLocation forKey:SMP_CURRENT_LOCATION];
    [dataStore updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
    [self.samplesWindow updateDisplayedSamples];
    [self.window close];
}

- (IBAction)cancel:(id)sender {
    [self.window close];
}
@end
