//
//  SamplePhotosWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Sample;
@class AbstractLibraryObjectStore;

/**
 *  Controller for a window to display, add, and delete photos for a 
 *  single Sample.
 */
@interface SamplePhotosWindowController : NSWindowController

@property Sample *sample;
@property AbstractLibraryObjectStore *dataStore;

@property NSUInteger currentPhotoIndex;
@property NSArray *imageKeys;
@property NSArray *images;

@property (weak) IBOutlet NSPopUpButton *imageSelectionPopupButton;
@property (weak) IBOutlet NSTextField *currentImageKey;
@property (weak) IBOutlet NSImageView *currentImageDisplay;
@property (weak) IBOutlet NSButton *previousButton;
@property (weak) IBOutlet NSButton *nextButton;

- (IBAction)addPhoto:(id)sender;
- (IBAction)removePhoto:(id)sender;

- (IBAction)previousPhoto:(id)sender;
- (IBAction)nextPhoto:(id)sender;
- (IBAction)popupSelectedPhoto:(id)sender;

/// Reloads the image keys for the sample, for example after an image upload.
- (void)reloadImageKeys;

@end
