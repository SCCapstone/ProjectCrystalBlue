//
//  BatchEditWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 4/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "BatchEditWindowController.h"
#import "Sample.h"
#import "SampleFieldValidator.h"
#import "ValidationResponse.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "PCBLogWrapper.h"

@interface BatchEditWindowController ()

@end

@implementation BatchEditWindowController

@synthesize selectedSamples, dataStore;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.rockTypeComboBox addItemsWithObjectValues:[SampleConstants rockTypes]];
    [self rockTypeChanged:nil];
    [self.ageMethodComboBox addItemsWithObjectValues:[SampleConstants ageMethods]];
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
    
    ValidationResponse *collectedByOk = [SampleFieldValidator validateCollectedBy:self.collectedByTextField.stringValue];
    if (!collectedByOk.isValid) {
        validationPassed = NO;
        NSAlert *alert = [collectedByOk alertWithFieldName:@"collected by"
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
    
    for (Sample *sample in selectedSamples) {
        if (![self.continentTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.continentTextField.stringValue forKey:SMP_CONTINENT];
        if (![self.rockTypeComboBox.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.rockTypeComboBox.stringValue forKey:SMP_TYPE];
        if (![self.lithologyComboBox.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.lithologyComboBox.stringValue forKey:SMP_LITHOLOGY];
        if (![self.deposystemComboBox.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.deposystemComboBox.stringValue forKey:SMP_DEPOSYSTEM];
        if (![self.groupTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.groupTextField.stringValue forKey:SMP_GROUP];
        if (![self.formationTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.formationTextField.stringValue forKey:SMP_FORMATION];
        if (![self.memberTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.memberTextField.stringValue forKey:SMP_MEMBER];
        if (![self.regionTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.regionTextField.stringValue forKey:SMP_REGION];
        if (![self.localityTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.localityTextField.stringValue forKey:SMP_LOCALITY];
        if (![self.sectionTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.sectionTextField.stringValue forKey:SMP_SECTION];
        if (![self.meterTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.meterTextField.stringValue forKey:SMP_METER];
        if (![self.latitudeTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.latitudeTextField.stringValue forKey:SMP_LATITUDE];
        if (![self.longitudeTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.longitudeTextField.stringValue forKey:SMP_LONGITUDE];
        if (![self.ageTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.ageTextField.stringValue forKey:SMP_AGE];
        if (![self.ageMethodComboBox.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.ageMethodComboBox.stringValue forKey:SMP_AGE_METHOD];
        if (![self.ageDataTypeTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.ageDataTypeTextField.stringValue forKey:SMP_AGE_DATATYPE];
        if (![self.collectedByTextField.stringValue isEqualToString:@""])
            [sample.attributes setObject:self.collectedByTextField.stringValue forKey:SMP_COLLECTED_BY];
        if (![self.hyperlinkTextView.string isEqualToString:@""])
            [sample.attributes setObject:self.hyperlinkTextView.string forKey:SMP_HYPERLINKS];
        if (![self.notesTextView.string isEqualToString:@""])
            [sample.attributes setObject:self.notesTextView.string forKey:SMP_NOTES];
        
        [dataStore updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
    }
    
    [self close];
}

@end
