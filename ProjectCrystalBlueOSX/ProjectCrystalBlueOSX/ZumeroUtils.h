//
//  ZumeroUtils.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 2/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Zumero.h>

@class LibraryObject;

@interface ZumeroUtils : NSObject

/** Creates a new ZumeroDB instance with the specified database name
 *  at the specified directory and sets the ZumeroDelegate object to 
 *  the specified delegate.  If the database already exists at the
 *  directory, the existing database will be returned.
 *
 *  The directory is with respect to the User's Documents folder. If directory
 *  is nil, then the database will be saved in the Documents folder.
 *
 *  The delegate is used to call back success, failure, or progress
 *  updates when syncing with the remote Zumero database.
 *
 *  Returns nil if the instance failed to create.
 */
+ (ZumeroDB *)initializeZumeroDatabaseWithName:(NSString *)databaseName
                               AndWithDelegate:(id)delegate
                         AndWithLocalDirectory:(NSString *)directory;

/** Creates a new local zumero table with the specified table name,
 *  fields, and ZumeroDB to create the table in.
 *
 *  The fields object is a dictionary of columns where the keys are
 *  column names and values are attribute definitions such as
 *  type or default value.  Refer to the documentation for all possible
 *  attribte definitions.
 */
+ (BOOL)createZumeroTableWithName:(NSString *)tableName
                        AndFields:(NSDictionary *)fields
                    UsingDatabase:(ZumeroDB *)database;

/** Check if a table with the specified name exists in the
 *  ZumeroDB instance.
 */
+ (BOOL)zumeroTableExistsWithName:(NSString *)tableName
                    UsingDatabase:(ZumeroDB *)database;

/** Starts a Zumero transaction in the specified ZumeroDB database and
 *  returns whether the transaction was successfully started.
 *  
 *  The zumero database will be opened and a transaction will
 *  be started with this method.
 */
+ (BOOL)startZumeroTransactionUsingDatabase:(ZumeroDB *)database;

/** Finishes a Zumero transaction in the specified ZumeroDB database and
 *  returns whether the transaction was successfully committed.
 *
 *  The zumero database will be closed and a transaction will
 *  be committed with this method.
 */
+ (BOOL)finishZumeroTransactionUsingDatabase:(ZumeroDB *)database;

/** Returns the authentication scheme used when syncing with the
 *  remote Zumero database.
 */
+ (NSDictionary *)syncScheme;

@end
