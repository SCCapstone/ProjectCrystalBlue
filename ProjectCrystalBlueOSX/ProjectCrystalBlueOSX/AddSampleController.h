//
//  NewSampleController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sample.h"

@interface AddSampleController : NSObject

@property (weak) IBOutlet NSTextField *addSampleIdentifier;
@property (weak) IBOutlet NSMatrix *addSampleRockType;
@property (weak) IBOutlet NSTextField *addSampleCoordinates;
@property (weak) IBOutlet NSMatrix *addSamplePulverized;
@property (weak) IBOutlet NSArrayController *arrayController;

- (IBAction)addSample:(id)sender;

@end
