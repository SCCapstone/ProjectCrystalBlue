//
//  LibraryObjectImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LibraryObjectImportController.h"
#import "LoadingSheet.h"
#import "PCBLogWrapper.h"

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

    [loading.progressIndicator setIndeterminate:NO];

    NSArray* libraryObjects = [fileReader readFromFileAtPath:[fileURL path]];
    [loading.progressIndicator incrementBy:20.00];
    ImportResult *result = [self validateObjects:libraryObjects];
    [loading.progressIndicator incrementBy:30.00];

    if (![result hasError]) {
        [result setSuccessfulImportsCount:(libraryObjects.count - result.duplicateKeys.count)];
        [self addLibraryObjectsToStore:libraryObjects];
    }

    /* Since this method isn't necessarily running on the main thread, we need to make sure that our
     * CoreAnimation calls are dispatched to the main thread */
    dispatch_async(dispatch_get_main_queue(), ^{
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

-(void)validateHeadersInRepresentativeObject:(LibraryObject *)representative
                      againstExpectedHeaders:(NSArray *)expectedHeaders
                            withImportResult:(ImportResult *)result
{
    // First, find any unexpected headers present in the object.
    NSArray *actualHeaders = representative.attributes.allKeys;
    for (NSString *header in actualHeaders) {
        if (![expectedHeaders containsObject:header]) {
            result.hasError = YES;
            [result.unexpectedHeaders addObject:header];
        }
    }
    // Next, make sure that all expected headers are present.
    for (NSString *header in expectedHeaders) {
        if (![actualHeaders containsObject:header]) {
            result.hasError = YES;
            [result.missingHeaders addObject:header];
        }
    }
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