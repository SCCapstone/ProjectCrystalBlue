//
//  AbstractImageStore.m
//  ProjectCrystalBlueOSX
//
//  Abstract superclass for a class that handles image storage.
//  Each image item must be associated with a unique key.
//
//  Created by Logan Hood on 1/31/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "AbstractImageStore.h"
#import "PCBLogWrapper.h"

#define CLASS_NAME @"AbstractImageStore"

@implementation AbstractImageStore

-(id)init
{
    [NSException raise:@"Don't use default init method." format:@"Use the initWithLocalDirectory method."];
    return nil;
}

-(id)initWithLocalDirectory:(NSString *)directory
{
    return [super init];
}

-(NSImage *)getImageForKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return nil;
}

-(BOOL)deleteImageWithKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return NO;
}

-(BOOL)imageExistsForKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return NO;
}

-(BOOL)putImage:(NSImage *)image
         forKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return NO;
}

-(void)flushLocalImageData
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
}


+(NSImage *)defaultImage
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"no_image" ofType:@"png"];
    NSImage *defImage = [[NSImage alloc] initWithContentsOfFile:path];
    return defImage;
}

@end
