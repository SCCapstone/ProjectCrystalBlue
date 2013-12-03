//
//  SQLiteWrapper.m
//  ProjectCrystalBlueOSX
//
//  Adapter class to interface with the SQLite C library.
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "SQLiteWrapper.h"

@implementation SQLiteWrapper

// The constructor not only initializes the adapter, but also attempts to
// open the current local SQLite database.
-(id)init {
    self = [super init];
    if (self) {
        sqlite3 *dbConnection;
        // Try to open temporary database
        if (sqlite3_open("test.db", &dbConnection) != SQLITE_OK) {
            NSLog(@"Failed to open database");
            return nil;
        }
        db = dbConnection;
        
        // Create sample database
        NSString *sql = @"CREATE TABLE IF NOT EXISTS samples("
                        "rockType TEXT,"
                        "rockId INTEGER PRIMARY KEY,"
                        "coordinates TEXT,"
                        "isPulverized INTEGER);";
        [self performQuery:sql];
    }
    return self;
}

// Execute a query command against the local SQLite database
-(NSArray *)performQuery:(NSString *)query {
    
    NSLog(@"SQLiteWrapper: sending query \"%@\"", query);
    
    sqlite3_stmt *statement = nil;
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare query");
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSMutableArray *row = [NSMutableArray array];
        for (int i=0; i<sqlite3_column_count(statement); i++) {
            int colType = sqlite3_column_type(statement, i);
            id value;
            if (colType == SQLITE_TEXT) {
                const unsigned char *col = sqlite3_column_text(statement, i);
                value = [NSString stringWithFormat:@"%s", col];
            } else if (colType == SQLITE_INTEGER) {
                int col = sqlite3_column_int(statement, i);
                value = [NSNumber numberWithInt:col];
            } else if (colType == SQLITE_FLOAT) {
                double col = sqlite3_column_double(statement, i);
                value = [NSNumber numberWithDouble:col];
            } else if (colType == SQLITE_NULL) {
                value = [NSNull null];
            } else {
                NSLog(@"Unknown datatype");
            }
            
            [row addObject:value];
        }
        [result addObject:row];
    }
    return result;
}

// Retrieve all the samples in the SQLite database. Returns an array of Sample objects.
-(NSMutableArray *) getSamples {
    NSString *sql = @"SELECT * FROM samples";
    NSArray *result = [self performQuery:sql];
    NSMutableArray *samples = [[NSMutableArray alloc] init];
    if (result != nil) {
        for (int i=0; i<[result count]; i++) {
            Sample *sample = [[Sample alloc] initWithRockType:[[result objectAtIndex:i] objectAtIndex:0]
                                                  AndRockId:(int)[[result objectAtIndex:i] objectAtIndex:1]
                                             AndCoordinates:[[result objectAtIndex:i] objectAtIndex:2]
                                              AndIsPulverized:(bool)[[result objectAtIndex:i] objectAtIndex:3]];
            [samples addObject:sample];
        }
        return samples;
    }
    return nil;
}

// Add a sample object to the SQLite database.
-(void) insertSample:(Sample *)sample {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO samples(rockType,rockId,coordinates,isPulverized) "
                     "VALUES ('%@',%d,'%@',%d);", [sample rockType], (int)[sample rockId], [sample coordinates],
                     [sample isPulverized] ? 1 : 0];
    [self performQuery:sql];
}

// Submits a change to the SQLite database.
-(void) updateSample:(Sample *)sample {
    
}

// Remove a sample from the SQLite database.
-(void) deleteSample:(Sample *)sample {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM samples WHERE rockId=%d;", (int)[sample rockId]];
    [self performQuery:sql];
}


@end
