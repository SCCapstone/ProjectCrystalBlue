//
//  OSXImageUploadHandler.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "OSXImageUploadHandler.h"
#import "SamplePhotosWindowController.h"
#import "AbstractImageStore.h"
#import "LoadingSheet.h"
#import "SampleImageUtils.h"
#import "PCBLogWrapper.h"

@implementation OSXImageUploadHandler

@synthesize sample;
@synthesize dataStore;
@synthesize tag;
@synthesize photosWindow;

-(void)uploadImage:(NSImage *)imageToUpload
{
    // Make sure properties are correctly set
    if (!sample)
    {
        [NSException raise:@"Null properties"
                    format:@"The sample and datastore property must be set!"];
        return;
    }

    LoadingSheet *loading = [[LoadingSheet alloc] init];
    [loading activateSheetWithParentWindow:photosWindow.window
                                   AndText:@"Uploading image. Please wait!"];

    [SampleImageUtils addImage:imageToUpload
                     forSample:sample
                   inDataStore:dataStore
                  withImageTag:tag
                intoImageStore:[SampleImageUtils defaultImageStore]];

    if (photosWindow) {
        [photosWindow reloadImageKeys];
    }

    [loading closeSheet];
}

@end
