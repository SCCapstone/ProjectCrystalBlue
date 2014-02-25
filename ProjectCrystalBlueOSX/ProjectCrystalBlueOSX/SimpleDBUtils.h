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

/*  Uses the provided simpleDBClient to return an object from the specified domain
 *  and with the specified item name (unique object key).
 *
 *  The SimpleDBItem will be converted to an object of the provided class (Source/Sample/Transaction).
 */
+ (NSObject *)executeGetWithItemName:(NSString *)itemName
                   AndWithDomainName:(NSString *)domainName
                         UsingClient:(AmazonSimpleDBClient *)simpleDBClient
                     ToObjectOfClass:(Class)objectClass;

/*  Uses the provided simpleDBClient to return an array of objects using the specified query.
 *
 *  The SimpleDBItem will be converted to an object of the provided class (Source/Sample/Transaction).
 */
+ (NSArray *)executeSelectQuery:(NSString *)query
        WithReturnedObjectClass:(Class)objectClass
                    UsingClient:(AmazonSimpleDBClient *)simpleDBClient;

/*  Uses the provided simpleDBClient to put or update an array of objects (Source/Sample/Transaction)
 *  to the specified domain name.  All objects must be of the same type.
 *
 *  Returns whether the operation was successful.
 */
+ (BOOL)executeBatchPut:(NSArray *)objects
         WithDomainName:(NSString *)domainName
            UsingClient:(AmazonSimpleDBClient *)simpleDBClient;

/*  Uses the provided simpleDBClient to delete an array item names (unique object key)
 *  from the specified domain name.  All item names must be from the same domain
 *
 *  Returns whether the operation was successful.
 */
+ (BOOL)executeBatchDelete:(NSArray *)itemNames
            WithDomainName:(NSString *)domainName
               UsingClient:(AmazonSimpleDBClient *)simpleDBClient;

/*  Converts an array of SimpleDBAttributes to an equivalent object of the provided
 *  class (Source/Sample/Transaction).
 */
+ (id)convertSimpleDBAttributes:(NSArray *)simpleDBAttributes
                ToObjectOfClass:(Class)objectClass;

/*  Converts an array of SimpleDBItems to an equivalent array of objects of the provided
 *  class (Source/Sample/Transaction).
 */
+ (NSArray *)convertSimpleDBItemArray:(NSArray *)simpleDBItems
                     ToObjectsOfClass:(Class)objectClass;

/*  Converts a Source/Sample/Transaction object to an equivalent SimpleDBReplaceableItem.
 */
+ (SimpleDBReplaceableItem *)convertObjectToSimpleDBItem:(NSObject *)object;

/*  Converts an array of Source/Sample/Transaction objects to an equivalent array of 
 *  SimpleDBReplaceableItem.
 */
+ (NSArray *)convertObjectArrayToSimpleDBItemArray:(NSArray *)objectArray;

@end
