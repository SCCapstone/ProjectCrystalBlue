//
//  Sample.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sample : NSObject

@property(atomic) NSString* rockType;
@property(atomic) int rockId;
@property(atomic) NSString* coordinates;
@property(atomic) bool isPulverized;

@end
