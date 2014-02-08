//
//  ZumeroDBDelegate.h
//  zumero-ios
//
//  Copyright (c) 2013 Zumero LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZumeroDBDelegate <NSObject>

- (void) syncSuccess:(NSString *)dbname;
- (void) syncFail:(NSString *)dbname err:(NSError *)err;

@optional
- (void) syncProgress:(NSString *)dbname partial:(NSInteger)partial;

@end
