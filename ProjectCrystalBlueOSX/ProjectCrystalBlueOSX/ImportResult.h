//
//  ImportResult.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class to hold a Report of the result of an import operation.
 */
@interface ImportResult : NSObject

/// An overall result - whether there were any detected errors during import.
@property BOOL hasError;

/// A list of the keys of any invalid LibraryObjects encountered during import.
@property NSMutableArray *keysOfInvalidLibraryObjects;

/// A list of any keys that were encountered multiple times during import.
@property NSMutableArray *duplicateKeys;

@end

/**
 *  Protocol for a class that can display a result report to a user.
 */
@protocol ImportResultReporter <NSObject>

-(void) displayResults:(ImportResult *)result;

@end