//
//  SourcesTableViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesTableViewController.h"
#import "Source.h"

@interface SourcesTableViewController ()
{
    
}
@end

@implementation SourcesTableViewController

@synthesize sources, tableView, arrayController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        sources = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)addSource:(Source *)source
{
    [arrayController addObject:source];
}

@end
