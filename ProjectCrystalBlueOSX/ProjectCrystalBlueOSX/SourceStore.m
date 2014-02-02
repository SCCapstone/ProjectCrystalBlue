//
//  SourceStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceStore.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourceStore()

- (void)syncSuccess:(NSString *)dbname;
- (void)syncFail:(NSString *)dbname err:(NSError *)err;

@end

static BOOL singletonInstantiated = NO;
static NSString *dbName = @"testdb1_v2";
static NSString *tableName = @"folks";
ZumeroDB *zumeroDB;

@implementation SourceStore

- (void)setupZumero
{
    if (singletonInstantiated)
        return;
    
    zumeroDB = [[ZumeroDB alloc] initWithName:dbName
                                       folder:nil
                                         host:@"https://zinst7655bd1e667.s.zumero.net"];
    zumeroDB.delegate = self;
    
    BOOL ok = YES;
    NSError *err = nil;
    
    if (![zumeroDB exists])
        ok = [zumeroDB createDB:&err];
    
    if (!ok)
        NSLog(@"Failed to create db");
    
    if(![zumeroDB open:&err])
        NSLog(@"Failed to open db");
    
    [self createTable];
    
    singletonInstantiated = YES;
}

- (void)synchronize
{
    NSDictionary *scheme = @{
         @"scheme_type": @"internal",
         @"dbfile": @"zumero_users_admin"
     };
    
    NSError *err = nil;
    
    NSArray *rows = [self getObjects];
    NSLog(@"About to sync %@", rows);
    
    if(![zumeroDB sync:scheme user:@"admin" password:@"pcbcsce490" error:&err])
        NSLog(@"Failed to sync db");
    
    NSLog(@"%@", err);
}

- (void)createTable
{
    if ([zumeroDB tableExists:tableName])
        return;
    
    NSError *err = nil;
    NSDictionary *fields =
        @{
          @"id": @{@"type": @"text", @"not_null": [NSNumber numberWithBool:YES], @"primary_key": [NSNumber numberWithBool:YES]},
          @"nickname": @{@"type": @"text"},
          @"age": @{@"type": @"int"}
          };
    
    if (![zumeroDB beginTX:&err])
        NSLog(@"createTable - beginTX failed.");
    
    if(![zumeroDB defineTable:tableName fields:fields error:&err])
        NSLog(@"createTable - defineTable failed.");
    
    if(![zumeroDB commitTX:&err])
        NSLog(@"createTable - commitTX failed.");
}

- (void)insertObject
{
    if ([zumeroDB tableExists:tableName])
        return;
    
    NSError *err = nil;
    NSDictionary *vals =
        @{
          @"id": @"thisisunique",
          @"nickname": @"fredo",
          @"age": [NSNumber numberWithInt:25]
          };

    if (![zumeroDB beginTX:&err])
        NSLog(@"insertObject - beginTX failed.");
    
    if(![zumeroDB insertRecord:tableName values:vals inserted:nil error:&err])
        NSLog(@"insertObject - insertRecord failed.");
    
    if(![zumeroDB commitTX:&err])
        NSLog(@"insertObject - commitTX failed.");
}

- (NSArray *)getObjects
{
    NSError *err= nil;
    NSArray *rows = nil;
    
    if (![zumeroDB beginTX:&err])
        NSLog(@"getObjects - beginTX failed.");
    
    if(![zumeroDB selectSql:@"select * from folks" values:nil rows:&rows error:&err])
        NSLog(@"getObjects - selectSql failed.");
    
    if(![zumeroDB commitTX:&err])
        NSLog(@"getObjects - commitTX failed.");
    
    return rows;
}

- (void)syncSuccess:(NSString *)dbname
{
    NSLog(@"Success!");
    NSArray *table = [self getObjects];
}

- (void)syncFail:(NSString *)dbname err:(NSError *)err
{
    NSLog(@"Failure, ;(");
    NSArray *table = [self getObjects];
}

@end
