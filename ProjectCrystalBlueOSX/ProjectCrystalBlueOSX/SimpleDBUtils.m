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

@implementation SimpleDBUtils

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

+ (id)convertSimpleDBItem:(SimpleDBItem *)simpleDBItem
          ToObjectOfClass:(Class)objectClass
{
    NSMutableDictionary *objectAttributes = [[NSMutableDictionary alloc] initWithCapacity:simpleDBItem.attributes.count];
    for (SimpleDBAttribute *attribute in simpleDBItem.attributes) {
        [objectAttributes setObject:attribute.value forKey:attribute.name];
    }
    
    if (objectClass == [Source class])
        return [[Source alloc] initWithKey:[objectAttributes objectForKey:SRC_KEY] AndWithAttributeDictionary:objectAttributes];
    else if (objectClass == [Sample class])
        return [[Sample alloc] initWithKey:[objectAttributes objectForKey:SMP_KEY] AndWithAttributeDictionary:objectAttributes];
    else if (objectClass == [Transaction class])
        return [[Transaction alloc] initWithTimestamp:[objectAttributes objectForKey:TRN_TIMESTAMP] AndWithAttributeDictionary:objectAttributes];
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
        [convertedObjects addObject:[self convertSimpleDBItem:item ToObjectOfClass:objectClass]];
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

@end
