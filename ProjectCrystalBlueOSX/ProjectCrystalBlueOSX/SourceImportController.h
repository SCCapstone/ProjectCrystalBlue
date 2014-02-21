//
//  SourceImportController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObjectImportController.h"

/**
 *  Class to coordinate importing Source objects from an external file. Sub-classes must:
 *      - implement the validateObjects method
 *      - populate the fileReader, libraryObjectStore, and tableName properties
 *      - optionally, set the importResultReporter property.
 */
@interface SourceImportController : LibraryObjectImportController

@end
