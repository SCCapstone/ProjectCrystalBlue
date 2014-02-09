//
//  LibraryObject.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryObject : NSObject

@property(readonly,copy) NSString *key;
@property NSMutableDictionary *attributes;

- (id)initWithKey:(NSString *)aKey
AndWithAttributes:(NSArray *)attributeNames
        AndValues:(NSArray *)attributeValues;

- (id)initWithKey:(NSString *)aKey
AndWithAttributeDictionary:(NSDictionary *)attr;

@end
