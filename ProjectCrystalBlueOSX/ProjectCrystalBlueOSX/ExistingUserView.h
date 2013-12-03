//
//  ExistingUserView.h
//  ProjectCrystalBlueOSX
//
//  This is the view for an existing user to log-in with their Zumero credentials.
//
//  Created by Logan Hood on 11/5/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewSelector.h"

@interface ExistingUserView : NSViewController

@property (weak) ViewSelector *viewSelector;

- (id)initWithNibNameAndViewSelector:(NSString *)nibNameOrNil
                              bundle:(NSBundle *)nibBundleOrNil
                        viewSelector:(ViewSelector *)viewSelectorSelf;

@end