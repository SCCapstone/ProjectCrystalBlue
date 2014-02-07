//
//  SimpleDBLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SimpleDBLibraryObjectStore.h"
#import "AbstractLibraryObjectStore.h"
#import "LocalLibraryObjectStore.h"
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import "HardcodedCredentialsProvider.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define CLASS_NAME @"SimpleDBLibraryObjectStore"

@interface SimpleDBLibraryObjectStore()
{
    AmazonSimpleDBClient *simpleDBClient;
    AbstractLibraryObjectStore *localStore;
    //DirtyKeySet *dirtyKeys;
}
@end


@implementation SimpleDBLibraryObjectStore

- (id)initWithLocalDirectory:(NSString *)directory
{
    self = [super initWithLocalDirectory:directory];
    
    if (self) {
        localStore = [[LocalLibraryObjectStore alloc] initWithLocalDirectory:directory];
        // initialize dirty key here
        
        //NSObject<AmazonCredentialsProvider> *credentialsProvider = [[HardcodedCredentialsProvider alloc] init];
        //simpleDBClient = [[AmazonSimpleDBClient alloc] initWithCredentialsProvider:credentialsProvider];
    }
    
    return self;
}

- (LibraryObject *)getLibraryObjectForKey:(NSString *)key
{
    return nil;
}

- (BOOL)putLibraryObject:(LibraryObject *)libraryObject
                  forKey:(NSString *)key
{
    return NO;
}

- (BOOL)deleteLibraryObjectWithKey:(NSString *)key
{
    return NO;
}

- (BOOL)libraryObjectExistsForKey:(NSString *)key
{
    return NO;
}

- (BOOL)synchronizeWithCloud
{
    return NO;
}

- (BOOL)keyIsDirty:(NSString *)key
{
    return NO;
}

@end
