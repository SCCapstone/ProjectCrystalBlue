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
#import "Sample.h"
#import "SampleFieldValidator.h"
#import "PCBLogWrapper.h"

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
    NSMutableSet *keysEncountered = [[NSMutableSet alloc] initWithCapacity:libraryObjects.count];

    [self validateHeadersInRepresentativeObject:[libraryObjects firstObject]
                         againstExpectedHeaders:[SampleConstants attributeNames]
                               withImportResult:result];

    for (Sample *sample in libraryObjects)
    {
        // Dates are difficult because the format is inconsistent. Our best bet is just to try to
        // parse it, and spit back whatever we get and leave it up to the user to fix later.
        NSDate *cleanDate = [NSDate dateWithNaturalLanguageString:[sample.attributes objectForKey:SMP_DATE_COLLECTED]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *cleanDateString = [dateFormatter stringFromDate:cleanDate];
        if (nil == cleanDateString) {
            // fail-safe
            cleanDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
        }
        [sample.attributes setObject:cleanDateString forKey:SMP_DATE_COLLECTED];

        
        if ([keysEncountered containsObject:sample.key]) {
            [result.duplicateKeys addObject:sample.key];
        }
        [keysEncountered addObject:sample.key];

        ValidationResponse *ageValid            = [SampleFieldValidator validateAge:[sample.attributes              objectForKey:SMP_AGE]];
        ValidationResponse *ageDatatypeValid    = [SampleFieldValidator validateAgeDatatype:[sample.attributes      objectForKey:SMP_AGE_DATATYPE]];
        ValidationResponse *ageMethodValid      = [SampleFieldValidator validateAgeMethod:[sample.attributes        objectForKey:SMP_AGE_METHOD]];
        ValidationResponse *continentValid      = [SampleFieldValidator validateContinent:[sample.attributes        objectForKey:SMP_CONTINENT]];
        ValidationResponse *dateValid           = [SampleFieldValidator validateDateCollected:[sample.attributes    objectForKey:SMP_DATE_COLLECTED]];
        ValidationResponse *deposystemValid     = [SampleFieldValidator validateDeposystem:[sample.attributes       objectForKey:SMP_DEPOSYSTEM]];
        ValidationResponse *formationValid      = [SampleFieldValidator validateFormation:[sample.attributes        objectForKey:SMP_FORMATION]];
        ValidationResponse *groupValid          = [SampleFieldValidator validateGroup:[sample.attributes            objectForKey:SMP_GROUP]];
        ValidationResponse *hyperlinksValid     = [SampleFieldValidator validateHyperlinks:[sample.attributes       objectForKey:SMP_HYPERLINKS]];
        ValidationResponse *latitudeValid       = [SampleFieldValidator validateLatitude:[sample.attributes         objectForKey:SMP_LATITUDE]];
        ValidationResponse *longitudeValid      = [SampleFieldValidator validateLongitude:[sample.attributes        objectForKey:SMP_LONGITUDE]];
        ValidationResponse *memberValid         = [SampleFieldValidator validateMember:[sample.attributes           objectForKey:SMP_MEMBER]];
        ValidationResponse *meterValid          = [SampleFieldValidator validateMeters:[sample.attributes           objectForKey:SMP_METER]];
        ValidationResponse *notesValid          = [SampleFieldValidator validateNotes:[sample.attributes            objectForKey:SMP_NOTES]];
        ValidationResponse *regionValid         = [SampleFieldValidator validateRegion:[sample.attributes           objectForKey:SMP_REGION]];
        ValidationResponse *sectionValid        = [SampleFieldValidator validateSection:[sample.attributes          objectForKey:SMP_SECTION]];
        ValidationResponse *typeValid           = [SampleFieldValidator validateType:[sample.attributes             objectForKey:SMP_TYPE]];

        BOOL sampleIsValid =    ageValid.isValid &&
                                ageDatatypeValid.isValid &&
                                ageMethodValid.isValid &&
                                continentValid.isValid &&
                                dateValid.isValid &&
                                deposystemValid.isValid &&
                                formationValid.isValid &&
                                groupValid.isValid &&
                                hyperlinksValid.isValid &&
                                latitudeValid.isValid &&
                                longitudeValid.isValid &&
                                memberValid.isValid &&
                                meterValid.isValid &&
                                notesValid.isValid &&
                                regionValid.isValid &&
                                sectionValid.isValid &&
                                typeValid.isValid;

        if (!sampleIsValid) {
            [result.keysOfInvalidLibraryObjects addObject:sample.key];
            result.hasError = YES;
        }
    }

    return result;
}

@end
