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
 * Used to created fresh sample
 **/
+ (void)addFreshSample:(Sample *)sample
               inStore:(AbstractLibraryObjectStore *)store;

/**
 * Used to change location of a sample
 **/
+ (void)moveSample:(Sample *)sample
        toLocation:(NSString *) newLocation
           inStore:(AbstractLibraryObjectStore *)store;

/**
 * Make a slab from a sample. This creates a new sample and adds slab to its procedures
 **/
+ (void)makeSlabfromSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;

/**
 * Make a billet from a sample. This creates a new sample and adds billet to its procedures
 **/
+ (void)makeBilletfromSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 * Make a thin section from a sample. This creates a new sample and adds thin section to its procedures
 **/
+ (void)makeThinSectionfromSample:(Sample *)sample
                     withInitials:(NSString *)initials
                          inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Jawcrush the given sample. This is an IN-PLACE operation, destroying the previous sample.
 */
+ (void)jawCrushSample:(Sample *)sample
          withInitials:(NSString *)initials
               inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Pulverize the given sample. This is an IN-PLACE operation, destroying the previous sample.
 */
+ (void)pulverizeSample:(Sample *)sample
           withInitials:(NSString *)initials
                inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Trim the given sample. This is an IN-PLACE operation, destroying the previous sample.
 */
+ (void)trimSample:(Sample *)sample
      withInitials:(NSString *)initials
           inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered gemeni up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)geminiSample:(Sample *)sample
        withInitials:(NSString *)initials
             inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered pan up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)panSample:(Sample *)sample
     withInitials:(NSString *)initials
          inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered sieves up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)sievesTenSample:(Sample *)sample
           withInitials:(NSString *)initials
                inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered hL330 up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)heavyLiquid_330_Sample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered hL290 up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)heavyLiquid_290_Sample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered hL265 up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)heavyLiquid_265_Sample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered hL255 up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)heavyLiquid_255_Sample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered handMagnet up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)handMagnetSample:(Sample *)sample
            withInitials:(NSString *)initials
                 inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet .2 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet02AmpsSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered Magnet .4 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet04AmpsSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered Magnet .6 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet06AmpsSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered Magnet .8 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet08AmpsSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered Magnet 1.0 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet10AmpsSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered Magnet 1.2 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet12AmpsSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered Magnet 1.4 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet14AmpsSample:(Sample *)sample
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
