//
//  AddNewSampleWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddNewSampleWindowController.h"
#import "SamplesTableViewController.h"
#import "SampleFieldValidator.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "GenerateQRCode.h"
#import "PCBLogWrapper.h"

@interface AddNewSampleWindowController ()

@end

@implementation AddNewSampleWindowController

@synthesize samplesTableViewController, dataStore;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self initializeTextFieldValues];
}

- (void)initializeTextFieldValues
{
    [self.keyTextField.cell             setPlaceholderString:SMP_DEF_VAL_KEY];
    [self.continentTextField.cell       setPlaceholderString:SMP_DEF_VAL_CONTINENT];
    [self.groupTextField.cell           setPlaceholderString:SMP_DEF_VAL_GROUP];
    [self.formationTextField.cell       setPlaceholderString:SMP_DEF_VAL_FORMATION];
    [self.memberTextField.cell          setPlaceholderString:SMP_DEF_VAL_MEMBER];
    [self.regionTextField.cell          setPlaceholderString:SMP_DEF_VAL_REGION];
    [self.localityTextField.cell        setPlaceholderString:SMP_DEF_VAL_LOCALITY];
    [self.sectionTextField.cell         setPlaceholderString:SMP_DEF_VAL_SECTION];
    [self.meterTextField.cell           setPlaceholderString:SMP_DEF_VAL_METER];
    [self.latitudeTextField.cell        setPlaceholderString:SMP_DEF_VAL_LATITUDE];
    [self.longitudeTextField.cell       setPlaceholderString:SMP_DEF_VAL_LONGITUDE];
    [self.ageTextField.cell             setPlaceholderString:SMP_DEF_VAL_AGE];
    [self.ageDataTypeTextField.cell     setPlaceholderString:SMP_DEF_VAL_AGE_DATATYPE];
    [self.collectedByTextField.cell     setPlaceholderString:SMP_DEF_VAL_COLLECTED_BY];
    [self.hyperlinkTextView             setString:SMP_DEF_VAL_HYPERLINKS];
    [self.notesTextView                 setString:SMP_DEF_VAL_NOTES];
    
    [self.rockTypeComboBox addItemsWithObjectValues:[SampleConstants rockTypes]];
    [self rockTypeChanged:nil];
    [self.ageMethodComboBox addItemsWithObjectValues:[SampleConstants ageMethods]];
    
    [self.dateCollectedPicker setDateValue:[NSDate date]];
}

/// Update the lithology and deposystem dropdowns based on rock type
- (void)rockTypeChanged:(id)sender
{
    NSString *rockType = self.rockTypeComboBox.stringValue;
    
    // Setup lithology dropdown when type changes
    [self.lithologyComboBox removeAllItems];
    [self.lithologyComboBox setStringValue:@""];
    NSArray *lithologyValues = [SampleConstants lithologiesForRockType:rockType];
    if (lithologyValues)
        [self.lithologyComboBox addItemsWithObjectValues:lithologyValues];
    
    // Setup deposystem dropdown when type changes
    [self.deposystemComboBox removeAllItems];
    [self.deposystemComboBox setStringValue:@""];
    NSArray *deposystemValues = [SampleConstants deposystemsForRockType:rockType];
    if (deposystemValues)
        [self.deposystemComboBox addItemsWithObjectValues:deposystemValues];
}

/// Validates all the values entered into the text fields. If there are any problems, this will
/// return NO and display the problems to the user.
- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;
    
    ValidationResponse *keyOK = [SampleFieldValidator validateSampleKey:self.keyTextField.stringValue
                                                          WithDataStore:dataStore];
    if (!keyOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [keyOK alertWithFieldName:@"sample key"
                                        fieldValue:self.keyTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *continentOK = [SampleFieldValidator validateContinent:self.continentTextField.stringValue];
    if (!continentOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [continentOK alertWithFieldName:@"continent"
                                              fieldValue:self.continentTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *formationOK = [SampleFieldValidator validateFormation:self.formationTextField.stringValue];
    if (!formationOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [formationOK alertWithFieldName:@"formation"
                                              fieldValue:self.formationTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *memberOK = [SampleFieldValidator validateMember:self.memberTextField.stringValue];
    if (!memberOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [memberOK alertWithFieldName:@"member"
                                           fieldValue:self.memberTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *regionOK = [SampleFieldValidator validateRegion:self.regionTextField.stringValue];
    if (!regionOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [regionOK alertWithFieldName:@"region"
                                           fieldValue:self.regionTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *localityOK = [SampleFieldValidator validateLocality:self.localityTextField.stringValue];
    if (!localityOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [localityOK alertWithFieldName:@"locality"
                                             fieldValue:self.localityTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *sectionOK = [SampleFieldValidator validateContinent:self.sectionTextField.stringValue];
    if (!sectionOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [sectionOK alertWithFieldName:@"section"
                                            fieldValue:self.sectionTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *meterOK = [SampleFieldValidator validateMeters:self.meterTextField.stringValue];
    if (!meterOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [meterOK alertWithFieldName:@"meter"
                                          fieldValue:self.meterTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *latitudeOK = [SampleFieldValidator validateLatitude:self.latitudeTextField.stringValue];
    if (!latitudeOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [latitudeOK alertWithFieldName:@"latitude"
                                              fieldValue:self.latitudeTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *longitudeOK = [SampleFieldValidator validateLongitude:self.longitudeTextField.stringValue];
    if (!longitudeOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [longitudeOK alertWithFieldName:@"longitude"
                                              fieldValue:self.longitudeTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *ageOK = [SampleFieldValidator validateAge:self.ageTextField.stringValue];
    if (!ageOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [ageOK alertWithFieldName:@"age"
                                              fieldValue:self.ageTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *ageDatatypeOK = [SampleFieldValidator validateAgeDatatype:self.ageDataTypeTextField.stringValue];
    if (!ageDatatypeOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [ageDatatypeOK alertWithFieldName:@"age datatype"
                                              fieldValue:self.ageDataTypeTextField.stringValue];
        [alert runModal];
    }
    
    ValidationResponse *collectedByOK = [SampleFieldValidator validateCollectedBy:self.collectedByTextField.stringValue];
    if (!collectedByOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [collectedByOK alertWithFieldName:@"collected by"
                                                fieldValue:self.collectedByTextField.stringValue];
        [alert runModal];
    }

    return validationPassed;
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self close];
}

- (IBAction)saveButtonPressed:(id)sender
{
    if (![self validateTextFieldValues]) {
        return;
    }
    NSString *key = self.keyTextField.stringValue;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjects:[SampleConstants attributeDefaultValues]
                                                                           forKeys:[SampleConstants attributeNames]];

    [attributes setObject:self.keyTextField.stringValue                     forKey:SMP_KEY];
    [attributes setObject:self.continentTextField.stringValue               forKey:SMP_CONTINENT];
    [attributes setObject:self.rockTypeComboBox.stringValue                 forKey:SMP_TYPE];
    [attributes setObject:self.lithologyComboBox.stringValue                forKey:SMP_LITHOLOGY];
    [attributes setObject:self.deposystemComboBox.stringValue               forKey:SMP_DEPOSYSTEM];
    [attributes setObject:self.groupTextField.stringValue                   forKey:SMP_GROUP];
    [attributes setObject:self.formationTextField.stringValue               forKey:SMP_FORMATION];
    [attributes setObject:self.memberTextField.stringValue                  forKey:SMP_MEMBER];
    [attributes setObject:self.regionTextField.stringValue                  forKey:SMP_REGION];
    [attributes setObject:self.localityTextField.stringValue                forKey:SMP_LOCALITY];
    [attributes setObject:self.sectionTextField.stringValue                 forKey:SMP_SECTION];
    [attributes setObject:self.meterTextField.stringValue                   forKey:SMP_METER];
    [attributes setObject:self.latitudeTextField.stringValue                forKey:SMP_LATITUDE];
    [attributes setObject:self.longitudeTextField.stringValue               forKey:SMP_LONGITUDE];
    [attributes setObject:self.ageTextField.stringValue                     forKey:SMP_AGE];
    [attributes setObject:self.ageMethodComboBox.stringValue                forKey:SMP_AGE_METHOD];
    [attributes setObject:self.ageDataTypeTextField.stringValue             forKey:SMP_AGE_DATATYPE];
    [attributes setObject:self.collectedByTextField.stringValue             forKey:SMP_COLLECTED_BY];
    [attributes setObject:self.hyperlinkTextView.string                     forKey:SMP_HYPERLINKS];
    [attributes setObject:self.notesTextView.string                         forKey:SMP_NOTES];

    NSDate *dateCollected = self.dateCollectedPicker.dateValue;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:dateCollected];

    [attributes setObject:dateString
                   forKey:SMP_DATE_COLLECTED];

    Sample* s = [[Sample alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    [self.samplesTableViewController addSample:s];
    [self close];
}


@end
