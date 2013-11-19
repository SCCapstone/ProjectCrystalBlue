//
//  NewOrExistingUserView.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 11/5/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "NewOrExistingUserView.h"

@interface NewOrExistingUserView ()

@end

@implementation NewOrExistingUserView

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

- (IBAction)onExistingUserClick:(id)sender {
    [self.viewSelector setView:sender];
}

- (IBAction)onNewUserClick:(id)sender {
    [self.viewSelector setView:sender];
}

@end