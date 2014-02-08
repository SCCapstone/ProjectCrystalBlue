//
//  SampleStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sample.h"

@interface SampleStore : NSObject
{
    NSMutableArray *allSamples;
}

+ (SampleStore *) sharedStore;

- (NSMutableArray *) allSamples;

@end
