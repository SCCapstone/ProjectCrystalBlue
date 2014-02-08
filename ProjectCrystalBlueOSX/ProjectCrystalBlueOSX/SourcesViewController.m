//
//  SourcesViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesViewController.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourcesViewController ()

@end

@implementation SourcesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DDLogInfo(@"%@: Successfully initialized!", NSStringFromClass(self.class));
    }
    return self;
}

- (IBAction)theButton:(id)sender {
    DDLogError(@"%@: Fatal error: things are actually working as expected",
               NSStringFromClass(self.class));
}
@end
