//
//  SourcePhotosWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Source;

/**
 *  Controller for a window to display, add, and delete photos for a 
 *  single Source.
 */
@interface SourcePhotosWindowController : NSWindowController

@property Source *source;
@property NSUInteger currentPhotoIndex;
@property NSArray *photoKeys;
@property NSMutableDictionary *loadedPhotos;

@property (weak) IBOutlet NSPopUpButton *imageSelectionPopupButton;
@property (weak) IBOutlet NSTextField *currentImageKey;
@property (weak) IBOutlet NSImageView *currentImageDisplay;
@property (weak) IBOutlet NSButton *previousButton;
@property (weak) IBOutlet NSButton *nextButton;

- (IBAction)addPhoto:(id)sender;
- (IBAction)removePhoto:(id)sender;

- (IBAction)previousPhoto:(id)sender;
- (IBAction)nextPhoto:(id)sender;


@end
