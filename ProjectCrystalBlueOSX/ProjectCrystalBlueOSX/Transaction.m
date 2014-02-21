//
//  Transaction.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

@synthesize timestamp;
@synthesize attributes;

- (id)initWithLibraryObjectKey:(NSString *)key
              AndWithTableName:(NSString *)tableName
         AndWithSqlCommandType:(NSString *)sqlCommand
{
    self = [super init];
    if (self)
    {
        timestamp = [NSNumber numberWithDouble:[[[NSDate alloc] init] timeIntervalSince1970]];
        
        NSArray *attributeValues = [[NSArray alloc] initWithObjects:[timestamp stringValue], key, tableName, sqlCommand, nil];
        attributes = [[NSMutableDictionary alloc] initWithObjects:attributeValues
                                                          forKeys:[TransactionConstants attributeNames]];
    }
    return self;
}

- (id)initWithTimestamp:(NSNumber *)aTimestamp
AndWithAttributeDictionary:(NSDictionary *)attr
{
    self = [super init];
    if (self)
    {
        timestamp = [aTimestamp copy];
        attributes = [attr mutableCopy];
        
        // Make sure key is set correctly
        [attributes setObject:[timestamp stringValue] forKey:TRN_TIMESTAMP];
    }
    return self;
}

/**
 *  Compares this Transaction to another object. Transactions are considered equal if they have the same key and all the same attributes.
 */
- (BOOL)isEqual:(id)object
{
    if (nil == object) {
        return NO;
    }
    
    if (![object isKindOfClass:[Transaction class]]) {
        return NO;
    }
    
    Transaction *other = (Transaction *)object;
    
    if ([self.timestamp doubleValue] != [other.timestamp doubleValue]) {
        return NO;
    }
    
    if (self.attributes.count != other.attributes.count) {
        return NO;
    }
    
    for (NSString *attributeKey in self.attributes.allKeys) {
        NSString *ours = [self.attributes objectForKey:attributeKey];
        NSString *theirs = [other.attributes objectForKey:attributeKey];
        
        if (![ours isEqualToString:theirs]) {
            return NO;
        }
    }
    return YES;
}

/**
 *  Returns a hash generated for this Transaction. The hash is generated purely from the key.
 */
- (NSUInteger)hash
{
    return [self.timestamp hash];
}

@end
