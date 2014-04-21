//
//  CredentialsInputWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "CredentialsInputWindowController.h"
#import "LocalEncryptedCredentialsProvider.h"
#import "SimpleDBLibraryObjectStore.h"

@interface CredentialsInputWindowController ()

@end

NSString *firstTimeInstructions =
@"It appears this is your first time running the application on this Mac. Please enter your AWS\
  credentials below. You can obtain these credentials from your lab administrator. Please also\
  provide a local passcode - you will need to enter this passcode everytime you open the program.\n\
  \nIf you do not wish to utilize the cloud syncing functionality, you can skip this step and run\
  the program locally.";

NSString *standardInstructions =
@"Please enter your local passcode to obtain saved AWS Credentials, or enter new AWS credentials\
  and a new local passcode to overwrite the saved credentials file.";

NSString *passwordError =
@"Couldn't retrieve credentials. Did you enter an incorrect passcode?";

@implementation CredentialsInputWindowController

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
    if ([[LocalEncryptedCredentialsProvider sharedInstance] credentialsStoreFileExists]) {
        [self.instructionsDisplay setStringValue:standardInstructions];
    } else {
        [self.instructionsDisplay setStringValue:firstTimeInstructions];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.window close];
}

- (IBAction)okButtonPressed:(id)sender {
    if (self.awsAccessKeyField.stringValue.length > 0 &&
        self.awsSecretKeyField.stringValue.length > 0)
    {
        AmazonCredentials *credentials;
        credentials = [[AmazonCredentials alloc] initWithAccessKey:self.awsAccessKeyField.stringValue
                                                     withSecretKey:self.awsSecretKeyField.stringValue];
        [[LocalEncryptedCredentialsProvider sharedInstance] storeCredentials:credentials
                                                                     withKey:self.localKeyField.stringValue];
    }
    AmazonCredentials *retrieved;
    retrieved = [[LocalEncryptedCredentialsProvider sharedInstance] retrieveCredentialsWithKey:self.localKeyField.stringValue];
    if (retrieved) {
        [self.dataStore setupDomains];
        [self.window close];
    } else {
        [self.instructionsDisplay setStringValue:passwordError];
        [self.instructionsDisplay setTextColor:[NSColor orangeColor]];
    }
}
@end
