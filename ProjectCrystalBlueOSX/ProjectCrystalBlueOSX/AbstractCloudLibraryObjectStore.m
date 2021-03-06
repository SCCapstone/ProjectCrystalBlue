//
//  AbstractCloudLibraryObjectStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AbstractCloudLibraryObjectStore.h"
#import "PCBLogWrapper.h"

@implementation AbstractCloudLibraryObjectStore

- (id)initInLocalDirectory:(NSString *)directory
         WithDatabaseName:(NSString *)databaseName
{
    return [super initInLocalDirectory:directory WithDatabaseName:databaseName];
}

- (BOOL)synchronizeWithCloud
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

- (BOOL)setupDomains
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

@end
