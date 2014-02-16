//
//  AbstractCloudLibraryObjectStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractLibraryObjectStore.h"

@interface AbstractCloudLibraryObjectStore : AbstractLibraryObjectStore

/** Synchronize any new changes with an online database, if the LibraryObject is backed by one.
 *  This should get any new library objects that have been created on other devices, as well as
 *  upload any library objects that have been created on this device.
 *
 *  When online, the CloudLibraryObjectStore will automatically synchronize whenever library
 *  objects are added, but this should also be called periodically in case objects were created offline.
 *
 *  Returns NO
 *      -if items need to be synced, but the database cannot be reached
 *
 *  Returns YES
 *      -if no items needed to be synced
 *      -if items were successfully synced
 */
- (BOOL)synchronizeWithCloud;

@end
