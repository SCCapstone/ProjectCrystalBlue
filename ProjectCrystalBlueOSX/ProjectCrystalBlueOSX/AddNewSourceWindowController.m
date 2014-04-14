//
//  AddNewSourceWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddNewSourceWindowController.h"
#import "SourcesTableViewController.h"
#import "SourceFieldValidator.h"
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "GenerateQRCode.h"

@interface AddNewSourceWindowController ()

@end

@implementation AddNewSourceWindowController

@synthesize sourcesTableViewController, dataStore;

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
    [self.keyTextField              setStringValue:SRC_DEF_VAL_KEY];
    [self.continentTextField        setStringValue:SRC_DEF_VAL_CONTINENT];
    [self.groupTextField            setStringValue:SRC_DEF_VAL_GROUP];
    [self.formationTextField        setStringValue:SRC_DEF_VAL_FORMATION];
    [self.memberTextField           setStringValue:SRC_DEF_VAL_MEMBER];
    [self.regionTextField           setStringValue:SRC_DEF_VAL_REGION];
    [self.localityTextField         setStringValue:SRC_DEF_VAL_LOCALITY];
    [self.sectionTextField          setStringValue:SRC_DEF_VAL_SECTION];
    [self.meterTextField            setStringValue:SRC_DEF_VAL_METER];
    [self.latitudeTextField         setStringValue:SRC_DEF_VAL_LATITUDE];
    [self.longitudeTextField        setStringValue:SRC_DEF_VAL_LONGITUDE];
    [self.ageTextField              setStringValue:SRC_DEF_VAL_AGE];
    [self.ageDataTypeTextField      setStringValue:SRC_DEF_VAL_AGE_DATATYPE];
    [self.hyperlinkTextView         setString:SRC_DEF_VAL_HYPERLINKS];
    [self.notesTextView             setString:SRC_DEF_VAL_NOTES];
    
    [self.rockTypeComboBox addItemsWithObjectValues:[SourceConstants rockTypes]];
    [self rockTypeChanged:nil];
    [self.ageMethodComboBox addItemsWithObjectValues:[SourceConstants ageMethods]];
    
    [self.dateCollectedPicker setDateValue:[NSDate date]];
}

/// Update the lithology and deposystem dropdowns based on rock type
- (void)rockTypeChanged:(id)sender
{
    NSString *rockType = self.rockTypeComboBox.stringValue;
    
    // Setup lithology dropdown when type changes
    [self.lithologyComboBox removeAllItems];
    [self.lithologyComboBox setStringValue:@""];
    NSArray *lithologyValues = [SourceConstants lithologiesForRockType:rockType];
    if (lithologyValues)
        [self.lithologyComboBox addItemsWithObjectValues:lithologyValues];
    
    // Setup deposystem dropdown when type changes
    [self.deposystemComboBox removeAllItems];
    [self.deposystemComboBox setStringValue:@""];
    NSArray *deposystemValues = [SourceConstants deposystemsForRockType:rockType];
    if (deposystemValues)
        [self.deposystemComboBox addItemsWithObjectValues:deposystemValues];
}

/// Validates all the values entered into the text fields. If there are any problems, this will
/// return NO and display the problems to the user.
- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;
    
    ValidationResponse *keyOK = [SourceFieldValidator validateSourceKey:self.keyTextField.stringValue
                                                          WithDataStore:dataStore];
    if (!keyOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [keyOK alertWithFieldName:@"source key"
                                        fieldValue:self.keyTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *continentOK = [SourceFieldValidator validateContinent:self.continentTextField.stringValue];
    if (!continentOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [continentOK alertWithFieldName:@"continent"
                                              fieldValue:self.continentTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *formationOK = [SourceFieldValidator validateFormation:self.formationTextField.stringValue];
    if (!formationOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [formationOK alertWithFieldName:@"formation"
                                              fieldValue:self.formationTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *memberOK = [SourceFieldValidator validateMember:self.memberTextField.stringValue];
    if (!memberOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [memberOK alertWithFieldName:@"member"
                                           fieldValue:self.memberTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *regionOK = [SourceFieldValidator validateRegion:self.regionTextField.stringValue];
    if (!regionOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [regionOK alertWithFieldName:@"region"
                                           fieldValue:self.regionTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *localityOK = [SourceFieldValidator validateLocality:self.localityTextField.stringValue];
    if (!localityOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [localityOK alertWithFieldName:@"locality"
                                             fieldValue:self.localityTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *sectionOK = [SourceFieldValidator validateContinent:self.sectionTextField.stringValue];
    if (!sectionOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [sectionOK alertWithFieldName:@"section"
                                            fieldValue:self.sectionTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *meterOK = [SourceFieldValidator validateMeters:self.meterTextField.stringValue];
    if (!meterOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [meterOK alertWithFieldName:@"meter"
                                          fieldValue:self.meterTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *latitudeOK = [SourceFieldValidator validateLatitude:self.latitudeTextField.stringValue];
    if (!latitudeOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [latitudeOK alertWithFieldName:@"latitude"
                                              fieldValue:self.latitudeTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *longitudeOK = [SourceFieldValidator validateLongitude:self.longitudeTextField.stringValue];
    if (!longitudeOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [longitudeOK alertWithFieldName:@"longitude"
                                              fieldValue:self.longitudeTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *ageOK = [SourceFieldValidator validateAge:self.ageTextField.stringValue];
    if (!ageOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [ageOK alertWithFieldName:@"age"
                                              fieldValue:self.ageTextField.stringValue];
        [alert runModal];
    }

    ValidationResponse *ageDatatypeOK = [SourceFieldValidator validateAgeDatatype:self.ageDataTypeTextField.stringValue];
    if (!ageDatatypeOK.isValid) {
        validationPassed = NO;
        NSAlert *alert = [ageDatatypeOK alertWithFieldName:@"age datatype"
                                              fieldValue:self.ageDataTypeTextField.stringValue];
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
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjects:[SourceConstants attributeDefaultValues]
                                                                           forKeys:[SourceConstants attributeNames]];

    [attributes setObject:self.keyTextField.stringValue                     forKey:SRC_KEY];
    [attributes setObject:self.continentTextField.stringValue               forKey:SRC_CONTINENT];
    [attributes setObject:self.rockTypeComboBox.stringValue                 forKey:SRC_TYPE];
    [attributes setObject:self.lithologyComboBox.stringValue                forKey:SRC_LITHOLOGY];
    [attributes setObject:self.deposystemComboBox.stringValue               forKey:SRC_DEPOSYSTEM];
    [attributes setObject:self.groupTextField.stringValue                   forKey:SRC_GROUP];
    [attributes setObject:self.formationTextField.stringValue               forKey:SRC_FORMATION];
    [attributes setObject:self.memberTextField.stringValue                  forKey:SRC_MEMBER];
    [attributes setObject:self.regionTextField.stringValue                  forKey:SRC_REGION];
    [attributes setObject:self.localityTextField.stringValue                forKey:SRC_LOCALITY];
    [attributes setObject:self.sectionTextField.stringValue                 forKey:SRC_SECTION];
    [attributes setObject:self.meterTextField.stringValue                   forKey:SRC_METER];
    [attributes setObject:self.latitudeTextField.stringValue                forKey:SRC_LATITUDE];
    [attributes setObject:self.longitudeTextField.stringValue               forKey:SRC_LONGITUDE];
    [attributes setObject:self.ageTextField.stringValue                     forKey:SRC_AGE];
    [attributes setObject:self.ageMethodComboBox.stringValue                forKey:SRC_AGE_METHOD];
    [attributes setObject:self.ageDataTypeTextField.stringValue             forKey:SRC_AGE_DATATYPE];
    [attributes setObject:self.hyperlinkTextView.string                     forKey:SRC_HYPERLINKS];
    [attributes setObject:self.notesTextView.string                         forKey:SRC_NOTES];

    NSDate *dateCollected = self.dateCollectedPicker.dateValue;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:dateCollected];

    [attributes setObject:dateString
                   forKey:SRC_DATE_COLLECTED];

    Source* s = [[Source alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    [self.sourcesTableViewController addSource:s];
    [self close];
}


@end
