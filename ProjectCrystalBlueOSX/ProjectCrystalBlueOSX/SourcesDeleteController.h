//
//  SourcesDeleteController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SourcesTableViewController;

/// A class to handle deletion of many sources. Should only be called from within the
/// SourcesWindowController.
@interface SourcesDeleteController : NSObject

/** Displays a dialog to the user to confirm deleting the specified sources.
 *  If the user chooses YES, then the sources will be deleted.
 *  Returns YES or NO reflecting whether the sources were deleted.
 */
- (BOOL)presentDeletionDialogInWindow:(NSWindow *)window
                      toDeleteSources:(NSArray *)sources
              fromTableViewController:(SourcesTableViewController *)controller;

@end