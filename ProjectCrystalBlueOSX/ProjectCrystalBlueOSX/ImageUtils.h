//
//  ImageUtils.h
//  ProjectCrystalBlueOSX
//
//  Some helper methods for handling images.
//
//  Created by Logan Hood on 1/28/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

/// Return a JPEG representation of the NSImage, using a default JPEG compression factor of 0.90
+(NSData *)JPEGDataFromImage:(NSImage *)image;

/// Return a JPEG representation of the NSImage, with a specified JPEG compression factor.
+(NSData *)JPEGDataFromImage:(NSImage *)image
             withCompression:(float)compressionFactor;

@end
