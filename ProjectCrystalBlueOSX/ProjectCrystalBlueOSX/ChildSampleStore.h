//
//  ChildSampleStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildSample.h"

@interface ChildSampleStore : NSObject
{
    NSMutableArray *allSamples;
}

+ (ChildSampleStore *) sharedStore;

- (NSMutableArray *) allSamples;

@end
