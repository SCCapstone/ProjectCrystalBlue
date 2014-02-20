//
//  Procedures.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Procedures.h"
#import "ProcedureNameConstants.h"
#import "SampleConstants.h"
#import "PrimitiveProcedures.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation Procedures

+ (void)jawCrushSample:(Sample *)sample
          withInitials:(NSString *)initials
               inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_JAWCRUSH
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)addCustomTagToSample:(Sample *)sample
                         tag:(NSString *)tag
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:tag
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

@end
