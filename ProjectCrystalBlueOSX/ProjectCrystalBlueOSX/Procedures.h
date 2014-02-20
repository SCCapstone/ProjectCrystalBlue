//
//  Procedures.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sample.h"
#import "AbstractLibraryObjectStore.h"

/**
 *  A Procedure corresponds to any physical action that either:
 *      - creates a new subsample (or many subsamples) from another sample
 *      - modifies an existing sample in an irreversible way
 *
 *  Examples of procedures are Magnetic Separations, a Jawcrushing, or separation with a gold pan.
 */
@interface Procedures : NSObject

/**
 *  Jawcrush the given sample. This is an IN-PLACE operation, destroying the previous sample.
 */
+ (void)jawCrushSample:(Sample *)sample
          withInitials:(NSString *)initials
               inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Can be used to add a custom tag to a sample, for example for procedures not declared in ProcedureNameConstants.
 *  This creates a clone of the sample; it is NOT an in-place operation.
 */
+ (void)addCustomTagToSample:(Sample *)sample
                         tag:(NSString *)tag
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

@end
