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
static NSOrderedSet *tags;
static NSOrderedSet *names;

@implementation ProcedureNameConstants

+(NSString *)procedureNameForTag:(NSString *)tag
{
    if (!procedureTagToNameMap) {
        [self.class setupTagToNameMap];
    }

    NSString *name = [procedureTagToNameMap objectForKey:tag];

    if (nil == name) {
        name = [NSString stringWithFormat:PROC_NAME_CUSTOM, tag];
    }

    return name;
}

+(NSSet *)allProcedureTags
{
    if (!tags) {
        [self.class setupTagToNameMap];
    }
    return [tags set];
}

+(NSSet *)allProcedureNames
{
    if (!names) {
        [self.class setupTagToNameMap];
    }
    return [names set];
}

+(void)setupTagToNameMap
{
    tags = [[NSOrderedSet alloc] initWithObjects:
            PROC_TAG_SLAB,
            PROC_TAG_BILLET,
            PROC_TAG_THIN_SECTION,
            PROC_TAG_TRIM,
            PROC_TAG_PULVERIZE,
            PROC_TAG_JAWCRUSH,
            PROC_TAG_GEMENI_DOWN,
            PROC_TAG_GEMENI_UP,
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
            PROC_TAG_MAGNET_02_AMPS_UP,
            PROC_TAG_MAGNET_02_AMPS_DOWN,
            PROC_TAG_MAGNET_04_AMPS_UP,
            PROC_TAG_MAGNET_04_AMPS_DOWN,
            PROC_TAG_MAGNET_06_AMPS_UP,
            PROC_TAG_MAGNET_06_AMPS_DOWN,
            PROC_TAG_MAGNET_08_AMPS_UP,
            PROC_TAG_MAGNET_08_AMPS_DOWN,
            PROC_TAG_MAGNET_10_AMPS_UP,
            PROC_TAG_MAGNET_10_AMPS_DOWN,
            PROC_TAG_MAGNET_12_AMPS_UP,
            PROC_TAG_MAGNET_12_AMPS_DOWN,
            PROC_TAG_MAGNET_14_AMPS_UP,
            PROC_TAG_MAGNET_14_AMPS_DOWN,
            nil];

    names = [[NSOrderedSet alloc] initWithObjects:
             PROC_NAME_SLAB,
             PROC_NAME_BILLET,
             PROC_NAME_THIN_SECTION,
             PROC_NAME_TRIM,
             PROC_NAME_PULVERIZE,
             PROC_NAME_JAWCRUSH,
             PROC_NAME_GEMENI_DOWN,
             PROC_NAME_GEMENI_UP,
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
             PROC_NAME_MAGNET_02_AMPS_UP,
             PROC_NAME_MAGNET_02_AMPS_DOWN,
             PROC_NAME_MAGNET_04_AMPS_UP,
             PROC_NAME_MAGNET_04_AMPS_DOWN,
             PROC_NAME_MAGNET_06_AMPS_UP,
             PROC_NAME_MAGNET_06_AMPS_DOWN,
             PROC_NAME_MAGNET_08_AMPS_UP,
             PROC_NAME_MAGNET_08_AMPS_DOWN,
             PROC_NAME_MAGNET_10_AMPS_UP,
             PROC_NAME_MAGNET_10_AMPS_DOWN,
             PROC_NAME_MAGNET_12_AMPS_UP,
             PROC_NAME_MAGNET_12_AMPS_DOWN,
             PROC_NAME_MAGNET_14_AMPS_UP,
             PROC_NAME_MAGNET_14_AMPS_DOWN,
             nil];

    if (names.count != tags.count) {
        DDLogWarn(@"%@: Mismatched number of procedures: %lu names and %lu tags",
                  NSStringFromClass(self.class),
                  (unsigned long)names.count,
                  (unsigned long)tags.count);
    }

    procedureTagToNameMap = [[NSDictionary alloc] initWithObjects:names.array
                                                          forKeys:tags.array];
}

@end
