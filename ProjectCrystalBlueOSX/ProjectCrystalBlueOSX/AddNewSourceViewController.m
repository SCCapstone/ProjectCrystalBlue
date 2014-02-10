//
//  AddNewSourceViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/9/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddNewSourceViewController.h"
#import "SourceConstants.h"

@interface AddNewSourceViewController ()

@end

@implementation AddNewSourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self initializeTextFieldValues];
}

- (void)initializeTextFieldValues
{
    [self.keyTextField          setStringValue:DEF_VAL_KEY];
    [self.continentTextField    setStringValue:DEF_VAL_CONTINENT];
    [self.typeTextField         setStringValue:DEF_VAL_TYPE];
    [self.lithologyTextField    setStringValue:DEF_VAL_LITHOLOGY];
    [self.deposystemTextField   setStringValue:DEF_VAL_DEPOSYSTEM];
    [self.groupTextField        setStringValue:DEF_VAL_GROUP];
    [self.formationTextField    setStringValue:DEF_VAL_FORMATION];
    [self.memberTextField       setStringValue:DEF_VAL_MEMBER];
    [self.regionTextField       setStringValue:DEF_VAL_REGION];
    [self.localityTextField     setStringValue:DEF_VAL_LOCALITY];
    [self.sectionTextField      setStringValue:DEF_VAL_SECTION];
    [self.meterLevelTextField   setStringValue:DEF_VAL_METER_LEVEL];
    [self.latitudeTextField     setStringValue:DEF_VAL_LATITUDE];
    [self.longitudeTextField    setStringValue:DEF_VAL_LONGITUDE];
    [self.ageTextField          setStringValue:DEF_VAL_AGE];
    [self.ageBasis1TextField    setStringValue:DEF_VAL_AGE_BASIS1];
    [self.ageBasis2TextField    setStringValue:DEF_VAL_AGE_BASIS2];
    
    NSString *now = [NSString stringWithFormat:@"%@", [[NSDate alloc] init]];
    [self.dateCollectedTextField setStringValue:now];
    [self.projectTextField setStringValue:DEF_VAL_PROJECT];
    [self.subProjectTextField setStringValue:DEF_VAL_SUBPROJECT];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.view.window close];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *key = self.keyTextField.stringValue;
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjects:[SourceConstants attributeDefaultValues]
                                                                           forKeys:[SourceConstants attributeNames]];
    
    [attributes setObject:self.keyTextField.stringValue             forKey:KEY];
    [attributes setObject:self.continentTextField.stringValue       forKey:CONTINENT];
    [attributes setObject:self.typeTextField.stringValue            forKey:TYPE];
    [attributes setObject:self.lithologyTextField.stringValue       forKey:LITHOLOGY];
    [attributes setObject:self.deposystemTextField.stringValue      forKey:DEPOSYSTEM];
    [attributes setObject:self.groupTextField.stringValue           forKey:GROUP];
    [attributes setObject:self.formationTextField.stringValue       forKey:FORMATION];
    [attributes setObject:self.memberTextField.stringValue          forKey:MEMBER];
    [attributes setObject:self.regionTextField.stringValue          forKey:REGION];
    [attributes setObject:self.localityTextField.stringValue        forKey:LOCALITY];
    [attributes setObject:self.sectionTextField.stringValue         forKey:SECTION];
    [attributes setObject:self.meterLevelTextField.stringValue      forKey:METER_LEVEL];
    [attributes setObject:self.latitudeTextField.stringValue        forKey:LATITUDE];
    [attributes setObject:self.longitudeTextField.stringValue       forKey:LONGITUDE];
    [attributes setObject:self.ageTextField.stringValue             forKey:AGE];
    [attributes setObject:self.ageBasis1TextField.stringValue       forKey:AGE_BASIS1];
    [attributes setObject:self.ageBasis2TextField.stringValue       forKey:AGE_BASIS2];
    [attributes setObject:self.dateCollectedTextField.stringValue   forKey:DATE_COLLECTED];
    [attributes setObject:self.projectTextField.stringValue         forKey:PROJECT];
    [attributes setObject:self.subProjectTextField.stringValue      forKey:SUBPROJECT];
    
    Source* s = [[Source alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    [self.sourcesViewController addSource:s];
    [self.view.window close];
}
@end
