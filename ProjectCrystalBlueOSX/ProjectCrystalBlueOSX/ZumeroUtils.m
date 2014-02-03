//
//  ZumeroUtils.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ZumeroUtils.h"
#import "ZumeroLibraryObjectStore.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"ZumeroUtils"

@implementation ZumeroUtils

+ (BOOL)createZumeroTableWithName:(NSString *)tableName
                        AndFields:(NSDictionary *)fields
                    UsingDatabase:(ZumeroDB *)database
{
    if ([self zumeroTableExistsWithName:tableName UsingDatabase:database])
        return YES;
    
    NSError *error = nil;
    
    [self startZumeroTransactionUsingDatabase:database];
    
    if(![database defineTable:tableName fields:fields error:&error]) {
        DDLogError(@"%@: Failed to create zumero table: %@. Error:%@", CLASS_NAME, tableName, error);
        return NO;
    }
    
    [self finishZumeroTransactionUsingDatabase:database];
    
    return YES;
}

+ (BOOL)zumeroTableExistsWithName:(NSString *)tableName
                    UsingDatabase:(ZumeroDB *)database
{
    [self startZumeroTransactionUsingDatabase:database];
    BOOL exists = [database tableExists:tableName];
    [self finishZumeroTransactionUsingDatabase:database];
    
    return exists;
}

+ (BOOL)startZumeroTransactionUsingDatabase:(ZumeroDB *)database
{
    NSError *error = nil;
    
    if (![database open:&error]) {
        DDLogError(@"%@: Failed to open database. Error:%@", CLASS_NAME, error);
        return NO;
    }
    if (![database beginTX:&error]) {
        DDLogError(@"%@: Failed to begin transaction. Error:%@", CLASS_NAME, error);
        return NO;
    }
    return YES;
}

+ (BOOL)finishZumeroTransactionUsingDatabase:(ZumeroDB *)database
{
    NSError *error = nil;
    
    if (![database close]) {
        DDLogError(@"%@: Failed to close database", CLASS_NAME);
        return NO;
    }
    if (![database commitTX:&error]) {
        DDLogError(@"%@: Failed to commit transaction. Error:%@", CLASS_NAME, error);
        return NO;
    }
    return YES;
}

+ (NSDictionary *)getValuesFromLibraryObject:(LibraryObject *)libraryObject
{
    //NSDictionary *d = [NSDic]
    return nil;
}

@end
