//
//  ImageStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStore : NSObject
{
    NSMutableArray *allImages;
}

+ (ImageStore *) sharedStore;

- (NSMutableArray *) allImages;

@end
