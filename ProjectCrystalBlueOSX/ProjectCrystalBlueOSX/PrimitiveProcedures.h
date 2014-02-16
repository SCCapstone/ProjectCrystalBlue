//
//  PrimitiveProcedures.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractLibraryObjectStore.h"
#import "Sample.h"

/**
 *  Primitive procedures are abstractions of very basic operations that are common 
 *  to "real" procedures.
 *
 *  These should not be directly called - primitive procedures should be wrapped in the Procedures class.
 */
@interface PrimitiveProcedures : NSObject

/**
 *  Clone a sample into a store. The cloned sample will have the same attributes, except
 *  a new unique key.
 */
+(void)cloneSample:(Sample *)original
         intoStore:(AbstractLibraryObjectStore *)store
    intoTableNamed:(NSString *)tableName;

/**
 *  Clone a "fresh" sample into a store. The cloned sample will have the same attributes, 
 *  except a new unique key and no tags.
 */
+(void)cloneSampleWithClearedTags:(Sample *)original
                        intoStore:(AbstractLibraryObjectStore *)store
                   intoTableNamed:(NSString *)tableName;

/**
 *  Append a tag to a sample, modifying it IN PLACE.
 */
+(void)appendToSampleInPlace:(Sample *)modifiedSample
                   tagString:(NSString *)tag
                   intoStore:(AbstractLibraryObjectStore *)store
              intoTableNamed:(NSString *)tableName;

/**
 *  Append a tag to a clone of a sample.
 */
+(void)appendToCloneOfSample:(Sample *)original
                   tagString:(NSString *)tag
                   intoStore:(AbstractLibraryObjectStore *)store
              intoTableNamed:(NSString *)tableName;

@end
