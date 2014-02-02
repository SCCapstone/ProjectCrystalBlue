//
//  ZumeroUtils.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ZumeroUtils.h"
#import "ZumeroLibraryObjectStore.h"

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
        NSLog(@"%@: Failed to create zumero table: %@. Error:%@", CLASS_NAME, tableName, error);
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
        NSLog(@"%@: Failed to open database. Error:%@", CLASS_NAME, error);
        return NO;
    }
    if (![database beginTX:&error]) {
        NSLog(@"%@: Failed to begin transaction. Error:%@", CLASS_NAME, error);
        return NO;
    }
    return YES;
}

+ (BOOL)finishZumeroTransactionUsingDatabase:(ZumeroDB *)database
{
    NSError *error = nil;
    
    if (![database close]) {
        NSLog(@"%@: Failed to close database", CLASS_NAME);
        return NO;
    }
    if (![database commitTX:&error]) {
        NSLog(@"%@: Failed to commit transaction. Error:%@", CLASS_NAME, error);
        return NO;
    }
    return YES;
}

@end
