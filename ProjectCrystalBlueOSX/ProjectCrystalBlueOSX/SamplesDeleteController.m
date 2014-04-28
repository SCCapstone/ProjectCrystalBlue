//
//  SamplesDeleteController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesDeleteController.h"
#import "Sample.h"
#import "SamplesTableViewController.h"
#import "LoadingSheet.h"
#import "PCBLogWrapper.h"

#define kAlertTitleFormatString @"Really delete %lu sample(s)?"
#define kAlertInfoString @"These sample(s) will be permanently deleted from the database"
#define kLoadingSheetText @"Deleting samples. Please wait."
#define kMaxSampleKeysToDisplay 20
#define kDeleteButton 1000
#define kCancelButton 1001

@implementation SamplesDeleteController

- (BOOL)presentDeletionDialogInWindow:(NSWindow *)window
                      toDeleteSamples:(NSArray *)samples
              fromTableViewController:(SamplesTableViewController *)controller
{
    NSAlert *confirmation = [self setupConfirmationAlertWithSamples:samples];

    __block BOOL didDelete = NO;
    [confirmation beginSheetModalForWindow:window
                         completionHandler:^(NSModalResponse returnCode) {
                             switch (returnCode) {
                                 case kDeleteButton: {
                                     LoadingSheet *loading = [[LoadingSheet alloc] init];
                                     [loading activateSheetWithParentWindow:window
                                                                    AndText:kLoadingSheetText];
                                     [loading.progressIndicator setIndeterminate:NO];

                                     dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                     dispatch_async(backgroundQueue, ^{
                                         const double progressStepSize = 100.0 / (double)samples.count;
                                         for (Sample *s in samples) {
                                             [controller deleteSampleWithKey:s.key];
                                             [loading.progressIndicator incrementBy:progressStepSize];
                                         }
                                         [loading closeSheet];
                                         [controller updateDisplayedSamples];
                                     });

                                     didDelete = YES;
                                     break;
                                 }
                                 case kCancelButton:
                                     didDelete = NO;
                                     break;
                                 default:
                                     DDLogWarn(@"Unexpected return code %ld from DeleteSample Alert", (long)returnCode);
                                     break;
                             }
                         }];
    return didDelete;
}

/// Helper method to initialize an NSAlert to display a confirmation panel to the user.
- (NSAlert *)setupConfirmationAlertWithSamples:(const NSArray *)samples
{
    NSAlert *confirmation = [[NSAlert alloc] init];
    [confirmation setAlertStyle:NSWarningAlertStyle];

    NSString *message = [NSString stringWithFormat:kAlertTitleFormatString,
                         samples.count];
    [confirmation setMessageText:message];

    NSMutableString *info = [NSMutableString stringWithString:kAlertInfoString];
    if (samples.count < kMaxSampleKeysToDisplay) {
        [info appendString:@":"];
        for (Sample *s in samples) {
            [info appendFormat:@"\n\t%@", s.key];
        }
    } else {
        [info appendString:@"!"];
    }
    [confirmation setInformativeText:info];

    [confirmation addButtonWithTitle:@"Delete"];
    [confirmation addButtonWithTitle:@"Cancel"];

    return confirmation;
}

@end
