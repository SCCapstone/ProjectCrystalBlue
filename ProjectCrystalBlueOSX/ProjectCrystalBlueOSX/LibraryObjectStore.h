//
//  LibraryObjectStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LibraryObject;

@protocol LibraryObjectStore <NSObject>

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key;

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  ForKey:(NSString *)key;

- (BOOL)deleteLibraryObjectForKey:(NSString *)key;

- (BOOL)libraryObjectExistsForKey:(NSString *)key;

- (BOOL)synchronize;

@end
