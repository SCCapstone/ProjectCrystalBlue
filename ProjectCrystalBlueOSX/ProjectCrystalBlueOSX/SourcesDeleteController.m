//
//  SourcesDeleteController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesDeleteController.h"
#import "Source.h"
#import "SourcesTableViewController.h"
#import "LoadingSheet.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define kAlertTitleFormatString @"Really delete %lu source(s)?"
#define kAlertInfoString @"These source(s) will be permanently deleted from the database"
#define kLoadingSheetText @"Deleting sources. Please wait."
#define kMaxSourceKeysToDisplay 20
#define kDeleteButton 1000
#define kCancelButton 1001

@implementation SourcesDeleteController

- (BOOL)presentDeletionDialogInWindow:(NSWindow *)window
                      toDeleteSources:(NSArray *)sources
              fromTableViewController:(SourcesTableViewController *)controller
{
    NSAlert *confirmation = [self setupConfirmationAlertWithSources:sources];

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
                                         const double progressStepSize = 100.0 / (double)sources.count;
                                         for (Source *s in sources) {
                                             [controller deleteSourceWithKey:s.key];
                                             [loading.progressIndicator incrementBy:progressStepSize];
                                         }
                                         [loading closeSheet];
                                         [controller updateDisplayedSources];
                                     });

                                     didDelete = YES;
                                     break;
                                 }
                                 case kCancelButton:
                                     didDelete = NO;
                                     break;
                                 default:
                                     DDLogWarn(@"Unexpected return code %ld from DeleteSource Alert", (long)returnCode);
                                     break;
                             }
                         }];
    return didDelete;
}

/// Helper method to initialize an NSAlert to display a confirmation panel to the user.
- (NSAlert *)setupConfirmationAlertWithSources:(const NSArray *)sources
{
    NSAlert *confirmation = [[NSAlert alloc] init];
    [confirmation setAlertStyle:NSWarningAlertStyle];

    NSString *message = [NSString stringWithFormat:kAlertTitleFormatString,
                         sources.count];
    [confirmation setMessageText:message];

    NSMutableString *info = [NSMutableString stringWithString:kAlertInfoString];
    if (sources.count < kMaxSourceKeysToDisplay) {
        [info appendString:@":"];
        for (Source *s in sources) {
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
