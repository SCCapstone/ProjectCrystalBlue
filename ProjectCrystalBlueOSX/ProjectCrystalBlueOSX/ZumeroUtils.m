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
#import <Zumero.h>

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"ZumeroUtils"

@implementation ZumeroUtils

+ (ZumeroDB *)initializeZumeroDatabaseWithName:(NSString *)databaseName
                               AndWithDelegate:(id)delegate
                         AndWithLocalDirectory:(NSString *)directory
{
    // Setup local directory
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *localDirectory = [documentsDirectory stringByAppendingPathComponent:directory];
    
    BOOL directoryExists;
    [[NSFileManager defaultManager] fileExistsAtPath:localDirectory isDirectory:&directoryExists];
    if (!directoryExists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    
    // HARDCODED FOR NOW BUT HOST WILL HAVE TO BE SPECIFIED FOR RELEASE
    ZumeroDB *zumeroDB = [[ZumeroDB alloc] initWithName:databaseName
                                                 folder:localDirectory
                                                   host:@"https://zinst7655bd1e667.s.zumero.net"];
    zumeroDB.delegate = delegate;
    
    NSError *error = nil;
    // Create new local zumero database if it doesn't exist
    if (![zumeroDB exists]) {
        if (![zumeroDB createDB:&error]) {
            DDLogError(@"%@: Failed to create zumero database. Error: %@", CLASS_NAME, error);
            return nil;
        }
    }
    
    return zumeroDB;
}

+ (BOOL)createZumeroTableWithName:(NSString *)tableName
                        AndFields:(NSDictionary *)fields
                    UsingDatabase:(ZumeroDB *)database
{
    if ([self zumeroTableExistsWithName:tableName UsingDatabase:database])
        return YES;
    
    NSError *error = nil;
    
    [self startZumeroTransactionUsingDatabase:database];
    
    // Create a new Zumero table
    if(![database defineTable:tableName fields:fields error:&error]) {
        DDLogError(@"%@: Failed to create zumero table: %@. Error: %@", CLASS_NAME, tableName, error);
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
    
    // Open database
    if (![database open:&error]) {
        DDLogError(@"%@: Failed to open database. Error: %@", CLASS_NAME, error);
        return NO;
    }
    // Begin transaction
    if (![database beginTX:&error]) {
        DDLogError(@"%@: Failed to begin transaction. Error: %@", CLASS_NAME, error);
        return NO;
    }
    return YES;
}

+ (BOOL)finishZumeroTransactionUsingDatabase:(ZumeroDB *)database
{
    NSError *error = nil;
    
    // Commit transaction
    if (![database commitTX:&error]) {
        DDLogError(@"%@: Failed to commit transaction. Error:%@", CLASS_NAME, error);
        return NO;
    }
    // Close database
    if (![database close]) {
        DDLogError(@"%@: Failed to close database", CLASS_NAME);
        return NO;
    }
    return YES;
}

+ (NSDictionary *)syncScheme
{
    return @{
             @"scheme_type": @"internal",
             @"dbfile": @"zumero_users_admin"
             };
}

@end
