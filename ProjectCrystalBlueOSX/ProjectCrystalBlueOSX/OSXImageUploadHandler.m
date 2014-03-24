//
//  OSXImageUploadHandler.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "OSXImageUploadHandler.h"
#import "AbstractImageStore.h"

@implementation OSXImageUploadHandler

@synthesize imageStore;
@synthesize key;

-(void)fileSelector:(id)selector
  didOpenFileAtPath:(NSString *)filePath
{
    // Make sure properties are correctly set
    if (!key || !imageStore)
    {
        [NSException raise:@"Null properties"
                    format:@"The key and imagestore properties must be set!"];
        return;
    }

    NSImage *imageToUpload = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];

    [imageStore putImage:imageToUpload forKey:key];
}

@end
