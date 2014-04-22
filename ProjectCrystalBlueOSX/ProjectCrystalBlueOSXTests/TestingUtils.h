//
//  TestingUtils.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A static class with some testing utility methods.
@interface TestingUtils : NSObject

/// Block the active thread with a busy wait for the given number of seconds.
+(void)busyWaitForSeconds:(const float)seconds;

@end
