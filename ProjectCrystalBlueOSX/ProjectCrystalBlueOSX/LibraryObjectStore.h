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

/** Returns a new LibraryObject instance with the specified key
 *  from the specified table.
 *
 *  If there is no object with the specified key, nil will be returned.
 */
- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)tableName;

/** Adds a new LibraryObject instance to the specified local table.
 *
 *  The key must be a unique value across all devices.
 *
 *  The table name is used to coerce the libraryObject to the
 *  correct subclass type.
 *
 *  Returns YES if object is successfully added to the table,
 *  otherwise returns NO.
 */
- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  ForKey:(NSString *)key
               IntoTable:(NSString *)tableName;

/** Deletes a LibraryObject instance from the specified local table.
 *
 *  Returns YES if object is successfully deleted from the table,
 *  otherwise returns NO.
 */
- (BOOL)deleteLibraryObjectForKey:(NSString *)key
                        FromTable:(NSString *)tableName;

/** Synchronizes the specified local table with the remote Zumero
 *  database.
 *
 *  Returns YES if the sync is STARTED successfully, or NO otherwise.
 *
 *  A return value of YES does NOT guarantee a successful sync
 *  with the remote database. The syncSuccess and syncFail methods
 *  will be called on successful or failed synchronization.
 */
- (BOOL)synchronizeTable:(NSString *)tableName;

@end
