//
//  SimpleDBUtils.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SimpleDBUtils.h"
#import "Source.h"
#import "Sample.h"
#import "Transaction.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SimpleDBUtils()

/*  Converts an array of item names (unique object keys) to an array of SimpleDBDeleteableItems.
 */
+ (NSArray *)convertItemNameArrayToSimpleDBDeleteableArray:(NSArray *)itemNameArray;

@end

@implementation SimpleDBUtils

+ (NSObject *)executeGetWithItemName:(NSString *)itemName
                   AndWithDomainName:(NSString *)domainName
                         UsingClient:(AmazonSimpleDBClient *)simpleDBClient
                     ToObjectOfClass:(Class)objectClass
{
    @try {
        SimpleDBGetAttributesRequest *getRequest = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:domainName
                                                                                                andItemName:itemName];
        SimpleDBGetAttributesResponse *getResponse = [simpleDBClient getAttributes:getRequest];
        return [self convertSimpleDBAttributes:getResponse.attributes ToObjectOfClass:objectClass];
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@: Failed to get object from the remote database. Error: %@", NSStringFromClass(self.class), exception);
        return nil;
    }
}

+ (NSArray *)executeSelectQuery:(NSString *)query
        WithReturnedObjectClass:(Class)objectClass
                    UsingClient:(AmazonSimpleDBClient *)simpleDBClient
{
    NSString *nextToken;
    SimpleDBSelectRequest *selectRequest;
    SimpleDBSelectResponse *selectResponse;
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    @try {
        do {
            selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:query andConsistentRead:YES];
            
            // Check if there is another page
            if (nextToken)
                selectRequest.nextToken = nextToken;
            
            selectResponse = [simpleDBClient select:selectRequest];
            [objects addObjectsFromArray:selectResponse.items];
            nextToken = selectResponse.nextToken;
            
        } while (nextToken != nil);
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@: Failed to query remote SimpleDB database. Error: %@", NSStringFromClass(self.class), exception);
        return nil;
    }
    
    return [self convertSimpleDBItemArray:objects ToObjectsOfClass:objectClass];
}

+ (BOOL)executeBatchPut:(NSArray *)objects
         WithDomainName:(NSString *)domainName
            UsingClient:(AmazonSimpleDBClient *)simpleDBClient
{
    @try {
        NSArray *simpleDBItems = [self convertObjectArrayToSimpleDBItemArray:objects];
        NSInteger remainingItems = simpleDBItems.count;
        int count = 0;
        
        // Batch put is limited by 25 items so must make separate requests if larger than 25 items
        while (remainingItems > 0) {
            NSMutableArray *putItems = [[simpleDBItems subarrayWithRange:NSMakeRange(count*25, MIN(remainingItems, 25))] mutableCopy];
            
            SimpleDBBatchPutAttributesRequest *batchPutRequest = [[SimpleDBBatchPutAttributesRequest alloc] initWithDomainName:domainName
                                                                                                                      andItems:putItems];
            [simpleDBClient batchPutAttributes:batchPutRequest];
            
            remainingItems = remainingItems - 25;
            count++;
        }
        
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@: Failed to batch put to the remote database. Error: %@", NSStringFromClass(self.class), exception);
        return NO;
    }

    return YES;
}

+ (BOOL)executeBatchDelete:(NSArray *)itemNames
            WithDomainName:(NSString *)domainName
               UsingClient:(AmazonSimpleDBClient *)simpleDBClient
{
    @try {
        NSArray *simpleDBItems = [self convertItemNameArrayToSimpleDBDeleteableArray:itemNames];
        NSInteger remainingItems = simpleDBItems.count;
        int count = 0;
        
        // Batch delete is limited by 25 items so must make separate requests if larger than 25 items
        while (remainingItems > 0) {
            NSMutableArray *deleteItems = [[simpleDBItems subarrayWithRange:NSMakeRange(count*25, MIN(remainingItems, 25))] mutableCopy];
            
            SimpleDBBatchDeleteAttributesRequest *batchDeleteRequest = [[SimpleDBBatchDeleteAttributesRequest alloc] initWithDomainName:domainName
                                                                                                                               andItems:deleteItems];
            [simpleDBClient batchDeleteAttributes:batchDeleteRequest];
            
            remainingItems = remainingItems - 25;
            count++;
        }
        
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@: Failed to batch delete to the remote database. Error: %@", NSStringFromClass(self.class), exception);
        return NO;
    }
    
    return YES;
}

+ (id)convertSimpleDBAttributes:(NSArray *)simpleDBAttributes
                ToObjectOfClass:(Class)objectClass
{
    NSMutableDictionary *objectAttributes = [[NSMutableDictionary alloc] initWithCapacity:simpleDBAttributes.count];
    for (SimpleDBAttribute *attribute in simpleDBAttributes) {
        [objectAttributes setObject:attribute.value forKey:attribute.name];
    }
    
    if (objectClass == [Source class])
        return [[Source alloc] initWithKey:[objectAttributes objectForKey:SRC_KEY] AndWithAttributeDictionary:objectAttributes];
    else if (objectClass == [Sample class])
        return [[Sample alloc] initWithKey:[objectAttributes objectForKey:SMP_KEY] AndWithAttributeDictionary:objectAttributes];
    else if (objectClass == [Transaction class])
        return [[Transaction alloc] initWithTimestamp:[NSNumber numberWithDouble:[[objectAttributes objectForKey:TRN_TIMESTAMP] doubleValue]] AndWithAttributeDictionary:objectAttributes];
    else {
        DDLogCError(@"%@: objectClass must be of type Source, Sample, or Transaction.", NSStringFromClass(self.class));
        return nil;
    }
}

+ (NSArray *)convertSimpleDBItemArray:(NSArray *)simpleDBItems
                     ToObjectsOfClass:(Class)objectClass
{
    NSMutableArray *convertedObjects = [[NSMutableArray alloc] initWithCapacity:simpleDBItems.count];
    for (SimpleDBItem *item in simpleDBItems) {
        [convertedObjects addObject:[self convertSimpleDBAttributes:item.attributes
                                                    ToObjectOfClass:objectClass]];
    }
    return convertedObjects;
}

+ (SimpleDBReplaceableItem *)convertObjectToSimpleDBItem:(NSObject *)object
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    if ([object isKindOfClass:[LibraryObject class]])
        attributes = ((LibraryObject *)object).attributes;
    else if ([object isMemberOfClass:[Transaction class]])
        attributes = ((Transaction *)object).attributes;
    else {
        DDLogCError(@"%@: Object must derive from type LibraryObject or be of type Transaction to convert to a SimpleDBItem.", NSStringFromClass(self.class));
        return nil;
    }
    
    NSString *itemName = @"";
    NSArray *attributeKeys = [attributes allKeys];
    NSMutableArray *objectAttributes = [[NSMutableArray alloc] init];
    
    for (NSString *key in attributeKeys) {
        if ([key isEqualToString:@"key"] || [key isEqualToString:TRN_TIMESTAMP])
            itemName = [attributes objectForKey:key];
        SimpleDBReplaceableAttribute *keyValuePair = [[SimpleDBReplaceableAttribute alloc] initWithName:key
                                                                                               andValue:[attributes objectForKey:key]
                                                                                             andReplace:YES];
        [objectAttributes addObject:keyValuePair];
    }
    
    return [[SimpleDBReplaceableItem alloc] initWithName:itemName
                                           andAttributes:objectAttributes];
}

+ (NSArray *)convertObjectArrayToSimpleDBItemArray:(NSArray *)objectArray
{
    NSMutableArray *convertedObjects = [[NSMutableArray alloc] initWithCapacity:objectArray.count];
    for (NSObject *object in objectArray) {
        [convertedObjects addObject:[self convertObjectToSimpleDBItem:object]];
    }
    return convertedObjects;
}

+ (NSArray *)convertItemNameArrayToSimpleDBDeleteableArray:(NSArray *)itemNameArray
{
    NSMutableArray *simpleDBDeleteableItems = [[NSMutableArray alloc] init];
    for (NSString *itemName in itemNameArray) {
        SimpleDBDeletableItem *deleteableItem = [[SimpleDBDeletableItem alloc] init];
        deleteableItem.name = itemName;
        [simpleDBDeleteableItems addObject:deleteableItem];
    }
    return simpleDBDeleteableItems;
}

@end
