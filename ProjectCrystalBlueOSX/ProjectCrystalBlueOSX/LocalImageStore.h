//
//  LocalImageStore.h
//  ProjectCrystalBlueOSX
//
//  Handles local image storage for a CloudImageStore.
//  This should not be used directly by any class other than a CloudImageStore implementation.
//
//  Created by Logan Hood on 1/28/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractImageStore.h"

@interface LocalImageStore : AbstractImageStore {
    NSString *localDirectory;
}

@end