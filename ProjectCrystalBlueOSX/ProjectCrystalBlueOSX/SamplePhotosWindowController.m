//
//  SamplePhotosWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplePhotosWindowController.h"
#import "Sample.h"
#import "SampleImageUtils.h"
#import "OSXFileSelector.h"
#import "OSXImageUploadHandler.h"
#import "ImageTagInputWindowController.h"
#import "PCBLogWrapper.h"

@interface SamplePhotosWindowController ()

@end

@implementation SamplePhotosWindowController {
    NSWindowController *imageTagInputWindowController;
}

@synthesize sample;
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
    [self.window setTitle:[NSString stringWithFormat:@"Photos for %@", sample.key]];
    currentPhotoIndex = 0;

    [self reloadImageKeys];
}

- (void)reloadImageKeys
{
    [imageSelectionPopupButton removeAllItems];
    [currentImageDisplay setImage:nil];
    imageKeys = [SampleImageUtils imageKeysForSample:sample];
    currentPhotoIndex = 0;

    if (imageKeys.count <= 0) {
        [currentImageKey setStringValue:@"No images yet!"];
        [self previousAndNextButtonsAreEnabled:NO];
        [imageSelectionPopupButton setEnabled:NO];
    } else {
        if (imageKeys.count <= 1) {
            [self previousAndNextButtonsAreEnabled:NO];
        } else {
            [self previousAndNextButtonsAreEnabled:YES];
        }
        [imageSelectionPopupButton setEnabled:YES];
        [imageSelectionPopupButton addItemsWithTitles:imageKeys];
        images = [SampleImageUtils imagesForSample:sample
                                      inImageStore:[SampleImageUtils defaultImageStore]];
        [self displayImageAtIndex:currentPhotoIndex];
    }
}

- (void)displayImageAtIndex:(NSUInteger)index {
    if (index >= imageKeys.count) {
        return;
    }

    [imageSelectionPopupButton selectItemAtIndex:index];
    [currentImageKey setStringValue:[imageKeys objectAtIndex:index]];
    [currentImageDisplay setImage:[images objectAtIndex:index]];
}

- (void)previousAndNextButtonsAreEnabled:(BOOL)areEnabled {
    const CGFloat alphaValue = areEnabled ? 1.0 : 0.0;

    [nextButton setEnabled:areEnabled];
    [nextButton setAlphaValue:alphaValue];
    [previousButton setEnabled:areEnabled];
    [previousButton setAlphaValue:alphaValue];
}

- (IBAction)addPhoto:(id)sender {
    imageTagInputWindowController = [[ImageTagInputWindowController alloc] initWithWindowNibName:@"ImageTagInputWindowController"];

    OSXImageUploadHandler *imageUploadHandler = [[OSXImageUploadHandler alloc] init];
    [imageUploadHandler setSample:sample];
    [imageUploadHandler setDataStore:dataStore];
    [imageUploadHandler setPhotosWindow:self];
    [(ImageTagInputWindowController *)imageTagInputWindowController setImageUploadHandler:imageUploadHandler];

    [imageTagInputWindowController showWindow:self];

    OSXFileSelector *imageSelector = [OSXFileSelector ImageFileSelector];
    [imageSelector setDelegate:(ImageTagInputWindowController *)imageTagInputWindowController];
    [imageSelector presentFileSelectorToUser];
}

- (IBAction)removePhoto:(id)sender {
    NSString *imageKeyToRemove = [imageKeys objectAtIndex:currentPhotoIndex];

    NSAlert *confirmation = [[NSAlert alloc] init];
    [confirmation setAlertStyle:NSWarningAlertStyle];

    NSString *message = [NSString stringWithFormat:@"Really delete %@?", imageKeyToRemove];
    [confirmation setMessageText:message];

    NSString *info = @"This image will be permanently deleted!";
    [confirmation setInformativeText:info];

    // If the order of buttons changes, the numerical constants below NEED to be swapped.
    [confirmation addButtonWithTitle:@"Delete"];
    short const DELETE_BUTTON = 1000;
    [confirmation addButtonWithTitle:@"Cancel"];
    short const CANCEL_BUTTON = 1001;

    [confirmation beginSheetModalForWindow:self.window
                         completionHandler:^(NSModalResponse returnCode) {
                             switch (returnCode) {
                                 case DELETE_BUTTON:
                                     [SampleImageUtils removeImage:imageKeyToRemove
                                                         forSample:sample
                                                       inDataStore:dataStore
                                                      inImageStore:[SampleImageUtils defaultImageStore]];
                                     break;
                                 case CANCEL_BUTTON:
                                     break;
                                 default:
                                     DDLogWarn(@"Unexpected return code %ld from DeleteSample Alert", (long)returnCode);
                                     break;
                             }
                             [self reloadImageKeys];
                         }];
}

- (IBAction)previousPhoto:(id)sender {
    if (currentPhotoIndex == 0) {
        currentPhotoIndex = imageKeys.count - 1;
    } else {
        currentPhotoIndex = (currentPhotoIndex - 1) % imageKeys.count;
    }
    [self displayImageAtIndex:currentPhotoIndex];
}

- (IBAction)nextPhoto:(id)sender {
    currentPhotoIndex = (currentPhotoIndex + 1) % imageKeys.count;
    [self displayImageAtIndex:currentPhotoIndex];
}

- (IBAction)popupSelectedPhoto:(id)sender {
    currentPhotoIndex = [imageSelectionPopupButton indexOfSelectedItem];
    [self displayImageAtIndex:currentPhotoIndex];
}

@end
