//
//  SourcesWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SourcesWindowController : NSWindowController <NSSplitViewDelegate>

@property (weak) IBOutlet NSSplitView *splitView;

@end
