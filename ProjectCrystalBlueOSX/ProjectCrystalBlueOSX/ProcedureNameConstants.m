//
//  ProcedureConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProcedureNameConstants.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSDictionary *procedureTagToNameMap;

@implementation ProcedureNameConstants

+(NSString *)procedureNameForTag:(NSString *)tag
{
    if (!procedureTagToNameMap) {
        [self.class setupTagToNameMap];
    }
    
    return [procedureTagToNameMap objectForKey:tag];
}

+(void)setupTagToNameMap
{
    NSArray *tags = [[NSArray alloc] initWithObjects:
                     PROC_TAG_SLAB,
                     PROC_TAG_BILLET,
                     PROC_TAG_THIN_SECTION,
                     PROC_TAG_TRIM,
                     PROC_TAG_PULVERIZE,
                     PROC_TAG_JAWCRUSH,
                     PROC_TAG_GEMINI_DOWN,
                     PROC_TAG_GEMINI_UP,
                     PROC_TAG_PAN_DOWN,
                     PROC_TAG_PAN_UP,
                     PROC_TAG_SIEVE_10_DOWN,
                     PROC_TAG_SIEVE_10_UP,
                     PROC_TAG_HEAVY_LIQUID_330_DOWN,
                     PROC_TAG_HEAVY_LIQUID_330_UP,
                     PROC_TAG_HEAVY_LIQUID_290_DOWN,
                     PROC_TAG_HEAVY_LIQUID_290_UP,
                     PROC_TAG_HEAVY_LIQUID_265_DOWN,
                     PROC_TAG_HEAVY_LIQUID_265_UP,
                     PROC_TAG_HEAVY_LIQUID_255_DOWN,
                     PROC_TAG_HEAVY_LIQUID_255_UP,
                     PROC_TAG_HAND_MAGNET_DOWN,
                     PROC_TAG_HAND_MAGNET_UP,
                     PROC_TAG_MAGNET_02_AMPS,
                     PROC_TAG_MAGNET_04_AMPS,
                     PROC_TAG_MAGNET_06_AMPS,
                     PROC_TAG_MAGNET_08_AMPS,
                     PROC_TAG_MAGNET_10_AMPS,
                     PROC_TAG_MAGNET_12_AMPS,
                     PROC_TAG_MAGNET_14_AMPS,
                     nil];
    
    NSArray *names = [[NSArray alloc] initWithObjects:
                      PROC_NAME_SLAB,
                      PROC_NAME_BILLET,
                      PROC_NAME_THIN_SECTION,
                      PROC_NAME_TRIM,
                      PROC_NAME_PULVERIZE,
                      PROC_NAME_JAWCRUSH,
                      PROC_NAME_GEMINI_DOWN,
                      PROC_NAME_GEMINI_UP,
                      PROC_NAME_PAN_DOWN,
                      PROC_NAME_PAN_UP,
                      PROC_NAME_SIEVE_10_DOWN,
                      PROC_NAME_SIEVE_10_UP,
                      PROC_NAME_HEAVY_LIQUID_330_DOWN,
                      PROC_NAME_HEAVY_LIQUID_330_UP,
                      PROC_NAME_HEAVY_LIQUID_290_DOWN,
                      PROC_NAME_HEAVY_LIQUID_290_UP,
                      PROC_NAME_HEAVY_LIQUID_265_DOWN,
                      PROC_NAME_HEAVY_LIQUID_265_UP,
                      PROC_NAME_HEAVY_LIQUID_255_DOWN,
                      PROC_NAME_HEAVY_LIQUID_255_UP,
                      PROC_NAME_HAND_MAGNET_DOWN,
                      PROC_NAME_HAND_MAGNET_UP,
                      PROC_NAME_MAGNET_02_AMPS,
                      PROC_NAME_MAGNET_04_AMPS,
                      PROC_NAME_MAGNET_06_AMPS,
                      PROC_NAME_MAGNET_08_AMPS,
                      PROC_NAME_MAGNET_10_AMPS,
                      PROC_NAME_MAGNET_12_AMPS,
                      PROC_NAME_MAGNET_14_AMPS,
                      nil];
    
    if (names.count != tags.count) {
        DDLogWarn(@"%@: Mismatched number of procedures: %lu names and %lu tags",
                  NSStringFromClass(self.class),
                  (unsigned long)names.count,
                  (unsigned long)tags.count);
    }
    
    procedureTagToNameMap = [[NSDictionary alloc] initWithObjects:names
                                                          forKeys:tags];
}

@end
