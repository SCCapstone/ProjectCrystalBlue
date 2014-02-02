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

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)tableName;

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  ForKey:(NSString *)key
               IntoTable:(NSString *)tableName;

- (BOOL)deleteLibraryObjectForKey:(NSString *)key
                        FromTable:(NSString *)tableName;

- (BOOL)libraryObjectExistsForKey:(NSString *)key
                        FromTable:(NSString *)tableName;

- (BOOL)synchronizeTable:(NSString *)tableName;

@end
