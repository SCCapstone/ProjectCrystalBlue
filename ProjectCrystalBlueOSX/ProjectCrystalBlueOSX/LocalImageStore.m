//
//  LocalImageStore.m
//  ProjectCrystalBlueOSX
//
//  Handles local image storage for a CloudImageStore.
//  This should not be used directly by any class other than a CloudImageStore implementation.
//
//  Created by Logan Hood on 1/28/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "LocalImageStore.h"
#import "ImageUtils.h"

@implementation LocalImageStore

NSString *const imageDirectoryName = @"ProjectCrystalBlueImages";
BOOL directoryCheck = NO;

+(void)checkDirectoryExists
{
    if (directoryCheck) {
        return;
    }
    
    BOOL imgDirectoryExists;
    [[NSFileManager defaultManager] fileExistsAtPath:[self.class localDirectory] isDirectory:&imgDirectoryExists];
    
    if (!imgDirectoryExists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self.class localDirectory]
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        
    }
    
    directoryCheck = YES;
}

+(NSString *)localDirectory
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingFormat:@"/%@", imageDirectoryName];
}

+(NSImage *)getImageForKey:(NSString *)key
{
    if (!directoryCheck) {
        [self.class checkDirectoryExists];
    }
    
    if (![self.class imageExistsForKey:key]) {
        return nil;
    }
    
    NSString *expectedFileLocation = [[self.class localDirectory] stringByAppendingFormat:@"/%@", key];
    NSData *retrievedData = [NSData dataWithContentsOfFile:expectedFileLocation];
    NSImage *image = [[NSImage alloc] initWithData:retrievedData];
    
    if (!image) {
        return nil;
    }
    
    return image;
}

+(BOOL)imageExistsForKey:(NSString *)key
{
    if (!directoryCheck) {
        [self.class checkDirectoryExists];
    }
    
    NSString *path = [[self.class localDirectory] stringByAppendingFormat:@"/%@", key];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key
{
    if (!directoryCheck) {
        [self.class checkDirectoryExists];
    }
    
    NSData *imageData = [ImageUtils JPEGDataFromImage:image];
    
    NSString *path = [[self.class localDirectory] stringByAppendingFormat:@"/%@", key];
    BOOL success = [[NSFileManager defaultManager] createFileAtPath:path
                                                           contents:imageData
                                                         attributes:nil];
    if (success) {
        NSLog(@"Wrote %@ to %@", key, path);
    }
    
    return success;
}

+(BOOL)deleteImageWithKey:(NSString *)key
{
    if (!directoryCheck) {
        [self.class checkDirectoryExists];
    }
    
    if (![self.class imageExistsForKey:key]) {
        return NO;
    }
    
    NSString *path = [[self.class localDirectory] stringByAppendingFormat:@"/%@", key];
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path
                                                              error:nil];
    
    return success;
}

+(void)flushLocalImageStore
{
    if (!directoryCheck) {
        [self.class checkDirectoryExists];
    }
}

@end
