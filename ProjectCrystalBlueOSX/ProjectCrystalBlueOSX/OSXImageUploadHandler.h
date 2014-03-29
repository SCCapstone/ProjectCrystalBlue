//
//  OSXImageUploadHandler.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSXFileSelector.h"
@class Source;
@class AbstractLibraryObjectStore;

/// Delegate to handle image uploads from an OSXFileSelector.
@interface OSXImageUploadHandler : NSObject <OSXFileSelectorDelegate>

@property Source *source;
@property AbstractLibraryObjectStore *dataStore;
@property NSString *tag;

@end
