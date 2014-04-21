//
//  LoadingSheet.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 4/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LoadingSheet : NSObject

@property (assign) IBOutlet NSWindow *sheet;
@property (weak) IBOutlet NSTextField *loadingText;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;


- (void)activateSheetWithParentWindow:(NSWindow *)parentWindow
                              AndText:(NSString *)loadingText;
- (void)closeSheet;

@end
