//
//  BatchEditWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 4/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "BatchEditWindowController.h"
#import "Source.h"
#import "SourceFieldValidator.h"
#import "ValidationResponse.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface BatchEditWindowController ()

@end

@implementation BatchEditWindowController

@synthesize selectedSources, dataStore;

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
    
    [self.rockTypeComboBox addItemsWithObjectValues:[SourceConstants rockTypes]];
    [self rockTypeChanged:nil];
    [self.ageMethodComboBox addItemsWithObjectValues:[SourceConstants ageMethods]];
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
    
    ValidationResponse *collectedByOk = [SourceFieldValidator validateCollectedBy:self.collectedByTextField.stringValue];
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
    
    for (Source *source in selectedSources) {
        if (![self.continentTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.continentTextField.stringValue forKey:SRC_CONTINENT];
        if (![self.rockTypeComboBox.stringValue isEqualToString:@""])
            [source.attributes setObject:self.rockTypeComboBox.stringValue forKey:SRC_TYPE];
        if (![self.lithologyComboBox.stringValue isEqualToString:@""])
            [source.attributes setObject:self.lithologyComboBox.stringValue forKey:SRC_LITHOLOGY];
        if (![self.deposystemComboBox.stringValue isEqualToString:@""])
            [source.attributes setObject:self.deposystemComboBox.stringValue forKey:SRC_DEPOSYSTEM];
        if (![self.groupTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.groupTextField.stringValue forKey:SRC_GROUP];
        if (![self.formationTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.formationTextField.stringValue forKey:SRC_FORMATION];
        if (![self.memberTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.memberTextField.stringValue forKey:SRC_MEMBER];
        if (![self.regionTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.regionTextField.stringValue forKey:SRC_REGION];
        if (![self.localityTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.localityTextField.stringValue forKey:SRC_LOCALITY];
        if (![self.sectionTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.sectionTextField.stringValue forKey:SRC_SECTION];
        if (![self.meterTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.meterTextField.stringValue forKey:SRC_METER];
        if (![self.latitudeTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.latitudeTextField.stringValue forKey:SRC_LATITUDE];
        if (![self.longitudeTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.longitudeTextField.stringValue forKey:SRC_LONGITUDE];
        if (![self.ageTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.ageTextField.stringValue forKey:SRC_AGE];
        if (![self.ageMethodComboBox.stringValue isEqualToString:@""])
            [source.attributes setObject:self.ageMethodComboBox.stringValue forKey:SRC_AGE_METHOD];
        if (![self.ageDataTypeTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.ageDataTypeTextField.stringValue forKey:SRC_AGE_DATATYPE];
        if (![self.collectedByTextField.stringValue isEqualToString:@""])
            [source.attributes setObject:self.collectedByTextField.stringValue forKey:SRC_COLLECTED_BY];
        if (![self.hyperlinkTextView.string isEqualToString:@""])
            [source.attributes setObject:self.hyperlinkTextView.string forKey:SRC_HYPERLINKS];
        if (![self.notesTextView.string isEqualToString:@""])
            [source.attributes setObject:self.notesTextView.string forKey:SRC_NOTES];
        
        [dataStore updateLibraryObject:source IntoTable:[SourceConstants tableName]];
    }
    
    [self close];
}

@end
