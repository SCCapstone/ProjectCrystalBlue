//
//  ZumeroLibraryObjectStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObjectStore.h"

@interface ZumeroLibraryObjectStore : NSObject <LibraryObjectStore>

+ (ZumeroLibraryObjectStore *)database;

@end
