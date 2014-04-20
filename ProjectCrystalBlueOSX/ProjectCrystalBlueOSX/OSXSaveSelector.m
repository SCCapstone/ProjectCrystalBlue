//
//  OSXSaveSelector.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/24/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "OSXSaveSelector.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation OSXSaveSelector

@synthesize delegate;

-(void)presentSaveSelectorToUser
{
    NSSavePanel *savePanel = [[NSSavePanel alloc] init];
    [savePanel setCanCreateDirectories:YES];
    [savePanel setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"csv", @"CSV", @"txt", @"TXT", nil]];
    
    [savePanel beginWithCompletionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton) {
             NSString *path = [savePanel.URL.path description];
             if (delegate) {
                 [delegate saveSelector:self choseSavePath:path];
             } else {
                 DDLogWarn(@"%@: User selected file %@, but no delegate was set.",
                           NSStringFromClass(self.class), path);
             }
         }
     }];
}


@end
