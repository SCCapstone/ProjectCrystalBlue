//
//  ImageStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "ImageStore.h"

@implementation ImageStore

- (id)init
{
    self = [super init];
    if (self)
    {
        allImages = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (ImageStore *)sharedStore
{
    static ImageStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

- (NSArray *)allImages
{
    return allImages;
}

@end
