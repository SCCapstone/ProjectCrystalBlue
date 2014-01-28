//
//  Source.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SourceConstants.h"

@interface Source : NSObject

@property(readonly,copy) NSString *key;
@property NSDictionary *attributes;

- (id) initWithAttributes:(NSArray *) attributeNames
     AndWithDefaultValues:(NSArray *) attributeDefaultValues;

@end
