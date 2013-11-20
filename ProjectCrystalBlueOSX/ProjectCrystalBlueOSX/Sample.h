//
//  Sample.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sample : NSObject

@property(readwrite, copy) NSString* rockType;
@property(readwrite) int rockId;
@property(readwrite, copy) NSString* coordinates;
@property(readwrite) bool isPulverized;

@end
