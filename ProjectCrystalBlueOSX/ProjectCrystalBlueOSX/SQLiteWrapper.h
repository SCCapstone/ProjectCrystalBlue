//
//  SQLiteWrapper.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 11/19/13.
//  Copyright (c) 2013 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Sample.h"

@interface SQLiteWrapper : NSObject {
    sqlite3 *db;
}

-(NSArray *) performQuery:(NSString *)query;
-(NSMutableArray *) getSamples;
-(void) insertSample:(Sample *)sample;
-(void) updateSample:(Sample *)sample;
-(void) deleteSample:(Sample *)sample;

@end
