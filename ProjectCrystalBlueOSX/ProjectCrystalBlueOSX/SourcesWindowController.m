//
//  SourcesWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesWindowController.h"
#import "SourcesTableViewController.h"

@interface SourcesWindowController ()
{
    SourcesTableViewController *tableViewController;
    enum subviews { tableSubview, detailPanelSubview };
}

@end

@implementation SourcesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
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

@end
