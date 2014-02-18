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
         AndWithSqlCommandType:(NSString *)sqlCommand
{
    self = [super init];
    if (self)
    {
        timestamp = [NSNumber numberWithDouble:[[[NSDate alloc] init] timeIntervalSince1970]];
        
        NSArray *attributeValues = [[NSArray alloc] initWithObjects:timestamp, key, sqlCommand, nil];
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
        [attributes setObject:timestamp forKey:TRN_TIMESTAMP];
    }
    return self;
}

@end
