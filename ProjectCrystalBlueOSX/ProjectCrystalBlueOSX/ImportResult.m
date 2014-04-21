//
//  ImportResult.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ImportResult.h"

@implementation ImportResult

@synthesize hasError;
@synthesize keysOfInvalidLibraryObjects;
@synthesize duplicateKeys;

- (instancetype)init
{
    self = [super init];
    if (self) {
        keysOfInvalidLibraryObjects = [[NSMutableArray alloc] init];
        duplicateKeys = [[NSMutableArray alloc] init];
        hasError = YES;
    }
    return self;
}

/// Generates an NSAlert containing the information from this ImportResult.
-(NSAlert *)alertWithResults
{
    NSAlert *alert = [[NSAlert alloc] init];

    [alert setAlertStyle:NSInformationalAlertStyle];

    NSString *message = self.hasError ? @"Import was unsuccessful": @"Import complete";
    [alert setMessageText:message];

    NSMutableString *info = [[NSMutableString alloc] initWithString:@""];
    if (self.hasError) {
        [info appendString:@"\nThere were errors importing the following items:\n\n"];
        [info appendFormat:@"%@", [keysOfInvalidLibraryObjects firstObject]];
        for (NSUInteger i = 1; i < keysOfInvalidLibraryObjects.count; ++i) {
            [info appendFormat:@", %@", [keysOfInvalidLibraryObjects objectAtIndex:i]];
        }
    }

    if (self.duplicateKeys.count > 0) {
        [info appendString:@"\n\nWarning - there were multiple occurances of the following keys:\n\n"];
        [info appendFormat:@"%@", [duplicateKeys firstObject]];
        for (NSUInteger i = 1; i < duplicateKeys.count; ++i) {
            [info appendFormat:@", %@", [duplicateKeys objectAtIndex:i]];
        }
    }


    [alert setInformativeText:info];

    return alert;
}

@end
