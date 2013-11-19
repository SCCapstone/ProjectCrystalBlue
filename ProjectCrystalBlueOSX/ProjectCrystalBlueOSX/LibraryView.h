//
//  LibraryView.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewSelector.h"
#import "Sample.h"

@interface LibraryView : NSViewController {
    NSMutableArray *sampleLibrary;
}

@property (weak) ViewSelector *viewSelector;

- (id)initWithNibNameAndViewSelector:(NSString *)nibNameOrNil
                              bundle:(NSBundle *)nibBundleOrNil
                        viewSelector:(ViewSelector *)viewSelectorSelf;
@end
