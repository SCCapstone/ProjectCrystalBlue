//
//  ZumeroUtils.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ZumeroUtils.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation ZumeroUtils

+ (BOOL)createZumeroTableWithName:(NSString *)tableName
{
    return NO;
}

+ (BOOL)zumeroTableExistsWithName:(NSString *)tableName
{
    return NO;
}

@end
