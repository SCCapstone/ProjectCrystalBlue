//
//  ZumeroUtils.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Zumero.h>

@class LibraryObject;

@interface ZumeroUtils : NSObject

+ (BOOL)createZumeroTableWithName:(NSString *)tableName
                        AndFields:(NSDictionary *)fields
                    UsingDatabase:(ZumeroDB *)database;

+ (BOOL)zumeroTableExistsWithName:(NSString *)tableName
                    UsingDatabase:(ZumeroDB *)database;

+ (BOOL)startZumeroTransactionUsingDatabase:(ZumeroDB *)database;

+ (BOOL)finishZumeroTransactionUsingDatabase:(ZumeroDB *)database;

+ (NSDictionary *)getValuesFromLibraryObject:(LibraryObject *)libraryObject;

@end
