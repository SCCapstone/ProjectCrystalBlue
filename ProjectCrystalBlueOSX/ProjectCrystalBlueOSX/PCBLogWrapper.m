//
//  PCBLogWrapper.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/27/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "PCBLogWrapper.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

@implementation PCBLogWrapper

+(void)setupLog
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    });
}

@end
