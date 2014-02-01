//
//  LibraryView.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/20/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "LibraryView.h"
#import "ChildrenView.h"
#import "SourceStore.h"

@interface LibraryView ()

@end

@implementation LibraryView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (IBAction)viewChildren:(id)sender
{
    //ChildrenView *c = [[ChildrenView alloc] init];
    //[c showWindow:self];
    SourceStore *store = [[SourceStore alloc] init];
    [store setupZumero];
    [store insertObject];
    [store synchronize];
}
@end
