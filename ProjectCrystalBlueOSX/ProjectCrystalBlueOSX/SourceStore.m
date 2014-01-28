//
//  SourceStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceStore.h"

@implementation SourceStore

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

+ (SourceStore *)sharedStore
{
    static SourceStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

- (NSArray *)allSamples
{
    return allSamples;
}

@end
