//
//  LibraryObjectFileReader.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This protocol defines behaviors required for a class that imports LibraryObjects from a file.
 */
@protocol LibraryObjectFileReader <NSObject>

/// Read an Array of LibraryObjects from an NSInputStream.
-(NSArray *)readFromFileAtPath:(NSString *)filePath;

/// The MIME Content type of the files read by this LibraryObjectFileReader.
@optional
+(NSString *)fileFormat;

@end
