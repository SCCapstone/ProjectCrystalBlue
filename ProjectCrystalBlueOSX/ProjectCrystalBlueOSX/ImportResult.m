//
//  ImportResult.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ImportResult.h"
#import "PCBLogWrapper.h"

#define SUCCESS_MESSAGE @"Import complete"
#define UNSUCCESS_MESSAGE @"Import was unsuccessful"
#define SUCCESSFUL_IMPORT_COUNT_FORMAT @"Imported %lu items successfully."

#define UNEXPECTED_HEADERS_INFO @"\n\nThe following unexpected headers were detected:\n\n"
#define MISSING_HEADERS_INFO @"\n\nThe following expected headers were missing:\n\n"
#define INVALID_LIBRARYOBJECTS_INFO @"\n\nThere were errors importing the following items:\n\n"
#define DUPLICATE_KEYS_INFO @"\n\nWarning - there were multiple occurances of the following keys:\n\n"

@implementation ImportResult

@synthesize hasError;
@synthesize keysOfInvalidLibraryObjects;
@synthesize duplicateKeys;
@synthesize unexpectedHeaders;
@synthesize missingHeaders;

- (instancetype)init
{
    self = [super init];
    if (self) {
        keysOfInvalidLibraryObjects = [[NSMutableArray alloc] init];
        duplicateKeys = [[NSMutableArray alloc] init];
        unexpectedHeaders = [[NSMutableArray alloc] init];
        missingHeaders = [[NSMutableArray alloc] init];
        hasError = NO;
    }
    return self;
}

/// Generates an NSAlert containing the information from this ImportResult.
-(NSAlert *)alertWithResults
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSInformationalAlertStyle];

    NSMutableString *info = [[NSMutableString alloc] initWithString:@""];
    NSString *message;

    if (!hasError) {
        message = SUCCESS_MESSAGE;
        [info appendFormat:SUCCESSFUL_IMPORT_COUNT_FORMAT, self.successfulImportsCount];
    } else {
        message = UNSUCCESS_MESSAGE;

        if (unexpectedHeaders.count > 0) {
            [info appendString:UNEXPECTED_HEADERS_INFO];
            [info appendFormat:@"%@", [unexpectedHeaders firstObject]];
            for (NSUInteger i = 1; i < unexpectedHeaders.count; ++i) {
                [info appendFormat:@", %@", [unexpectedHeaders objectAtIndex:i]];
            }
        }

        if (missingHeaders.count > 0) {
            [info appendString:MISSING_HEADERS_INFO];
            [info appendFormat:@"%@", [missingHeaders firstObject]];
            for (NSUInteger i = 1; i < missingHeaders.count; ++i) {
                [info appendFormat:@", %@", [missingHeaders objectAtIndex:i]];
            }
        }

        if (keysOfInvalidLibraryObjects.count > 0) {
            [info appendString:INVALID_LIBRARYOBJECTS_INFO];
            [info appendFormat:@"%@", [keysOfInvalidLibraryObjects firstObject]];
            for (NSUInteger i = 1; i < keysOfInvalidLibraryObjects.count; ++i) {
                [info appendFormat:@", %@", [keysOfInvalidLibraryObjects objectAtIndex:i]];
            }
        }
    }

    /* duplicate keys don't cause an import to fail, but we should still report them */
    if (duplicateKeys.count > 0) {
        [info appendString:DUPLICATE_KEYS_INFO];
        [info appendFormat:@"%@", [duplicateKeys firstObject]];
        for (NSUInteger i = 1; i < duplicateKeys.count; ++i) {
            [info appendFormat:@", %@", [duplicateKeys objectAtIndex:i]];
        }
    }

    [alert setMessageText:message];
    [alert setInformativeText:info];

    return alert;
}

@end
