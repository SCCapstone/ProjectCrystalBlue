//
//  AbstractLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AbstractLibraryObjectStore.h"
#import "LibraryObject.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation AbstractLibraryObjectStore

- (id)init
{
    [NSException raise:@"Don't use default init method." format:@"Use the initInLocalDirectory:WithDatabaseName method."];
    return nil;
}

- (id)initInLocalDirectory:(NSString *)directory
          WithDatabaseName:(NSString *)databaseName
{
    return [super init];
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
                                FromTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

- (NSArray *)getAllLibraryObjectsFromTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

- (NSArray *)getAllSamplesForSourceKey:(NSString *)sourceKey
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

- (NSArray *)getAllLibraryObjectsForAttributeName:(NSString *)attributeName
                               WithAttributeValue:(NSString *)attributeValue
                                        FromTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

- (NSArray *)getAllSamplesForSourceKey:(NSString *)sourceKey
                   AndForAttributeName:(NSString *)attributeName
                    WithAttributeValue:(NSString *)attributeValue
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

- (NSArray *)getUniqueAttributeValuesForAttributeName:(NSString *)attributeName
                                            FromTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

- (NSArray *)getLibraryObjectsWithSqlQuery:(NSString *)sql
                                   OnTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
               IntoTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

- (BOOL)updateLibraryObject:(LibraryObject *)libraryObject
                  IntoTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
                         FromTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

- (BOOL)deleteAllSamplesForSourceKey:(NSString *)sourceKey
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
                        FromTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

- (NSUInteger)countInTable:(NSString *)tableName
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return 0;
}

@end
