//
//  ImageUtils.m
//  ProjectCrystalBlueOSX
//
//  Some helper methods for handling images.
//
//  Created by Logan Hood on 1/28/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "ImageUtils.h"
#import "PCBLogWrapper.h"

@implementation ImageUtils

float const DEFAULT_JPEG_COMPRESSION = 0.90f;

+(NSData *)JPEGDataFromImage:(NSImage *)image
{
    return [self.class JPEGDataFromImage:image withCompression:DEFAULT_JPEG_COMPRESSION];
}

+(NSData *)JPEGDataFromImage:(NSImage *)image
             withCompression:(float)compressionFactor
{
    NSArray *representations = [image representations];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:compressionFactor]
                                                           forKey:NSImageCompressionFactor];
    NSData *imageJPEGData = [NSBitmapImageRep representationOfImageRepsInArray:representations
                                                                     usingType:NSJPEGFileType properties:imageProps];
    
    return imageJPEGData;
}

@end
