//
//  SimpleDBUtils.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>

@interface SimpleDBUtils : NSObject

+ (NSArray *)executeSelectQuery:(NSString *)query
        WithReturnedObjectClass:(Class)objectClass
                    UsingClient:(AmazonSimpleDBClient *)simpleDBClient;

+ (id)convertSimpleDBItem:(SimpleDBItem *)simpleDBItem
          ToObjectOfClass:(Class)objectClass;

+ (NSArray *)convertSimpleDBItemArray:(NSArray *)simpleDBItems
                     ToObjectsOfClass:(Class)objectClass;

+ (SimpleDBReplaceableItem *)convertObjectToSimpleDBItem:(NSObject *)object;

@end
