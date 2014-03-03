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
+ (void)geminiUpSample:(Sample *)sample
          withInitials:(NSString *)initials
               inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered gemeni up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)geminiDownSample:(Sample *)sample
            withInitials:(NSString *)initials
                 inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered pan up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)panUpSample:(Sample *)sample
       withInitials:(NSString *)initials
            inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered pan down. This creates a new sample and adds this attribute and appends up
 *  to the current sample.
 */
+ (void)panDownSample:(Sample *)sample
         withInitials:(NSString *)initials
              inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered sieves up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)sievesTenUpSample:(Sample *)sample
             withInitials:(NSString *)initials
                  inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered sieves down. This creates a new sample and adds this attribute and appends up
 *  to the current sample.
 */
+ (void)sievesTenDownSample:(Sample *)sample
               withInitials:(NSString *)initials
                    inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered hL330 up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)heavyLiquid_330_UpSample:(Sample *)sample
                    withInitials:(NSString *)initials
                         inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered hL330 down. This creates a new sample and adds this attribute and appends up
 *  to the current sample.
 */
+ (void)heavyLiquid_330_DownSample:(Sample *)sample
                      withInitials:(NSString *)initials
                           inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered hL290 up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)heavyLiquid_290_UpSample:(Sample *)sample
                    withInitials:(NSString *)initials
                         inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered hL290 down. This creates a new sample and adds this attribute and appends up
 *  to the current sample.
 */
+ (void)heavyLiquid_290_DownSample:(Sample *)sample
                      withInitials:(NSString *)initials
                           inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered hL265 up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)heavyLiquid_265_UpSample:(Sample *)sample
                    withInitials:(NSString *)initials
                         inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Sample was considered hL265 down. This creates a new sample and adds this attribute and appends up
 *  to the current sample.
 */
+ (void)heavyLiquid_265_DownSample:(Sample *)sample
                      withInitials:(NSString *)initials
                           inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered hL255 up. This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)heavyLiquid_255_UpSample:(Sample *)sample
                    withInitials:(NSString *)initials
                         inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered hL255 down. This creates a new sample and adds this attribute and appends up
 *  to the current sample.
 */
+ (void)heavyLiquid_255_DownSample:(Sample *)sample
                      withInitials:(NSString *)initials
                           inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered handMagnet up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)handMagnetUpSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered handMagnet up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)handMagnetDownSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet .2 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet02AmpsUpSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet .2 down.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet02AmpsDownSample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet .4 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet04AmpsUpSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet 4 down.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet04AmpsDownSample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet .6 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet06AmpsUpSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet .6 down.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet06AmpsDownSample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet .8 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet08AmpsUpSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet .8 down.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet08AmpsDownSample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet 1.0 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet10AmpsUpSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet 1.0 down.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet10AmpsDownSample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet 1.2 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet12AmpsUpSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet 1.2 down.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet12AmpsDownSample:(Sample *)sample
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet 1.4 up.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet14AmpsUpSample:(Sample *)sample
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Sample was considered Magnet 1.4 down.This creates a new sample and adds this attribute and appends down
 *  to the current sample.
 */
+ (void)magnet14AmpsDownSample:(Sample *)sample
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
