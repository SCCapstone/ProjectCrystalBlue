//
//  LibraryObjectImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObjectImportController.h"

@implementation LibraryObjectImportController

@synthesize fileReader;
@synthesize importResultReporter;
@synthesize libraryObjectStore;
@synthesize tableName;

-(void)fileSelector:(id)selector
  didOpenFileAtPath:(NSString *)filePath
{
    // Make sure properties are correctly set
    if (!fileReader || !libraryObjectStore || !tableName)
    {
        [NSException raise:@"Null properties"
                    format:@"The fileReader, libraryObjectStore, and tableName properties must be set!"];
        return;
    }
    
    NSArray* libraryObjects = [fileReader readFromFileAtPath:filePath];
    ImportResult *result = [self validateObjects:libraryObjects];
    
    if (![result hasError]) {
        [self addLibraryObjectsToStore:libraryObjects];
    }
    [importResultReporter displayResults:result];
}

-(ImportResult *)validateObjects:(NSArray *)libraryObjects
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.",
     NSStringFromClass(self.class)];
    return nil;
}

-(void)addLibraryObjectsToStore:(NSArray *)libraryObjects
{
    for (LibraryObject *obj in libraryObjects) {
        bool isUpdate = [libraryObjectStore libraryObjectExistsForKey:obj.key
                                                            FromTable:tableName];
        
        if (isUpdate) {
            [libraryObjectStore updateLibraryObject:obj IntoTable:tableName];
        } else {
            [libraryObjectStore putLibraryObject:obj IntoTable:tableName];
        }
    }
}

@end