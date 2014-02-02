//
//  SampleStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleStore.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation SampleStore

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

+ (SampleStore *)sharedStore
{
    static SampleStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

- (NSArray *)allSamples
{
    return allSamples;
}

@end
