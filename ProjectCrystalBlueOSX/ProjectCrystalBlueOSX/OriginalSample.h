//
//  OriginalSample.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OriginalSampleConstants.h"

@interface OriginalSample : NSObject

@property(readonly,copy) NSString *key;
@property NSDictionary *attributes;

- (id) initWithAttributes:(NSArray *) attributeNames
     AndWithDefaultValues:(NSArray *) attributeDefaultValues;

@end
