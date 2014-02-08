//
//  LocalTransactionCache.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A wrapper class for a set of "dirty" transactions that have not been applied to a central database or other cloud service.
 *  The transactions are automatically loaded from and written to a PLAINTEXT file on the local filesystem.
 *
 *  DO NOT USE THIS FOR STORING ANY SENSITIVE INFORMATION, AS IT WILL BE STORED IN PLAINTEXT.
 */

@interface LocalTransactionCache : NSObject {
    NSMutableOrderedSet *transactions;
    NSString *filePath;
}

/// The local filename for the transactions.
@property (readonly) NSString *fileName;

/// You must provide a directory for the dirty transaction file to be stored.
-(id)initInDirectory:(NSString *)directory
        withFileName:(NSString *)filename;

/// Add a transaction to the set of dirty transactions.
-(void)add:(NSString *)transaction;

/// Add an array of transactions to the set of dirty transactions.
/// Use this if you are performing multiple transactions, in order to reduce file IO time.
-(void)addAll:(NSArray *)transactions;

/// Remove a transaction from the set of dirty transactions. This should be performed after the transaction is sent to the cloud service.
-(void)remove:(NSString *)transaction;

/// Check if an image transaction is dirty.
-(BOOL)contains:(NSString *)transaction;

/// A count of the number of dirty transactions.
-(NSUInteger)count;

/// Return the set of all of the active transactions (CONSISTENT ORDERING NOT GUARANTEED!)
-(NSSet *)allTransactions;

/// Transaction ordering IS guaranteed to be the same as the order that they were added.
-(NSOrderedSet *)allTransactionsInOrder;

@end
