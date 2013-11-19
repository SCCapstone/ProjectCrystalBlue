//
//  LibraryView.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "LibraryView.h"

@interface LibraryView ()

@end

@implementation LibraryView

- (id)initWithNibNameAndViewSelector:(NSString *)nibNameOrNil
                              bundle:(NSBundle *)nibBundleOrNil
                        viewSelector:(ViewSelector *)viewSelectorSelf
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sampleLibrary = [[NSMutableArray alloc] init];
        [sampleLibrary addObject:[[Sample alloc] init]];
        self.viewSelector = viewSelectorSelf;
    }
    return self;
}

- (void)setSampleLibrary:(NSMutableArray *) library {
    if (library == sampleLibrary) {
        return;
    }
    
    sampleLibrary = library;
}

@end
