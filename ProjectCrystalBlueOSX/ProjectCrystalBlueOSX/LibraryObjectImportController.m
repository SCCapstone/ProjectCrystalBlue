//
//  LibraryObjectImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObjectImportController.h"
#import "LoadingSheet.h"

@implementation LibraryObjectImportController

@synthesize fileReader;
@synthesize importResultReporter;
@synthesize libraryObjectStore;
@synthesize tableName;

-(void)fileSelectorDidOpenFileAtURL:(NSURL *)fileURL
{
    // Make sure properties are correctly set
    if (!fileReader || !libraryObjectStore || !tableName)
    {
        [NSException raise:@"Null properties"
                    format:@"The fileReader, libraryObjectStore, and tableName properties must be set!"];
        return;
    }

    LoadingSheet *loading = [[LoadingSheet alloc] init];
    [loading activateSheetWithParentWindow:[NSApp keyWindow]
                                   AndText:@"Importing CSV file. This may take a few minutes for large files."];

    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [loading.progressIndicator setIndeterminate:NO];

        NSArray* libraryObjects = [fileReader readFromFileAtPath:[fileURL path]];
        [loading.progressIndicator incrementBy:20.00];
        ImportResult *result = [self validateObjects:libraryObjects];
        [loading.progressIndicator incrementBy:30.00];
    
        if (![result hasError]) {
            [self addLibraryObjectsToStore:libraryObjects];
            [loading.progressIndicator incrementBy:50.00];
        }
        [loading closeSheet];
        [importResultReporter displayResults:result];
    });
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