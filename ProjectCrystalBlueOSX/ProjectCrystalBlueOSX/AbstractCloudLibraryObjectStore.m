//
//  AbstractCloudLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AbstractCloudLibraryObjectStore.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"AbstractCloudLibraryObjectStore"

@implementation AbstractCloudLibraryObjectStore

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
