//
//  OriginalSampleStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "OriginalSampleStore.h"

@implementation OriginalSampleStore

- (id)init
{
    self = [super init];
    if (self)
    {
        allSamples = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (OriginalSampleStore *)sharedStore
{
    static OriginalSampleStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

- (NSArray *)allSamples
{
    return allSamples;
}

@end
