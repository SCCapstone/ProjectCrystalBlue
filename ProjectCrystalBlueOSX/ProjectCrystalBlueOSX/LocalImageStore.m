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

-(id)initWithLocalDirectory:(NSString *)directory
{
    self = [super initWithLocalDirectory:directory];
    if (self) {
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectories objectAtIndex:0];
        localDirectory = [documentDirectory stringByAppendingFormat:@"/%@", directory];
        
        BOOL imgDirectoryExists;
        [[NSFileManager defaultManager] fileExistsAtPath:localDirectory isDirectory:&imgDirectoryExists];
        if (!imgDirectoryExists) {
            [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
    }
    return self;
}

-(NSImage *)getImageForKey:(NSString *)key
{
    if (![self imageExistsForKey:key]) {
        return nil;
    }
    
    NSString *expectedFileLocation = [localDirectory stringByAppendingFormat:@"/%@", key];
    NSData *retrievedData = [NSData dataWithContentsOfFile:expectedFileLocation];
    NSImage *image = [[NSImage alloc] initWithData:retrievedData];
    
    if (!image) {
        return nil;
    }
    
    return image;
}

-(BOOL)imageExistsForKey:(NSString *)key
{
    NSString *path = [localDirectory stringByAppendingFormat:@"/%@", key];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

-(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key
{
    NSData *imageData = [ImageUtils JPEGDataFromImage:image];
    
    NSString *path = [localDirectory stringByAppendingFormat:@"/%@", key];
    BOOL success = [[NSFileManager defaultManager] createFileAtPath:path
                                                           contents:imageData
                                                         attributes:nil];
    if (success) {
        NSLog(@"Wrote %@ to %@", key, path);
    }
    
    return success;
}

-(BOOL)deleteImageWithKey:(NSString *)key
{
    if (![self imageExistsForKey:key]) {
        return NO;
    }
    
    NSString *path = [localDirectory stringByAppendingFormat:@"/%@", key];
    NSError *error = [[NSError alloc] init];
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path
                                                              error:&error];
    if (!success) {
        NSLog(@"%@", error);
    }
    
    return success;
}

-(void)flushLocalImageData
{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localDirectory error:nil];
    
    NSLog(@"Permanently deleting %lu items in directory %@!", (unsigned long)[files count], localDirectory);
    
    for (NSString* file in files) {
        NSString *path = [localDirectory stringByAppendingFormat:@"/%@", file];
        NSError *error = [[NSError alloc] init];
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        
        if (!success) {
            NSLog(@"%@", error);
        }
    }
}

@end
