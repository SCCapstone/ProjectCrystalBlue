//
//  SourceImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceImportController.h"
#import "LibraryObjectCSVReader.h"
#import "SourceConstants.h"

@implementation SourceImportController

- (id)init
{
    self = [super init];
    if (self) {
        self.fileReader = [[LibraryObjectCSVReader alloc] init];
        self.tableName = [SourceConstants tableName];
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
