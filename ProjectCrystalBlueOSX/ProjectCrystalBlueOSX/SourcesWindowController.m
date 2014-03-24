//
//  SourcesWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesWindowController.h"
#import "SourcesTableViewController.h"
#import "AddNewSourceWindowController.h"
#import "SamplesWindowController.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourcesWindowController ()
{
    SourcesTableViewController *tableViewController;
    enum subviews { tableSubview, detailPanelSubview };
    
    NSMutableArray *activeWindowControllers;
}

@end

@implementation SourcesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if (self) {
        activeWindowControllers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if (!tableViewController)
        tableViewController = [[SourcesTableViewController alloc] initWithNibName:@"SourcesTableViewController" bundle:nil];
    
    [self.splitView replaceSubview:[self.splitView.subviews objectAtIndex:tableSubview] with:tableViewController.view];
    CGFloat dividerPosition = [self.splitView maxPossiblePositionOfDividerAtIndex:0] - 250;
    [self.splitView setPosition:dividerPosition ofDividerAtIndex:0];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition
         ofSubviewAt:(NSInteger)dividerIndex
{
    return proposedMaximumPosition - 250;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if ([subview isEqual:[splitView.subviews objectAtIndex:detailPanelSubview]])
        return YES;
    else
        return NO;
}


/*  Toolbar actions
 */

- (void)openAddNewSourcesWindow:(id)sender
{
    DDLogDebug(@"%@: %s was called", NSStringFromClass(self.class), __PRETTY_FUNCTION__);
    
    AddNewSourceWindowController *addNewSourceWindowController = [[AddNewSourceWindowController alloc] initWithWindowNibName:@"AddNewSourceWindowController"];
    [addNewSourceWindowController setSourcesTableViewController:tableViewController];
    [addNewSourceWindowController showWindow:self];
    [activeWindowControllers addObject:addNewSourceWindowController];
}

@end
