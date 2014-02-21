//
//  OSXFileSelector.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/20/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>


/// Protocol for an object that receives a file path from the OSXFileSelector.
@protocol OSXFileSelectorDelegate <NSObject>

-(void)fileSelector:(id)selector
  didOpenFileAtPath:(NSString *)filePath;

@end

/**
 *  Class to allow the user to select files of a certain format.
 */
@interface OSXFileSelector : NSObject

@property NSArray *allowedFileTypes;
@property id<OSXFileSelectorDelegate> delegate;

/// Return an instance of this class that selects CSV files.
+(OSXFileSelector *)CSVFileSelector;

/// Present a file selector to the user. The path to the file will be sent to the delegate.
-(void)presentFileSelectorToUser;

@end
