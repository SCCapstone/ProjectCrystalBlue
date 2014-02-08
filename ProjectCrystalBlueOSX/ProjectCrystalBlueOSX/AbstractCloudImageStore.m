//
//  AbstractCloudImageStore.m
//  ProjectCrystalBlueOSX
//
//  Abstract superclass for a class that handles image storage, backed with a cloud data storage.
//  Each image item must be associated with a unique key.
//
//  Created by Logan Hood on 1/31/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "AbstractCloudImageStore.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"AbstractCloudImageStore"

@implementation AbstractCloudImageStore

-(id)initWithLocalDirectory:(NSString *)directory
{
    return [super initWithLocalDirectory:directory];
}

-(BOOL)synchronizeWithCloud
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return NO;
}

-(BOOL)keyIsDirty:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return NO;
}

@end