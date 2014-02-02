//
//  ZumeroLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ZumeroLibraryObjectStore.h"
@class LibraryObject;

@implementation ZumeroLibraryObjectStore

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
{
    return nil;
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject ForKey:(NSString *)key
{
    return NO;
}

- (BOOL)deleteLibraryObjectForKey:(NSString *)key
{
    return NO;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
{
    return NO;
}

- (BOOL)synchronize
{
    return NO;
}

@end
