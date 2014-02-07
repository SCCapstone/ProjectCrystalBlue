//
//  LocalTransactionCache.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LocalTransactionCache.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/**
 *  A wrapper class for a set of "dirty" transactions that have not been applied to a central database or other cloud service.
 *  The transactions are automatically loaded from and written to a PLAINTEXT file on the local filesystem.
 *
 *  DO NOT USE THIS FOR STORING ANY SENSITIVE INFORMATION, AS IT WILL BE STORED IN PLAINTEXT.
 */

#define DELIMITER @"\n"

@implementation LocalTransactionCache

@synthesize fileName;

-(id)init
{
    [NSException raise:@"Wrong Initializer"
                format:@"You must call the initWithDirectory method to instantiate a %@", NSStringFromClass(self.class)];
    return nil;
}

-(id)initInDirectory:(NSString *)directory
        withFileName:(NSString *)aFilename
{
    self = [super init];
    if (self) {
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectories objectAtIndex:0];
        fileName = aFilename;
        filePath = [documentDirectory stringByAppendingFormat:@"/%@/%@", directory, fileName];
        [self loadFromFile];
    }
    return self;
}

-(void)add:(NSString *)transaction
{
    [transactions addObject:transaction];
    [self saveToFile];
}

-(void)addAll:(NSArray *)addedTransactions
{
    [transactions addObjectsFromArray:addedTransactions];
    [self saveToFile];
}

-(void)remove:(NSString *)transaction
{
    [transactions removeObject:transaction];
    [self saveToFile];
}

-(BOOL)contains:(NSString *)transaction
{
    return [transactions containsObject:transaction];
}

-(NSUInteger)count
{
    return [transactions count];
}

-(NSSet *)allTransactions
{
    return [transactions set];
}

-(NSOrderedSet *)allTransactionsInOrder
{
    NSMutableOrderedSet *orderedSet = [[NSMutableOrderedSet alloc] init];
    for (NSString *transaction in transactions) {
        [orderedSet addObject:transaction];
    }
    return orderedSet;
}

/// Save the set of transactions to the file. This completely overwrites the old file everytime.
-(void)saveToFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *fileError;
    // We want to completely overwrite the old file.
    [fileManager removeItemAtPath:filePath error:&fileError];
    
    NSMutableString *fileContents = [[NSMutableString alloc] init];
    for (NSString *transaction in transactions) {
        [fileContents appendFormat:@"%@%@", transaction, DELIMITER];
    }
    
    NSData *fileData = [fileContents dataUsingEncoding:NSASCIIStringEncoding];
    [fileManager createFileAtPath:filePath
                         contents:fileData
                       attributes:nil];
    
    DDLogDebug(@"Successfully saved %@ to %@", NSStringFromClass(self.class), filePath);
}

/// Populates the set of dirty transactions from the file. If no file exists, create an empty file and an empty set.
-(void)loadFromFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    transactions = [[NSMutableOrderedSet alloc] init];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        // We need to create the file.
        NSData *emptyFile = [[NSData alloc] init];
        [fileManager createFileAtPath:filePath contents:emptyFile attributes:nil];
        return;
    }
    
    NSError *fileReadError;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSASCIIStringEncoding
                                                          error:&fileReadError];
    
    NSScanner *scanner = [NSScanner scannerWithString:fileContents];
    while (![scanner isAtEnd]) {
        NSString *transaction = @"";
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:&transaction];
        [transactions addObject:transaction];
    }
    
    DDLogDebug(@"Successfully loaded %@ from %@", NSStringFromClass(self.class), filePath);
}

@end