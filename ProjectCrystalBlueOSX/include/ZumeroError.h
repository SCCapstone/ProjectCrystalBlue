//
//  ZumeroError.h
//  zumero-ios
//
//  Copyright (c) 2013 Zumero LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "sqlite3.h"

@interface ZumeroError : NSError

+ (void) logError:(int)zcode db:(sqlite3 *)db path:(NSString *)path error:(NSError **)error;
+ (void) logZumeroError:(int)zcode text:(NSString *)text path:(NSString *)path error:(NSError **)error;

+ (int) zumeroErrOffset;

@end
