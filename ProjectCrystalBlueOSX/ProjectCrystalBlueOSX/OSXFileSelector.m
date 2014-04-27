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

+(OSXFileSelector *)ImageFileSelector
{
    OSXFileSelector *imageSelector = [[OSXFileSelector alloc] init];
    [imageSelector setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"JPG", @"jpg",
                                                                        @"JPEG", @"jpeg",
                                                                        @"PNG", @"png",
                                                                        nil]];
    return imageSelector;
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
            NSURL *url = panel.URL;
            if (delegate) {
                [delegate performSelectorInBackground:@selector(fileSelectorDidOpenFileAtURL:) withObject:url];
            } else {
                DDLogWarn(@"%@: User selected file %@, but no delegate was set.",
                          NSStringFromClass(self.class), url);
            }
        }
    }];
}

@end