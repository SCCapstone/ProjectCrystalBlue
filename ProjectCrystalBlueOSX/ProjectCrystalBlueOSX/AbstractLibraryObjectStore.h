//
//  AbstractLibraryObjectStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObject.h"

@class Source;

@interface AbstractLibraryObjectStore : NSObject

- (id)initInLocalDirectory:(NSString *)directory
          WithDatabaseName:(NSString *)databaseName;

/** Retrieve the library object associated with a given key from the table.
 */
- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)tableName;

/** Retrieve all of the library objects from the table.
 */
- (NSArray *)getAllLibraryObjectsFromTable:(NSString *)tableName;

/** Retrieve all the samples that originated from the source object.
 */
- (NSArray *)getAllSamplesForSource:(Source *)source;

/** Execute a query on the table.
 *
 *  This should only be a SELECT query to get library objects, do not attempt 
 *  to use this method to make changes to the database.
 */
- (NSArray *)executeSqlQuery:(NSString *)sql
                     OnTable:(NSString *)tableName;

/** Add a new library object to the LibraryObjectStore with the given unique key.
 *
 *  The key absolutely positively *MUST* be unique across all devices.
 *
 *  Returns YES if the put operation is successful; NO if it is unsuccessful.
 *  Generally, the only reason this should be unsuccessful is if the key is not unique
 *  or the device disk cannot be written to.
 *
 *  This only guarantees that the library object has been added to a LOCAL library object 
 *  store; not necessarily to the cloud storage location.
 */
- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
               IntoTable:(NSString *)tableName;

/** Updates an existing library object in the LibraryObjectStore with the given key. Returns
 *  whether the update is successful.
 *
 *  Currently will update check against existing libraryObject and only update the attributes
 *  whose value has changed.
 *
 *  Will return NO if the object does not exist in the specified table.
 */
- (BOOL)updateLibraryObject:(LibraryObject *)libraryObject
                  IntoTable:(NSString *)tableName;

/** Delete a library object from the LibraryObjectStore. Return whether the deletion is successful.
 */
- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
                         FromTable:(NSString *)tableName;

/** Checks if the LibraryObjectStore already has a library object for the given key.
 *  For example, this should always be used before assigning a key to a new library object.
 */
- (BOOL)libraryObjectExistsForKey:(NSString *)key
                        FromTable:(NSString *)tableName;

/** Returns the number of rows in the table
 */
- (NSInteger)countInTable:(NSString *)tableName;

@end
