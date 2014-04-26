//
//  SplitImportController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObjectImportController.h"

/**
 *  Abstract class to coordinate importing LibraryObjects from an external file. Sub-classes must:
 *      - implement the validateObjects method
 *      - populate the fileReader, libraryObjectStore, and tableName properties
 *      - optionally, set the importResultReporter property.
 */
@interface SplitImportController : LibraryObjectImportController

@end
