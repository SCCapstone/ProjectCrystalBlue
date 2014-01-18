//
//  ChildSample.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildSampleConstants.h"

@interface ChildSample : NSObject

@property(readonly,copy) NSString *key;
@property(readonly,copy) NSString *originalKey;
@property(readonly,copy) NSString *parentKey;
@property NSDictionary *attributes;

- (id) initWithAttributes:(NSArray *) attributeNames
     AndWithDefaultValues:(NSArray *) attributeDefaultValues;

@end
