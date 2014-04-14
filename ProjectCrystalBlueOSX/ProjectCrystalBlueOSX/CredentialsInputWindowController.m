//
//  CredentialsInputWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "CredentialsInputWindowController.h"
#import "LocalEncryptedCredentialsProvider.h"

@interface CredentialsInputWindowController ()

@end

NSString *firstTimeInstructions =
@"It appears this is your first time running the application on this Mac. Please enter your AWS\
  credentials below. You can obtain these credentials from your lab administrator. Please also\
  provide a local passcode - you will need to enter this passcode everytime you open the program.";

NSString *standardInstructions =
@"Please enter your local passcode to obtain AWS Credentials.";

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
    [self.window makeKeyAndOrderFront:self];
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
        [self.window close];
    }
}
@end
