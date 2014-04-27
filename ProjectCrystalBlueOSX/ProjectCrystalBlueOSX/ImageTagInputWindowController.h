//
//  ImageTagInputWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/27/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OSXFileSelector.h"
#import "OSXImageUploadHandler.h"

@interface ImageTagInputWindowController : NSWindowController <OSXFileSelectorDelegate>

@property NSImage *imageToUpload;
@property OSXImageUploadHandler *imageUploadHandler;

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *imageTagField;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)uploadButtonPressed:(id)sender;

@end
