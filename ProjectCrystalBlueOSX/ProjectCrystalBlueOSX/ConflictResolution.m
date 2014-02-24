//
//  ConflictResolution.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/23/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ConflictResolution.h"
#import "LibraryObject.h"
#import "Transaction.h"

@implementation ConflictResolution

@synthesize transaction, isLocalMoreRecent;

- (id)initWithTransaction:(Transaction *)resolvedTransaction
   AndIfLocalIsMoreRecent:(BOOL)localMoreRecent
{
    self = [super init];
    if (self)
    {
        self.transaction = resolvedTransaction;
        self.isLocalMoreRecent = localMoreRecent;
    }
    return self;
}

@end
