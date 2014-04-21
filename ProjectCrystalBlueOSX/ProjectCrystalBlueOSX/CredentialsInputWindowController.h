//
//  CredentialsInputWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LocalEncryptedCredentialsProvider, AbstractCloudLibraryObjectStore;

@interface CredentialsInputWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *awsAccessKeyField;
@property (weak) IBOutlet NSTextField *awsSecretKeyField;
@property (weak) IBOutlet NSTextField *localKeyField;
@property (weak) IBOutlet NSTextField *instructionsDisplay;
@property AbstractCloudLibraryObjectStore *dataStore;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)okButtonPressed:(id)sender;

@end
