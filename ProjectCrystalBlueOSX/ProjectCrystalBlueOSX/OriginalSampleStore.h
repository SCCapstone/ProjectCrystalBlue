//
//  OriginalSampleStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OriginalSample.h"

@interface OriginalSampleStore : NSObject
{
    NSMutableArray *allSamples;
}

+ (OriginalSampleStore *) sharedStore;

- (NSMutableArray *) allSamples;

@end
