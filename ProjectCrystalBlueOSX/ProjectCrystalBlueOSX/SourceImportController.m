//
//  SourceImportController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceImportController.h"
#import "LibraryObjectCSVReader.h"
#import "SourceConstants.h"
#import "Source.h"
#import "SourceFieldValidator.h"

@implementation SourceImportController

- (id)init
{
    self = [super init];
    if (self) {
        self.fileReader = [[LibraryObjectCSVReader alloc] init];
        self.tableName = [SourceConstants tableName];
    }
    return self;
}

-(ImportResult *)validateObjects:(NSArray *)libraryObjects
{
    ImportResult *result = [[ImportResult alloc] init];
    BOOL validationErrors = NO;
    NSMutableSet *keysEncountered = [[NSMutableSet alloc] initWithCapacity:libraryObjects.count];

    for (Source *source in libraryObjects)
    {
        // Dates are difficult because the format is inconsistent. Our best bet is just to try to
        // parse it, and spit back whatever we get and leave it up to the user to fix later.
        NSDate *cleanDate = [NSDate dateWithNaturalLanguageString:[source.attributes objectForKey:SRC_DATE_COLLECTED]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *cleanDateString = [dateFormatter stringFromDate:cleanDate];
        if (nil == cleanDateString) {
            // fail-safe
            cleanDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
        }
        [source.attributes setObject:cleanDateString forKey:SRC_DATE_COLLECTED];

        
        if ([keysEncountered containsObject:source.key]) {
            [result.duplicateKeys addObject:source.key];
        }
        [keysEncountered addObject:source.key];

        ValidationResponse *ageValid            = [SourceFieldValidator validateAge:[source.attributes              objectForKey:SRC_AGE]];
        ValidationResponse *ageDatatypeValid    = [SourceFieldValidator validateAgeDatatype:[source.attributes      objectForKey:SRC_AGE_DATATYPE]];
        ValidationResponse *ageMethodValid      = [SourceFieldValidator validateAgeMethod:[source.attributes        objectForKey:SRC_AGE_METHOD]];
        ValidationResponse *continentValid      = [SourceFieldValidator validateContinent:[source.attributes        objectForKey:SRC_CONTINENT]];
        ValidationResponse *dateValid           = [SourceFieldValidator validateDateCollected:[source.attributes    objectForKey:SRC_DATE_COLLECTED]];
        ValidationResponse *deposystemValid     = [SourceFieldValidator validateDeposystem:[source.attributes       objectForKey:SRC_DEPOSYSTEM]];
        ValidationResponse *formationValid      = [SourceFieldValidator validateFormation:[source.attributes        objectForKey:SRC_FORMATION]];
        ValidationResponse *groupValid          = [SourceFieldValidator validateGroup:[source.attributes            objectForKey:SRC_GROUP]];
        ValidationResponse *hyperlinksValid     = [SourceFieldValidator validateHyperlinks:[source.attributes       objectForKey:SRC_HYPERLINKS]];
        ValidationResponse *latitudeValid       = [SourceFieldValidator validateLatitude:[source.attributes         objectForKey:SRC_LATITUDE]];
        ValidationResponse *longitudeValid      = [SourceFieldValidator validateLongitude:[source.attributes        objectForKey:SRC_LONGITUDE]];
        ValidationResponse *memberValid         = [SourceFieldValidator validateMember:[source.attributes           objectForKey:SRC_MEMBER]];
        ValidationResponse *meterValid          = [SourceFieldValidator validateMeters:[source.attributes           objectForKey:SRC_METER]];
        ValidationResponse *notesValid          = [SourceFieldValidator validateNotes:[source.attributes            objectForKey:SRC_NOTES]];
        ValidationResponse *regionValid         = [SourceFieldValidator validateRegion:[source.attributes           objectForKey:SRC_REGION]];
        ValidationResponse *sectionValid        = [SourceFieldValidator validateSection:[source.attributes          objectForKey:SRC_SECTION]];
        ValidationResponse *typeValid           = [SourceFieldValidator validateType:[source.attributes             objectForKey:SRC_TYPE]];

        BOOL sourceIsValid =    ageValid.isValid &&
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

        if (!sourceIsValid) {
            [result.keysOfInvalidLibraryObjects addObject:source.key];
            validationErrors = YES;
        }
    }

    [result setHasError:validationErrors];
    return result;
}

@end
