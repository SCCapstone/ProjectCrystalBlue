//
//  OSXImageUploadHandler.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "OSXImageUploadHandler.h"
#import "SourcePhotosWindowController.h"
#import "AbstractImageStore.h"
#import "SourceImageUtils.h"

@implementation OSXImageUploadHandler

@synthesize source;
@synthesize dataStore;
@synthesize tag;
@synthesize photosWindow;

-(void)fileSelector:(id)selector
  didOpenFileAtPath:(NSString *)filePath
{
    // Make sure properties are correctly set
    if (!source)
    {
        [NSException raise:@"Null properties"
                    format:@"The source and datastore property must be set!"];
        return;
    }

    NSImage *imageToUpload = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];

    [SourceImageUtils addImage:imageToUpload
                     forSource:source
                   inDataStore:dataStore
                  withImageTag:tag
                intoImageStore:[SourceImageUtils defaultImageStore]];

    if (photosWindow) {
        [photosWindow reloadImageKeys];
    }
}

@end
