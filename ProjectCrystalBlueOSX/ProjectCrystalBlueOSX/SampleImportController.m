//
//  SampleImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleImportController.h"
#import "LibraryObjectCSVReader.h"
#import "SampleConstants.h"
#import "ValidationResponse.h"
#import "SampleFieldValidator.h"
#import "Sample.h"

@implementation SampleImportController

- (id)init
{
    self = [super init];
    if (self) {
        self.fileReader = [[LibraryObjectCSVReader alloc] init];
        self.tableName = [SampleConstants tableName];
    }
    return self;
}

-(ImportResult *)validateObjects:(NSArray *)libraryObjects
{
    ImportResult *result = [[ImportResult alloc] init];
    BOOL hasValidationErrors = NO;
    NSMutableSet *keysEncountered = [[NSMutableSet alloc] initWithCapacity:libraryObjects.count];

    for (Sample *sample in libraryObjects) {
        if ([keysEncountered containsObject:sample.key]) {
            hasValidationErrors = YES;
            [result.duplicateKeys addObject:sample.key];
        }
        [keysEncountered addObject:sample.key];

        ValidationResponse *locationValid = [SampleFieldValidator validateCurrentLocation:[sample.attributes objectForKey:SMP_CURRENT_LOCATION]];

        BOOL sampleIsValid = locationValid.isValid;

        if (!sampleIsValid) {
            [result.keysOfInvalidLibraryObjects addObject:sample.key];
        }
    }


    [result setHasError:NO];
    return result;
}

@end
