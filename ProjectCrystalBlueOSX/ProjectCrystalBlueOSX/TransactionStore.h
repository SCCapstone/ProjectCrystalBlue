//
//  TransactionStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transaction.h"

@interface TransactionStore : NSObject

- (id)initInLocalDirectory:(NSString *)directory
          WithDatabaseName:(NSString *)databaseName;

/** Retrieve all of the transactions that have not been pushed to the remote database.
 */
- (NSArray *)getAllTransactions;

/** Add a new transaction to the TransactionStore. The timestamp attribute is used as the
 *  primary key and should represent the time the operation was executed locally.
 *
 *  Returns YES if the operation is successful; NO if it is unsuccessful.
 */
- (BOOL)commitTransaction:(Transaction *)transaction;

/** Removes all transactions from the transaction table.  
 *
 *  This should only be done once all local transactions have been committed to the remote
 *  database.
 */
- (BOOL)clearLocalTransactions;

/**
 *
 */
- (NSTimeInterval)timeOfLastSync;

@end
