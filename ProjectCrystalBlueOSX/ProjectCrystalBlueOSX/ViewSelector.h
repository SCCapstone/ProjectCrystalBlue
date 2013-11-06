//
//  ViewSelector.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 11/5/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

/* Class for handling transitions between NSViewControllers throughout the application.
 * This should be a singleton class attached to the MainMenu.xib.
 */

#import <Foundation/Foundation.h>

@interface ViewSelector : NSObject

@property (weak) IBOutlet NSView *currentView;
@property (strong) NSViewController *currentViewController;

- (IBAction)setView:(id)sender;
- (void)setViewController:(const NSString*)tag;

@end
