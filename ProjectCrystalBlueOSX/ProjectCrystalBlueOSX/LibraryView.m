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
        database = [[SQLiteWrapper alloc] init];
        sampleLibrary = [database getSamples];
        _viewSelector = viewSelectorSelf;
    }
    return self;
}

- (IBAction)addSample:(id)sender {
    NSString *rockType = [[_rockTypeField selectedCell] title];
    NSInteger rockId = [_rockIdField intValue];
    NSString *coordinates = [_coordinatesField stringValue];
    bool isPulverized = [[[_pulverizedField selectedCell] title] isEqualToString:@"Yes"];
    
    Sample *sample = [[Sample alloc] initWithRockType:rockType
                                            AndRockId:rockId
                                       AndCoordinates:coordinates
                                      AndIsPulverized:isPulverized];
    if ([self canAddSampleToLibrary:sample]) {
        [_arrayController addObject:sample];
        [database insertSample:sample];
    }
}

- (IBAction)deleteSample:(id)sender {
    NSInteger index = [_tableView selectedRow];
    [_arrayController removeObjectAtArrangedObjectIndex:index];
    [database deleteSample: [sampleLibrary objectAtIndex:index]];
}

- (IBAction)cloneSample:(id)sender {
    NSInteger index = [_tableView selectedRow];
    Sample *sample = [[Sample alloc] initWithSample:[sampleLibrary objectAtIndex:index]];
    [sample setRockId:[self nextValidRockId:sample.rockId]];
    [_arrayController addObject:sample];
    [database insertSample:sample];
}

- (void)setSampleLibrary:(NSMutableArray *) library {
    if (library == sampleLibrary) {
        return;
    }
    
    sampleLibrary = library;
}

// Validates that a sample contains valid data and can be legally added to
// the sample library.
- (BOOL)canAddSampleToLibrary:(Sample *) sample {
    if ([sampleLibrary containsObject:sample]) {
        NSString* const duplicateInfo = @"You cannot add two samples with the same ID number.";

        NSAlert *alert = [NSAlert alertWithMessageText:@"Alert" defaultButton:@"Ok" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:duplicateInfo];
        [alert runModal];
        return NO;
    }
    // TODO: Check other fields.
    return YES;
}

// Returns the next available ID number greater than or equal to the provided one.
- (NSInteger)nextValidRockId:(NSInteger) rockId {
    Sample *tempSample = [[Sample alloc] initWithRockType:nil
                                                AndRockId:rockId
                                           AndCoordinates:nil
                                          AndIsPulverized:nil];
    while ([sampleLibrary containsObject:tempSample]) {
        [tempSample setRockId:tempSample.rockId+1];
    }
    return tempSample.rockId;
}

@end
