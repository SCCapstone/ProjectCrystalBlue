//
//  SampleImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleImportController.h"
#import "LibraryObjectCSVReader.h"
#import "SampleConstants.h"

@implementation SampleImportController

- (id)init
{
    self = [super init];
    if (self) {
        self.fileReader = [[LibraryObjectCSVReader alloc] init];
        self.tableName = [SampleConstants tableName];
    }
    return self;
}

-(ImportResult *)validateObjects:(NSArray *)libraryObjects
{
    ImportResult *result = [[ImportResult alloc] init];
    [result setHasError:NO];
    // TODO - implement validation
    return result;
}

@end
