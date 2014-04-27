//
//  AppDelegate.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplesWindowController.h"
#import "FileSystemUtils.h"
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
    
    if (!samplesWindowController)
        samplesWindowController = [[SamplesWindowController alloc] initWithWindowNibName:@"SamplesWindowController"];
    [samplesWindowController showWindow:self];
}


- (IBAction)clearLocalDatabase:(id)sender
{
    [[NSFileManager defaultManager] removeItemAtPath:[FileSystemUtils localDataDirectory] error:nil];
    [NSApp terminate:nil];
}

- (IBAction)changeAmazonCredentials:(id)sender
{
    [samplesWindowController openCredentialsWindow];
}

- (IBAction)showImagesInFinder:(id)sender
{
    [[NSWorkspace sharedWorkspace] selectFile:[FileSystemUtils localImagesDirectory] inFileViewerRootedAtPath:@""];
}
@end
