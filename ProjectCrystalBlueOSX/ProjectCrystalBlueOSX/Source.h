//
//  Source.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObject.h"
#import "SourceConstants.h"

@interface Source : LibraryObject

- (id)initWithKey:(NSString *)key
    AndWithValues:(NSArray *)attributeValues;

@end
