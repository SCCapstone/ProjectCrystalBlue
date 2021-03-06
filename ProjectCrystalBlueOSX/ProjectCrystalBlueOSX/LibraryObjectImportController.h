//
//  LibraryObjectImportController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSXFileSelector.h"
#import "LibraryObjectFileReader.h"
#import "ImportResult.h"
#import "AbstractLibraryObjectStore.h"

/**
 *  Abstract class to coordinate importing LibraryObjects from an external file. Sub-classes must:
 *      - implement the validateObjects method
 *      - populate the fileReader, libraryObjectStore, and tableName properties
 *      - optionally, set the importResultReporter property.
 */
@interface LibraryObjectImportController : NSObject <OSXFileSelectorDelegate>

@property id<LibraryObjectFileReader> fileReader;
@property NSObject<ImportResultReporter> *importResultReporter;
@property AbstractLibraryObjectStore *libraryObjectStore;
@property NSString *tableName;

/// Check that all LibraryObjects have the correct attributes and the attribute values are valid.
/// This should not be called by external classes - use the proper validation utility classes.
-(ImportResult *)validateObjects:(NSArray *)libraryObjects;

/// Check that the library object has the expected headers. The results will be placed in the
/// result argument. This should not be called by external classes, only by subclasses of
/// LibraryObjectImportController.
-(void)validateHeadersInRepresentativeObject:(LibraryObject *)representative
                      againstExpectedHeaders:(NSArray *)expectedHeaders
                            withImportResult:(ImportResult *)result;

@end
