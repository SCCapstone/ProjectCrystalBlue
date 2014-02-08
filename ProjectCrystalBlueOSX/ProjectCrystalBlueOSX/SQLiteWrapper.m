////
////  SQLiteWrapper.m
////  ProjectCrystalBlueOSX
////
////  Adapter class to interface with the SQLite C library.
////
////  Created by Justin Baumgartner on 11/19/13.
////  Copyright (c) 2013 Logan Hood. All rights reserved.
////
//
//#import "SQLiteWrapper.h"
//#import "DDLog.h"
//
//@implementation SQLiteWrapper
//
//// The constructor not only initializes the adapter, but also attempts to
//// open the current local SQLite database.
//-(id)init {
//    self = [super init];
//    if (self) {
//        sqlite3 *dbConnection;
//        // Try to open temporary database
//        if (sqlite3_open("test2.db", &dbConnection) != SQLITE_OK) {
//            NSLog(@"Failed to open database");
//            return nil;
//        }
//        db = dbConnection;
//        zumero_register(db);
//        
////        // Create sample database
////        NSString *sql = @"CREATE VIRTUAL TABLE IF NOT EXISTS samples USING zumero("
////                        "rockType TEXT,"
////                        "rockId INTEGER PRIMARY KEY,"
////                        "coordinates TEXT,"
//////                        "isPulverized INTEGER);";
////        NSString *sql = @"DROP TABLE samples;";
////        [self performQuery:sql];
//        [self sync];
//    }
//    return self;
//}
//
//// Execute a query command against the local SQLite database
//-(NSArray *)performQuery:(NSString *)query {
//    sqlite3_stmt *statement = nil;
//    const char *sql = [query UTF8String];
//    int resultCode = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
//    if (resultCode != SQLITE_OK) {
//        NSLog(@"Failed to prepare query");
//        return nil;
//    }
//    NSMutableArray *result = [NSMutableArray array];
//    while (sqlite3_step(statement) == SQLITE_ROW) {
//        NSMutableArray *row = [NSMutableArray array];
//        for (int i=0; i<sqlite3_column_count(statement); i++) {
//            int colType = sqlite3_column_type(statement, i);
//            id value;
//            if (colType == SQLITE_TEXT) {
//                const unsigned char *col = sqlite3_column_text(statement, i);
//                value = [NSString stringWithFormat:@"%s", col];
//            } else if (colType == SQLITE_INTEGER) {
//                int col = sqlite3_column_int(statement, i);
//                value = [NSNumber numberWithInt:col];
//            } else if (colType == SQLITE_FLOAT) {
//                double col = sqlite3_column_double(statement, i);
//                value = [NSNumber numberWithDouble:col];
//            } else if (colType == SQLITE_NULL) {
//                value = [NSNull null];
//            } else {
//                NSLog(@"Unknown datatype");
//            }
//            
//            [row addObject:value];
//        }
//        [result addObject:row];
//    }
//    NSLog(@"%@",result);
//    return result;
//}
//
//// Retrieve all the samples in the SQLite database. Returns an array of Sample objects.
//-(NSMutableArray *) getSamples {
//    NSString *sql = @"SELECT * FROM samples";
//    NSArray *result = [self performQuery:sql];
//    NSMutableArray *samples = [[NSMutableArray alloc] init];
//    if (result != nil) {
//        for (int i=0; i<[result count]; i++) {
//            Sample *sample = [[Sample alloc] initWithRockType:[[result objectAtIndex:i] objectAtIndex:0]
//                                                  AndRockId:[[[result objectAtIndex:i] objectAtIndex:1] integerValue]
//                                             AndCoordinates:[[result objectAtIndex:i] objectAtIndex:2]
//                                              AndIsPulverized:[[[result objectAtIndex:i] objectAtIndex:3] boolValue]];
//            [samples addObject:sample];
//        }
//        return samples;
//    }
//    return nil;
//}
//
//// Add a sample object to the SQLite database.
//-(void) insertSample:(Sample *)sample {
//    NSString *sql = [NSString stringWithFormat:@"INSERT INTO samples(rockType,rockId,coordinates,isPulverized) "
//                     "VALUES ('%@',%d,'%@',%d);", [sample rockType], (int)[sample rockId], [sample coordinates],
//                     [sample isPulverized] ? 1 : 0];
//    [self performQuery:sql];
//}
//
//// Submits a change to the SQLite database.
//-(void) updateSample:(Sample *)sample {
//    NSString *sql = [NSString stringWithFormat:@"UPDATE samples SET rockType='%@',coordinates='%@',isPulverized=%d "
//                     "WHERE rockId=%d;", [sample rockType], [sample coordinates], [sample isPulverized] ? 1 : 0,
//                     (int)[sample rockId]];
//    [self performQuery:sql];
//}
//
//// Remove a sample from the SQLite database.
//-(void) deleteSample:(Sample *)sample {
//    NSString *sql = [NSString stringWithFormat:@"DELETE FROM samples WHERE rockId=%d;", (int)[sample rockId]];
//    [self performQuery:sql];
//}
//
//// Sync local database with zumero database
//-(void) sync {
//    NSString *sql = @"SELECT zumero_sync("
//        "'main',"
//        "'https://zinst7655bd1e667.s.zumero.net',"
//        "'test_db3',"
//        "zumero_internal_auth_scheme('zumero_users_admin'),"
//        "'admin',"
//        "'pcbcsce490');";
//    NSArray *result = [self performQuery:sql];
//    NSArray *args = [[[result objectAtIndex:0] objectAtIndex:0] componentsSeparatedByString:@";"];
//    NSInteger callsRemaining = [[args objectAtIndex:0] integerValue];
//    for (NSInteger i=0; i<callsRemaining; i++) {
//        [self performQuery:sql];
//    }
//}
//
//// Get storage usage stats from zumero database
//-(void) storageUsage {
//    NSString *sql = @"SELECT zumero_get_storage_usage_on_server("
//        "'https://zinst7655bd1e667.s.zumero.net',"
//        "zumero_internal_auth_scheme('zumero_users_admin'),"
//        "'admin',"
//        "'pcbcsce490',"
//        "'my_dbfile_list');";
//    [self performQuery:sql];
//    sql = @"SELECT * FROM my_dbfile_list;";
//    [self performQuery:sql];
//}
//
//@end
