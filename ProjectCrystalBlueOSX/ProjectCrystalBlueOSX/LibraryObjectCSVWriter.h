//
//  LibraryObjectCSVWriter.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObjectFileWriter.h"
#import "CHCSVParser.h"

/**
 *  Class for writing an Array of library objects to a CSV file.
 */
@interface LibraryObjectCSVWriter : NSObject <LibraryObjectFileWriter, CHCSVParserDelegate> {
    CHCSVWriter *csvWriter;
}

@end
