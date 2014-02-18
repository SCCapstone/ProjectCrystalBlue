//
//  LibraryObjectCSVReader.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObjectFileReader.h"
#import "CHCSVParser.h"

/**
 *  Class for reading an Array of library objects from a CSV file.
 */
@interface LibraryObjectCSVReader : NSObject <LibraryObjectFileReader> {
    CHCSVParser *csvParser;
}

@end
