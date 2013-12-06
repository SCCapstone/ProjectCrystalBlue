//
//  SQLiteWrapper.m
//  ProjectCrystalBlueOSX
//
//  Adapter class to interface with the SQLite C library.
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "zumero_register.h"
#import "Sample.h"

@interface SQLiteWrapper : NSObject {
    sqlite3 *db;
}

// Execute a QUERY command against the local SQLite database
-(NSArray *) performQuery:(NSString *)query;

// Retrieve all the samples in the SQLite database. Returns an array of Sample objects.
-(NSMutableArray *) getSamples;

// Add a sample object to the SQLite database.
-(void) insertSample:(Sample *)sample;

// Submits a change to the SQLite database.
-(void) updateSample:(Sample *)sample;

// Remove a sample from the SQLite database.
-(void) deleteSample:(Sample *)sample;

// Sync local database with zumero database
-(void) sync;

// Get storage usage facts from zumero database
-(void) storageUsage;

@end
