//
//  ZumeroUtils.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZumeroUtils : NSObject

+ (BOOL)createZumeroTableWithName:(NSString *)tableName;

+ (BOOL)zumeroTableExistsWithName:(NSString *)tableName;

@end
