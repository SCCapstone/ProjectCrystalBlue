//
//  ZumeroLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ZumeroLibraryObjectStore.h"
#import "LibraryObject.h"
#import <Zumero.h>

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
    return nil;
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
