//
//  ExistingUserView.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 11/5/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "ExistingUserView.h"

@interface ExistingUserView ()

@end

@implementation ExistingUserView

- (id)initWithNibNameAndViewSelector:(NSString *)nibNameOrNil
                              bundle:(NSBundle *)nibBundleOrNil
                        viewSelector:(ViewSelector *)viewSelectorSelf
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewSelector = viewSelectorSelf;
    }
    return self;
}
- (IBAction)onClick:(id)sender {
    [self.viewSelector setView:sender];
}

@end
