//
//  PCBLogWrapper.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/27/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

/**
 *  A wrapper class, with Lumberjack as the underlying logging tool.
 *  This allows a global logging level for the entire program.
 */
@interface PCBLogWrapper : NSObject

+(void)setupLog;

@end
