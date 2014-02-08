//
//  ZumeroRule.h
//  Zumero
//
//  Copyright (c) 2013 Zumero LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZumeroRule : NSObject

+ (NSString *) action_default;
+ (NSString *) action_accept;
+ (NSString *) action_ignore;
+ (NSString *) action_reject;
+ (NSString *) action_column_merge;
+ (NSString *) action_attempt_text_merge;
+ (NSString *) situation_del_after_mod;
+ (NSString *) situation_mod_after_del;
+ (NSString *) situation_mod_after_mod;

@end
