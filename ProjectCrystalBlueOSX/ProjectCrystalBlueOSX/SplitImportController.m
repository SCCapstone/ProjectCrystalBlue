//
//  SplitImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SplitImportController.h"
#import "LibraryObjectCSVReader.h"
#import "SplitConstants.h"
#import "ValidationResponse.h"
#import "SplitFieldValidator.h"
#import "Split.h"

@implementation SplitImportController

- (id)init
{
    self = [super init];
    if (self) {
        self.fileReader = [[LibraryObjectCSVReader alloc] init];
        self.tableName = [SplitConstants tableName];
    }
    return self;
}

-(ImportResult *)validateObjects:(NSArray *)libraryObjects
{
    ImportResult *result = [[ImportResult alloc] init];
    BOOL hasValidationErrors = NO;
    NSMutableSet *keysEncountered = [[NSMutableSet alloc] initWithCapacity:libraryObjects.count];

    [self validateHeadersInRepresentativeObject:[libraryObjects firstObject]
                         againstExpectedHeaders:[SplitConstants attributeNames]
                               withImportResult:result];

    for (Split *split in libraryObjects) {
        if ([keysEncountered containsObject:split.key]) {
            [result.duplicateKeys addObject:split.key];
        }
        [keysEncountered addObject:split.key];

        ValidationResponse *locationValid = [SplitFieldValidator validateCurrentLocation:[split.attributes objectForKey:SPL_CURRENT_LOCATION]];

        BOOL splitIsValid = locationValid.isValid;

        if (!splitIsValid) {
            [result.keysOfInvalidLibraryObjects addObject:split.key];
            hasValidationErrors = YES;
        }
    }

    [result setHasError:NO];
    return result;
}

@end
