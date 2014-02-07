//
//  DirtyKeySet.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "DirtyKeySet.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/**
 *  A wrapper class for a set of dirty image keys. They are automatically loaded and written to a plaintext
 *  file on the local filesystem.
 */

#define FILE_NAME @"dirty_keys.txt"
#define DELIMITER @"\n"

@implementation DirtyKeySet

-(id)init
{
    [NSException raise:@"Wrong Initializer"
                format:@"You must call the initWithDirectory method to instantiate a %@", NSStringFromClass(self.class)];
    return nil;
}

-(id)initInDirectory:(NSString *)directory
{
    self = [super init];
    if (self) {
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectories objectAtIndex:0];
        filePath = [documentDirectory stringByAppendingFormat:@"/%@/%@", directory, [self.class fileName]];
        [self loadFromFile];
    }
    return self;
}

-(void)add:(NSString *)key
{
    [dirtyKeys addObject:key];
    [self saveToFile];
}

-(void)addAll:(NSSet *)keys
{
    [dirtyKeys addObjectsFromArray:[keys allObjects]];
    [self saveToFile];
}

-(void)remove:(NSString *)key
{
    [dirtyKeys removeObject:key];
    [self saveToFile];
}

-(BOOL)contains:(NSString *)key
{
    return [dirtyKeys containsObject:key];
}

-(NSUInteger)count
{
    return [dirtyKeys count];
}

-(NSSet *)allKeys
{
    return [[NSSet alloc] initWithSet:dirtyKeys];
}

/// Save the set of keys to the file. This completely overwrites the old file everytime.
-(void)saveToFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *fileError;
    // We want to completely overwrite the old file.
    [fileManager removeItemAtPath:filePath error:&fileError];
    
    NSMutableString *fileContents = [[NSMutableString alloc] init];
    for (NSString *key in dirtyKeys) {
        [fileContents appendFormat:@"%@%@", key, DELIMITER];
    }
    
    NSData *fileData = [fileContents dataUsingEncoding:NSASCIIStringEncoding];
    [fileManager createFileAtPath:filePath
                         contents:fileData
                       attributes:nil];
    
    DDLogDebug(@"Successfully saved %@ to %@", NSStringFromClass(self.class), filePath);
}

/// Populates the set of dirtykeys from the file. If no file exists, create an empty file and an empty set.
-(void)loadFromFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    dirtyKeys = [[NSMutableSet alloc] init];
    
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
        NSString *key = @"";
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:&key];
        [dirtyKeys addObject:key];
    }
    
    DDLogDebug(@"Successfully loaded %@ from %@", NSStringFromClass(self.class), filePath);
}

+(NSString *)fileName {
    return FILE_NAME;
}

@end