//
//  LibraryView.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "LibraryView.h"

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

- (IBAction)addSample:(id)sender {
    NSString *rockType = [[_rockTypeField selectedCell] title];
    int rockId = [_rockIdField intValue];
    NSString *coordinates = [_coordinatesField stringValue];
    bool isPulverized = [[[_pulverizedField selectedCell] title] isEqualToString:@"Yes"];
    
    Sample *sample = [[Sample alloc] initWithRockType:rockType
                                            AndRockId:rockId
                                       AndCoordinates:coordinates
                                      AndIsPulverized:isPulverized];
    [_arrayController addObject:sample];
}

- (IBAction)deleteSample:(id)sender {
    NSInteger index = [_tableView selectedRow];
    [_arrayController removeObjectAtArrangedObjectIndex:index];
}

- (IBAction)cloneSample:(id)sender {
    NSInteger index = [_tableView selectedRow];
    Sample *sample = [sampleLibrary objectAtIndex:index];
    [_arrayController addObject:sample];
}



- (void)setSampleLibrary:(NSMutableArray *) library {
    if (library == sampleLibrary) {
        return;
    }
    
    sampleLibrary = library;
}

@end
