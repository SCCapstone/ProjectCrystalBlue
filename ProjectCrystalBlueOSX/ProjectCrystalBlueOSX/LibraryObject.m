//
//  LibraryObject.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObject.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LibraryObject

@synthesize key;
@synthesize attributes;

- (id)initWithKey:(NSString *)aKey
AndWithAttributes:(NSArray *)attributeNames
        AndValues:(NSArray *)attributeValues
{
    self = [super init];
    if (self)
    {
        if ([attributeNames count] != [attributeValues count])
            [NSException raise:@"Invalid attribute constants."
                        format:@"attributeNames is of length %lu and attributeDefaultValues is of length %lu", (unsigned long)[attributeNames count], (unsigned long)[attributeValues count]];
        key = [aKey copy];
        attributes = [[NSMutableDictionary alloc] initWithObjects:attributeValues
                                                          forKeys:attributeNames];
        // Make sure key is set correctly
        [attributes setObject:key forKey:@"key"];
    }
    return self;
}

- (id)initWithKey:(NSString *)aKey
AndWithAttributeDictionary:(NSDictionary *)attr
{
    self = [super init];
    if (self)
    {
        key = [aKey copy];
        attributes = [attr mutableCopy];
        
        // Make sure key is set correctly
        [attributes setObject:key forKey:@"key"];
    }
    return self;
}

/**
 *  Compares this LibraryObject to another object. LibraryObjects are considered equal if they have the same key and all the same attributes.
 */
- (BOOL)isEqual:(id)object
{
    if (nil == object) {
        return NO;
    }
    
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    
    LibraryObject *other = (LibraryObject *)object;
    
    if (![self.key isEqualToString:other.key]) {
        return NO;
    }
    
    if (![self.attributes.allKeys isEqualToArray:other.attributes.allKeys]) {
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
 *  Returns a hash generated for this LibraryObject. The hash is generated purely from the key.
 */
- (NSUInteger)hash
{
    return [self.key hash];
}

@end
