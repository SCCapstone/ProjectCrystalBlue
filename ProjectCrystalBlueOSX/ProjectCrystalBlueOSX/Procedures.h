//
//  Procedures.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Split.h"
#import "AbstractLibraryObjectStore.h"

/**
 *  A Procedure corresponds to any physical action that either:
 *      - creates a new subsplit (or many subsplits) from another split
 *      - modifies an existing split in an irreversible way
 *
 *  Examples of procedures are Magnetic Separations, a Jawcrushing, or separation with a gold pan.
 */
@interface Procedures : NSObject


/**
 * Used to created fresh split
 **/
+ (void)addFreshSplit:(Split *)split
               inStore:(AbstractLibraryObjectStore *)store;

/**
 * Used to change location of a split
 **/
+ (void)moveSplit:(Split *)split
        toLocation:(NSString *) newLocation
           inStore:(AbstractLibraryObjectStore *)store;

/**
 * Make a slab from a split. This creates a new split and adds slab to its procedures
 **/
+ (void)makeSlabfromSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;

/**
 * Make a billet from a split. This creates a new split and adds billet to its procedures
 **/
+ (void)makeBilletfromSplit:(Split *)split
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;

/**
 * Make a thin section from a split. This creates a new split and adds thin section to its procedures
 **/
+ (void)makeThinSectionfromSplit:(Split *)split
                     withInitials:(NSString *)initials
                          inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Jawcrush the given split. This is an IN-PLACE operation, destroying the previous split.
 */
+ (void)jawCrushSplit:(Split *)split
          withInitials:(NSString *)initials
               inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Pulverize the given split. This is an IN-PLACE operation, destroying the previous split.
 */
+ (void)pulverizeSplit:(Split *)split
           withInitials:(NSString *)initials
                inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Trim the given split. This is an IN-PLACE operation, destroying the previous split.
 */
+ (void)trimSplit:(Split *)split
      withInitials:(NSString *)initials
           inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Split was considered gemeni up. This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)geminiSplit:(Split *)split
        withInitials:(NSString *)initials
             inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Split was considered pan up. This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)panSplit:(Split *)split
     withInitials:(NSString *)initials
          inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered sieves up. This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)sievesTenSplit:(Split *)split
           withInitials:(NSString *)initials
                inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered hL330 up. This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)heavyLiquid_330_Split:(Split *)split
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered hL290 up. This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)heavyLiquid_290_Split:(Split *)split
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered hL265 up. This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)heavyLiquid_265_Split:(Split *)split
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered hL255 up. This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)heavyLiquid_255_Split:(Split *)split
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Split was considered handMagnet up.This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)handMagnetSplit:(Split *)split
            withInitials:(NSString *)initials
                 inStore:(AbstractLibraryObjectStore *)store;

/**
 *  Split was considered Magnet .2 up.This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)magnet02AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered Magnet .4 up.This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)magnet04AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered Magnet .6 up.This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)magnet06AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered Magnet .8 up.This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)magnet08AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered Magnet 1.0 up.This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)magnet10AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered Magnet 1.2 up.This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)magnet12AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Split was considered Magnet 1.4 up.This creates a new split and adds this attribute and appends down
 *  to the current split.
 */
+ (void)magnet14AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store;


/**
 *  Can be used to add a custom tag to a split, for example for procedures not declared in ProcedureNameConstants.
 *  This creates a clone of the split; it is NOT an in-place operation.
 */
+ (void)addCustomTagToSplit:(Split *)split
                         tag:(NSString *)tag
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store;




@end
