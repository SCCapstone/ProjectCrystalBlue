//
//  AbstractLibraryObjectStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LibraryObject;

@interface AbstractLibraryObjectStore : NSObject

- (id)initInLocalDirectory:(NSString *)directory
          WithDatabaseName:(NSString *)databaseName;

/** Retrieve the library object associated with a given key.
 */
- (LibraryObject *)getLibraryObjectForKey:(NSString *)key;

/** Add a new image to the CloudLibraryObjectStore with the given unique key.
 *
 *  The key absolutely positively *MUST* be unique across all devices.
 *
 *  Returns YES if the put operation is successful; NO if it is unsuccessful.
 *  Generally, the only reason this should be unsuccessful is if the key is not unique
 *  or the device disk cannot be written to.
 *
 *  This only guarantees that the library object has been added to a LOCAL image storage; not necessarily
 *  to the cloud storage location.
 */
- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  forKey:(NSString *)key;

/** Delete a library object from the LibraryObjectStore. Return whether the deletion is successful.
 */
- (BOOL)deleteLibraryObjectWithKey:(NSString *)key;

/** Checks if the CloudLibraryObjectStore already has a library object for the given key.
 *  For example, this should always be used before assigning a key to a new image.
 */
- (BOOL)libraryObjectExistsForKey:(NSString *)key;

@end
