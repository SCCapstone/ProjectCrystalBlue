//
//  PrimitiveProcedures.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractLibraryObjectStore.h"
#import "Split.h"

/**
 *  Primitive procedures are abstractions of very basic operations that are common 
 *  to "real" procedures.
 *
 *  These should not be directly called - primitive procedures should be wrapped in the Procedures class.
 */
@interface PrimitiveProcedures : NSObject

/**
 *  Clone a split into a store. The cloned split will have the same attributes, except
 *  a new unique key.
 */
+(void)cloneSplit:(Split *)original
         intoStore:(AbstractLibraryObjectStore *)store
    intoTableNamed:(NSString *)tableName;

/**
 *  Clone a "fresh" split into a store. The cloned split will have the same attributes, 
 *  except a new unique key and no tags.
 */
+(void)cloneSplitWithClearedTags:(Split *)original
                        intoStore:(AbstractLibraryObjectStore *)store
                   intoTableNamed:(NSString *)tableName;

/**
 *  Append a tag to a split, modifying it IN PLACE.
 */
+(void)appendToSplitInPlace:(Split *)modifiedSplit
                   tagString:(NSString *)tag
                withInitials:(NSString *)initials
                   intoStore:(AbstractLibraryObjectStore *)store
              intoTableNamed:(NSString *)tableName;

/**
 *  Append a tag to a clone of a split.
 */
+(void)appendToCloneOfSplit:(Split *)original
                   tagString:(NSString *)tag
                withInitials:(NSString *)initials
                   intoStore:(AbstractLibraryObjectStore *)store
              intoTableNamed:(NSString *)tableName;

/**
 *  Helper method to generate a new unique key for a split. This key is guaranteed to be unique within the given table.
 *  Recall that splits are generally named something like 'SUPER_AWESOME_SPLIT.001'. This method would generate the key
 *  'SUPER_AWESOME_SPLIT.002' and, assuming no other split exists with that name, return it. If 'SUPER_AWESOME_SPLIT.002'
 *  already exists, then we try '*.003' '*.004' etc. until we find an open name.
 */
+(NSString *)uniqueKeyBasedOn:(NSString *)previousKey
                      inStore:(AbstractLibraryObjectStore *)store
                      inTable:(NSString *)tableName;

@end
