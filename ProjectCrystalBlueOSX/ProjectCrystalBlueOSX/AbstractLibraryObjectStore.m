//
//  AbstractLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AbstractLibraryObjectStore.h"
#import "LibraryObject.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"AbstractLibraryObjectStore"

@implementation AbstractLibraryObjectStore

- (id)init
{
    [NSException raise:@"Don't use default init method." format:@"Use the initWithLocalDirectory method."];
    return nil;
}

- (id)initWithLocalDirectory:(NSString *)directory
{
    return [super init];
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return nil;
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return NO;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return NO;
}

- (BOOL)putLibraryObject:(LibraryObject *)image
                  forKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", CLASS_NAME];
    return NO;
}

@end
