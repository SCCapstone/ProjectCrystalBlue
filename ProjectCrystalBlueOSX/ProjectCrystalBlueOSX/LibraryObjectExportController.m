//
//  LibraryObjectExportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/24/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObjectExportController.h"
#import "PCBLogWrapper.h"

@implementation LibraryObjectExportController

@synthesize objectsToWrite;
@synthesize writer;

-(void)saveSelector:(id)selector
      choseSavePath:(NSString *)filePath
{
    if (!writer || !objectsToWrite) {
        [NSException raise:@"Null properties"
                    format:@"The fileReader, libraryObjectStore, and tableName properties must be set!"];
        return;
    }
    
    if (objectsToWrite.count <= 0) {
        DDLogInfo(@"%@: Nothing to write!", NSStringFromClass(self.class));
        return;
    }
    
    [writer writeObjects:objectsToWrite ToFileAtPath:filePath];
    DDLogInfo(@"%@: Wrote %lu objects to %@", NSStringFromClass(self.class), objectsToWrite.count, filePath);
}

@end
