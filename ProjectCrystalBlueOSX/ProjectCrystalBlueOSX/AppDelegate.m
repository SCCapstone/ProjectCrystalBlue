//
//  AppDelegate.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AppDelegate.h"
#import "SourcesWindowController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "DDFileLogger.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    NSDate *now = [[NSDate alloc] init];
    DDLogInfo(@"Launched app %@", now);
    
    if (!sourcesWindowController)
        sourcesWindowController = [[SourcesWindowController alloc] initWithWindowNibName:@"SourcesWindowController"];
    [sourcesWindowController showWindow:self];
}


@end
