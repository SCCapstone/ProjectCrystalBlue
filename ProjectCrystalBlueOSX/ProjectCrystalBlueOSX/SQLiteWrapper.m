//
//  SQLiteWrapper.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import "SQLiteWrapper.h"

@implementation SQLiteWrapper

-(id)init {
    self = [super init];
    if (self) {
        sqlite3 *dbConnection;
        // Try to open temporary database
        if (sqlite3_open(NULL, &dbConnection) != SQLITE_OK) {
            NSLog(@"Failed to open database");
            return nil;
        }
        db = dbConnection;
        
        // Create sample database
        NSString *sql = @"CREATE TABLE samples("
                        "rockType TEXT,"
                        "rockId INTEGER PRIMARY KEY,"
                        "coordinates TEXT,"
                        "isPulverized INTEGER);";
        [self performQuery:sql];
    }
    return self;
}

-(NSArray *)performQuery:(NSString *)query {
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


@end
