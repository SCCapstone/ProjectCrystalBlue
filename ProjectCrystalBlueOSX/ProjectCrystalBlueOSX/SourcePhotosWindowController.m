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
@synthesize dataStore;
@synthesize currentPhotoIndex;
@synthesize currentImageDisplay;
@synthesize currentImageKey;
@synthesize nextButton;
@synthesize previousButton;

@synthesize imageSelectionPopupButton;
@synthesize imageKeys;
@synthesize images;

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

- (void)reloadImageKeys
{
    imageKeys = [SourceImageUtils imageKeysForSource:source];
    currentPhotoIndex = 0;

    if (imageKeys.count <= 0) {
        [currentImageKey setStringValue:@"No images yet!"];
        [nextButton setEnabled:NO];
        [previousButton setEnabled:NO];
        [imageSelectionPopupButton setEnabled:NO];
    } else {
        [nextButton setEnabled:YES];
        [previousButton setEnabled:YES];
        [imageSelectionPopupButton setEnabled:YES];
        [imageSelectionPopupButton addItemsWithTitles:imageKeys];
        images = [SourceImageUtils imagesForSource:source
                                      inImageStore:[SourceImageUtils defaultImageStore]];
        [self displayImageAtIndex:currentPhotoIndex];
    }
}

- (void)displayImageAtIndex:(NSUInteger)index {
    if (index >= imageKeys.count) {
        return;
    }

    [currentImageKey setStringValue:[imageKeys objectAtIndex:index]];
    [currentImageDisplay setImage:[images objectAtIndex:index]];
}

- (IBAction)addPhoto:(id)sender {
    OSXFileSelector *imageSelector = [OSXFileSelector ImageFileSelector];
    OSXImageUploadHandler *imageUploadHandler = [[OSXImageUploadHandler alloc] init];

    [imageUploadHandler setSource:source];
    [imageUploadHandler setDataStore:dataStore];
    [imageUploadHandler setPhotosWindow:self];
    [imageSelector setDelegate:imageUploadHandler];
    [imageSelector presentFileSelectorToUser];
}

- (IBAction)removePhoto:(id)sender {

}

- (IBAction)previousPhoto:(id)sender {
    currentPhotoIndex = (currentPhotoIndex - 1) % imageKeys.count;
    [self displayImageAtIndex:currentPhotoIndex];
}

- (IBAction)nextPhoto:(id)sender {
    currentPhotoIndex = (currentPhotoIndex + 1) % imageKeys.count;
    [self displayImageAtIndex:currentPhotoIndex];
}

@end
