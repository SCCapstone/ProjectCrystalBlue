//
//  ZumeroLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ZumeroLibraryObjectStore.h"
#import "LibraryObject.h"
#import "ZumeroUtils.h"
#import "Source.h"
#import "Sample.h"
#import "SourceConstants.h"
#import "SampleConstants.h"
#import <Zumero.h>

#define CLASS_NAME @"ZumeroLibraryObjectStore"

@interface ZumeroLibraryObjectStore()
{
    ZumeroDB *zumeroDatabase;
}

@end


@implementation ZumeroLibraryObjectStore

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self database];
}

+ (ZumeroLibraryObjectStore *)database
{
    static ZumeroLibraryObjectStore *database = nil;
    if (!database)
        database = [[super allocWithZone:nil] init];
    
    return database;
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)tableName
{
    if (![ZumeroUtils zumeroTableExistsWithName:tableName UsingDatabase:zumeroDatabase]) {
        NSLog(@"%@: Table with name %@ does not exist!", CLASS_NAME, tableName);
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *criteria = @{ @"": key };
    NSArray *columns = [tableName isEqualToString:[SourceConstants sourceTableName]] ?
        [SourceConstants attributeNames] : [SampleConstants attributeNames];
    NSArray *rows = nil;
    
    [ZumeroUtils startZumeroTransactionUsingDatabase:zumeroDatabase];
    
    if (![zumeroDatabase select:tableName criteria:criteria columns:columns orderby:nil rows:&rows error:&error]) {
        NSLog(@"%@: Failed to get library object. Error: %@", CLASS_NAME, error);
        return nil;
    }
    
    [ZumeroUtils finishZumeroTransactionUsingDatabase:zumeroDatabase];
    
    if (!rows)
        return nil;
    
    LibraryObject *libraryObject = nil;
    if ([tableName isEqualToString:[SourceConstants sourceTableName]]) {
        libraryObject = [[Source alloc] initWithKey:key AndWithValues:[rows firstObject]];
    }
    else {
        libraryObject = [[Sample alloc] initWithKey:key AndWithValues:[rows firstObject]];
    }
    
    return libraryObject;
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  ForKey:(NSString *)key
               IntoTable:(NSString *)tableName
{
    return NO;
}

- (BOOL)deleteLibraryObjectForKey:(NSString *)key
                        FromTable:(NSString *)tableName
{
    return NO;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
                        FromTable:(NSString *)tableName
{
    return NO;
}

- (BOOL)synchronizeTable:(NSString *)tableName
{
    return NO;
}

@end
