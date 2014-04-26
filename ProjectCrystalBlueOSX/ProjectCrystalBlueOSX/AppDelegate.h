//
//  AppDelegate.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SamplesWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    SamplesWindowController *samplesWindowController;
}

- (IBAction)clearLocalDatabase:(id)sender;
- (IBAction)showImagesInFinder:(id)sender;

@end
