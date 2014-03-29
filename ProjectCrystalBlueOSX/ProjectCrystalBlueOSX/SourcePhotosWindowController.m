//
//  SourcePhotosWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcePhotosWindowController.h"
#import "Source.h"
#import "SourceImageUtils.h"
#import "OSXFileSelector.h"
#import "OSXImageUploadHandler.h"

@interface SourcePhotosWindowController ()

@end

@implementation SourcePhotosWindowController

@synthesize source;
@synthesize currentPhotoIndex;
@synthesize currentImageDisplay;
@synthesize currentImageKey;
@synthesize nextButton;
@synthesize previousButton;

@synthesize imageSelectionPopupButton;
@synthesize photoKeys;
@synthesize loadedPhotos;

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
    [self.window setTitle:[NSString stringWithFormat:@"Photos for %@", source.key]];
    currentPhotoIndex = 0;

    [self reloadImageKeys];
}

/// Reloads the image keys for the source.
- (void)reloadImageKeys
{
    photoKeys = [SourceImageUtils imageKeysForSource:source];
    loadedPhotos = [[NSMutableDictionary alloc] initWithCapacity:photoKeys.count];

    if (photoKeys.count <= 0) {
        [currentImageKey setStringValue:@"No images yet!"];
        [nextButton setEnabled:NO];
        [previousButton setEnabled:NO];
        [imageSelectionPopupButton setEnabled:NO];
    }
}

- (IBAction)addPhoto:(id)sender {
}

- (IBAction)removePhoto:(id)sender {
}

- (IBAction)previousPhoto:(id)sender {
}

- (IBAction)nextPhoto:(id)sender {
}

@end
