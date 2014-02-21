//
//  Transaction.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionConstants.h"

@interface Transaction : NSObject

@property(readonly) NSNumber *timestamp;
@property NSMutableDictionary *attributes;

- (id)initWithLibraryObjectKey:(NSString *)key
              AndWithTableName:(NSString *)tableName
         AndWithSqlCommandType:(NSString *)sqlCommand;

- (id)initWithTimestamp:(NSNumber *)aTimestamp
AndWithAttributeDictionary:(NSDictionary *)attr;

@end
