//
//  OSXSaveSelector.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/24/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Protocol for an object that receives a file path from the OSXSaveSelector.
@protocol OSXSaveSelectorDelegate <NSObject>

-(void)saveSelector:(id)selector
      choseSavePath:(NSString *)filePath;

@end

@interface OSXSaveSelector : NSObject

@property id<OSXSaveSelectorDelegate> delegate;

-(void)presentSaveSelectorToUser;

@end
