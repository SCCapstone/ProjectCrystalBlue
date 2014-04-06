//
//  ImportResult.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ImportResult.h"

@implementation ImportResult

- (instancetype)init
{
    self = [super init];
    if (self) {
        keysOfInvalidLibraryObjects = [[NSMutableArray alloc] init];
        duplicateKeys = [[NSMutableArray alloc] init];
        hasError = YES;
    }
    return self;
}

@synthesize hasError;
@synthesize keysOfInvalidLibraryObjects;
@synthesize duplicateKeys;

@end
