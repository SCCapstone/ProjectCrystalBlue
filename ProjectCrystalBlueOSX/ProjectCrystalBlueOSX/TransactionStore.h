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
 *
 *  The time of last sync will not be included.
 */
- (NSArray *)getAllTransactions;

/** Retrieve transaction that associated with the library object key that has not be 
 *  pushed to the remote database.
 */
- (Transaction *)getTransactionWithLibraryObjectKey:(NSString *)key;

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

/** Returns the last sync time from the transaction table.
 *
 *  This is always stored as the first row in the database.
 */
- (NSTimeInterval)timeOfLastSync;

/** Returns an array of ConflictResolution objects which represents whether the remote or local
 *  version of an object is more recent.
 *
 *  This should only be called by a AbstractCloudLibraryObjectStore when syncing as this method
 *  changes data stored in the table.
 */
- (NSArray *)resolveConflicts:(NSArray *)transactions;

@end
