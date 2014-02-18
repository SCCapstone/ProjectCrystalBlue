//
//  LibraryObjectFileWriter.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This protocol defines behaviors required for a class that writes LibraryObjects to a file.
 */
@protocol LibraryObjectFileWriter <NSObject>

/// Write an Array of LibraryObjects to a file at a given path.
-(void)writeObjects:(NSArray *)libraryObjects
       ToFileAtPath:(NSString *)filePath;

/// The MIME Content type of the files read by this LibraryObjectFileWriter.
@optional
+(NSString *)fileFormat;

@end
