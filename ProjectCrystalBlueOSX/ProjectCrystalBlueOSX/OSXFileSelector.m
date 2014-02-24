//
//  OSXFileSelector.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/20/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "OSXFileSelector.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation OSXFileSelector

@synthesize allowedFileTypes;
@synthesize delegate;

+(OSXFileSelector *)CSVFileSelector
{
    OSXFileSelector *csvFileSelector = [[OSXFileSelector alloc] init];
    [csvFileSelector setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"CSV", @"csv", nil]];
    return csvFileSelector;
}

-(void)presentFileSelectorToUser
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = NO;
    panel.canChooseFiles = YES;
    panel.allowsMultipleSelection = NO;
    if (nil != allowedFileTypes && allowedFileTypes.count > 0) {
        [panel setAllowedFileTypes:allowedFileTypes];
    }
    
    [panel beginWithCompletionHandler:^(NSInteger result)
    {
        if (result == NSFileHandlingPanelOKButton) {
            NSString *path = [panel.URL.path description];
            if (delegate) {
                [delegate fileSelector:self didOpenFileAtPath:path];
            } else {
                DDLogWarn(@"%@: User selected file %@, but no delegate was set.",
                          NSStringFromClass(self.class), path);
            }
        }
    }];
}

@end