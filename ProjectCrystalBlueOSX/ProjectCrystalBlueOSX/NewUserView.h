//
//  NewUserView.h
//  ProjectCrystalBlueOSX
//
//  This view displays instructions for how to set-up a new Zumero database.
//
//  Created by Logan Hood on 11/5/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewSelector.h"

@interface NewUserView : NSViewController

@property (weak) ViewSelector *viewSelector;

- (id)initWithNibNameAndViewSelector:(NSString *)nibNameOrNil
                              bundle:(NSBundle *)nibBundleOrNil
                        viewSelector:(ViewSelector *)viewSelectorSelf;

@end
