//
//  LibraryObjectExportController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/24/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSXSaveSelector.h"
#import "LibraryObjectFileWriter.h"

@interface LibraryObjectExportController : NSObject <OSXSaveSelectorDelegate>

@property NSArray *objectsToWrite;
@property id<LibraryObjectFileWriter> writer;

@end
