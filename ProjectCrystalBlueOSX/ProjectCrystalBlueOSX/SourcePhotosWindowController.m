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
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

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
    [imageSelectionPopupButton removeAllItems];
    [currentImageDisplay setImage:nil];
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

    [imageSelectionPopupButton selectItemAtIndex:index];
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
                                     [SourceImageUtils removeImage:imageKeyToRemove
                                                         forSource:source
                                                       inDataStore:dataStore
                                                      inImageStore:[SourceImageUtils defaultImageStore]];
                                     break;
                                 case CANCEL_BUTTON:
                                     break;
                                 default:
                                     DDLogWarn(@"Unexpected return code %ld from DeleteSource Alert", (long)returnCode);
                                     break;
                             }
                             [self reloadImageKeys];
                         }];
}

- (IBAction)previousPhoto:(id)sender {
    currentPhotoIndex = (currentPhotoIndex - 1) % imageKeys.count;
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