//
//  TestingUtils.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "TestingUtils.h"

@implementation TestingUtils

+(void)busyWaitForSeconds:(const float)seconds {
    NSDate *waitingStartTime = [[NSDate alloc] init];
    while ([waitingStartTime timeIntervalSinceNow] > -seconds);
}

@end