//
//  ConflictResolution.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/23/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Transaction;
@class LibraryObject;

@interface ConflictResolution : NSObject

@property Transaction *transaction;
@property BOOL isLocalMoreRecent;

- (id)initWithTransaction:(Transaction *)resolvedTransaction
   AndIfLocalIsMoreRecent:(BOOL)isLocalMoreRecent;

@end
