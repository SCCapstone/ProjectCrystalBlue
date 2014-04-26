//
//  SamplesDeleteController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SamplesTableViewController;

/// A class to handle deletion of many samples. Should only be called from within the
/// SamplesWindowController.
@interface SamplesDeleteController : NSObject

/** Displays a dialog to the user to confirm deleting the specified samples.
 *  If the user chooses YES, then the samples will be deleted.
 *  Returns YES or NO reflecting whether the samples were deleted.
 */
- (BOOL)presentDeletionDialogInWindow:(NSWindow *)window
                      toDeleteSamples:(NSArray *)samples
              fromTableViewController:(SamplesTableViewController *)controller;

@end