//
//  ViewSelector.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 11/5/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

/* Class for handling transitions between NSViewControllers throughout the application.
 * This should be a singleton class attached to the MainMenu.xib.
 */

#import "ViewSelector.h"
#import "NewOrExistingUserView.h"

@implementation ViewSelector

@synthesize currentView = _currentView;
@synthesize currentViewController = _currentViewController;

// Names of all the .xib files for each view in the application.
NSString* const NEW_OR_EXISTING_USER_VIEW = @"NewOrExistingUserView";

// The view that will be loaded at startup.
NSString* const STARTUP_VIEW = @"NewOrExistingUserView";

- (void)awakeFromNib {
    [self setViewController:STARTUP_VIEW];
}

- (IBAction)setView:(id)sender {
    NSString* buttonId = [sender identifier];
    [self setViewController:buttonId];
}

- (void)setViewController:(NSString* const)identifier {
    [[_currentViewController view] removeFromSuperview];
    
    if ([NEW_OR_EXISTING_USER_VIEW isEqualToString:(identifier)]) {
        self.currentViewController = [[NewOrExistingUserView alloc]
                                      initWithNibName:identifier
                                      bundle:nil];
    }
    
    
    [_currentView addSubview:[_currentViewController view]];
    [[_currentViewController view] setFrame:[_currentView bounds]];
}
@end
