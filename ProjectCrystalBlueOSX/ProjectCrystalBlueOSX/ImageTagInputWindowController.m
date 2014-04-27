//
//  ImageTagInputWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/27/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ImageTagInputWindowController.h"
#import "LoadingSheet.h"
#import "ImagesFieldValidator.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface ImageTagInputWindowController ()

@end

@implementation ImageTagInputWindowController

#pragma mark - NSWindowController
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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - OSXFileSelectorDelegate
-(void)fileSelectorDidOpenFileAtURL:(NSURL *)fileURL {
    LoadingSheet *importing = [[LoadingSheet alloc] init];
    [importing activateSheetWithParentWindow:self.window
                                   AndText:@"Importing image. Please wait!"];

    NSString *filename = [[fileURL lastPathComponent] stringByDeletingPathExtension];
    [self.imageTagField setStringValue:filename];

    self.imageToUpload = [[NSImage alloc] initWithData:[NSData dataWithContentsOfURL:fileURL]];
    [self.imageView setImage:self.imageToUpload];

    [importing closeSheet];
}

#pragma mark - IBActions
- (IBAction)cancelButtonPressed:(id)sender {
    [self.window close];
}

- (IBAction)uploadButtonPressed:(id)sender {
    ValidationResponse *validation = [ImagesFieldValidator validateImageTag:self.imageTagField.stringValue];
    if (!validation.isValid) {
        NSAlert *validationInfo = [validation alertWithFieldName:@"Image Tag" fieldValue:self.imageTagField.stringValue];
        [validationInfo runModal];
        return;
    }

    if (nil == self.imageUploadHandler) {
        DDLogWarn(@"%s - imageUploadHandler not set!", __PRETTY_FUNCTION__);
    } else {
        [self.imageUploadHandler setTag:self.imageTagField.stringValue];
        [self.imageUploadHandler performSelectorInBackground:@selector(uploadImage:) withObject:self.imageToUpload];
    }
    [self.window close];
}
@end
