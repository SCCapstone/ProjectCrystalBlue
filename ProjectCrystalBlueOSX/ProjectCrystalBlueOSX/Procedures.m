//
//  Procedures.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Procedures.h"
#import "ProcedureNameConstants.h"
#import "SplitConstants.h"
#import "PrimitiveProcedures.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation Procedures



+ (void)addFreshSplit:(Split *)split
               inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures cloneSplitWithClearedTags:split
                                          intoStore:store
                                     intoTableNamed:[SplitConstants tableName]];
}

+ (void)moveSplit:(Split *)split
        toLocation:(NSString *) newLocation
           inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [[split attributes] setObject:newLocation forKey:SPL_CURRENT_LOCATION];
    [store updateLibraryObject:split IntoTable:[SplitConstants tableName]];
}

/**
 Procedures that append to a clone of a tag only
 **/
+ (void)makeSlabfromSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_SLAB
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)makeBilletfromSplit:(Split *)split
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_BILLET
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)makeThinSectionfromSplit:(Split *)split
                     withInitials:(NSString *)initials
                          inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_THIN_SECTION
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


/**
 Procedures that only modify the original split
 **/


+ (void)jawCrushSplit:(Split *)split
          withInitials:(NSString *)initials
               inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_JAWCRUSH
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)pulverizeSplit:(Split *)split
           withInitials:(NSString *)initials
                inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_PULVERIZE
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)trimSplit:(Split *)split
      withInitials:(NSString *)initials
           inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_TRIM
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

/**
 Functions that are up/down. For up procedures the current split gets the down and a new split
 is created with the up. For down procedures the current split gets the up and a new split is created with the down
 **/

+ (void)gemeniSplit:(Split *)split
        withInitials:(NSString *)initials
             inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_GEMENI_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_GEMENI_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}
+ (void)panSplit:(Split *)split
     withInitials:(NSString *)initials
          inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_PAN_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_PAN_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)sievesTenSplit:(Split *)split
           withInitials:(NSString *)initials
                inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_SIEVE_10_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_SIEVE_10_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

/** specifically the heavy liquid up/down methods **/

+ (void)heavyLiquid_330_Split:(Split *)split
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_HEAVY_LIQUID_330_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_HEAVY_LIQUID_330_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)heavyLiquid_290_Split:(Split *)split
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_HEAVY_LIQUID_290_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_HEAVY_LIQUID_290_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)heavyLiquid_265_Split:(Split *)split
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_HEAVY_LIQUID_265_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_HEAVY_LIQUID_265_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)heavyLiquid_255_Split:(Split *)split
                  withInitials:(NSString *)initials
                       inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_HEAVY_LIQUID_255_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_HEAVY_LIQUID_255_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


+ (void)handMagnetSplit:(Split *)split
            withInitials:(NSString *)initials
                 inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_HAND_MAGNET_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_HAND_MAGNET_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


+ (void)magnet02AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_MAGNET_02_AMPS_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_MAGNET_02_AMPS_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


+ (void)magnet04AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_MAGNET_04_AMPS_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_MAGNET_04_AMPS_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


+ (void)magnet06AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_MAGNET_06_AMPS_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_MAGNET_06_AMPS_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

+ (void)magnet08AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_MAGNET_08_AMPS_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_MAGNET_08_AMPS_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


+ (void)magnet10AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_MAGNET_10_AMPS_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_MAGNET_10_AMPS_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


+ (void)magnet12AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_MAGNET_12_AMPS_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_MAGNET_12_AMPS_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


+ (void)magnet14AmpsSplit:(Split *)split
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:PROC_TAG_MAGNET_14_AMPS_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];

    [PrimitiveProcedures appendToSplitInPlace:split
                                     tagString:PROC_TAG_MAGNET_14_AMPS_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}


/**
 Customized Tag method
 **/

+ (void)addCustomTagToSplit:(Split *)split
                         tag:(NSString *)tag
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSplit:split
                                     tagString:tag
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SplitConstants tableName]];
}

@end
