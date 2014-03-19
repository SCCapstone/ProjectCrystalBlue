//
//  EditSourceViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/13/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "EditSourceViewController.h"

@interface EditSourceViewController ()

@end

@implementation EditSourceViewController
@synthesize source;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
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
    [self.keyTextField          setStringValue:[source.attributes objectForKey:SRC_KEY]];
    [self.continentTextField    setStringValue:[source.attributes objectForKey:SRC_CONTINENT]];
    [self.typeTextField         setStringValue:[source.attributes objectForKey:SRC_TYPE]];
    [self.lithologyTextField    setStringValue:[source.attributes objectForKey:SRC_LITHOLOGY]];
    [self.deposystemTextField   setStringValue:[source.attributes objectForKey:SRC_DEPOSYSTEM]];
    [self.groupTextField        setStringValue:[source.attributes objectForKey:SRC_GROUP]];
    [self.formationTextField    setStringValue:[source.attributes objectForKey:SRC_FORMATION]];
    [self.memberTextField       setStringValue:[source.attributes objectForKey:SRC_MEMBER]];
    [self.regionTextField       setStringValue:[source.attributes objectForKey:SRC_REGION]];
    [self.localityTextField     setStringValue:[source.attributes objectForKey:SRC_LOCALITY]];
    [self.sectionTextField      setStringValue:[source.attributes objectForKey:SRC_SECTION]];
    [self.meterTextField        setStringValue:[source.attributes objectForKey:SRC_METER]];
    [self.latitudeTextField     setStringValue:[source.attributes objectForKey:SRC_LATITUDE]];
    [self.longitudeTextField    setStringValue:[source.attributes objectForKey:SRC_LONGITUDE]];
    [self.ageTextField          setStringValue:[source.attributes objectForKey:SRC_AGE]];
    [self.ageMethodTextField    setStringValue:[source.attributes objectForKey:SRC_AGE_METHOD]];
    [self.ageDataTypeTextField  setStringValue:[source.attributes objectForKey:SRC_AGE_DATATYPE]];
    [self.dateCollectedTextField setStringValue:[source.attributes objectForKey:SRC_DATE_COLLECTED]];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.view.window close];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    NSString *key = self.keyTextField.stringValue;
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjects:[SourceConstants attributeDefaultValues]
                                                                           forKeys:[SourceConstants attributeNames]];
                                       
    [attributes setObject:self.keyTextField.stringValue             forKey:SRC_KEY];
    [attributes setObject:self.continentTextField.stringValue       forKey:SRC_CONTINENT];
    [attributes setObject:self.typeTextField.stringValue            forKey:SRC_TYPE];
    [attributes setObject:self.lithologyTextField.stringValue       forKey:SRC_LITHOLOGY];
    [attributes setObject:self.deposystemTextField.stringValue      forKey:SRC_DEPOSYSTEM];
    [attributes setObject:self.groupTextField.stringValue           forKey:SRC_GROUP];
    [attributes setObject:self.formationTextField.stringValue       forKey:SRC_FORMATION];
    [attributes setObject:self.memberTextField.stringValue          forKey:SRC_MEMBER];
    [attributes setObject:self.regionTextField.stringValue          forKey:SRC_REGION];
    [attributes setObject:self.localityTextField.stringValue        forKey:SRC_LOCALITY];
    [attributes setObject:self.sectionTextField.stringValue         forKey:SRC_SECTION];
    [attributes setObject:self.meterTextField.stringValue           forKey:SRC_METER];
    [attributes setObject:self.latitudeTextField.stringValue        forKey:SRC_LATITUDE];
    [attributes setObject:self.longitudeTextField.stringValue       forKey:SRC_LONGITUDE];
    [attributes setObject:self.ageTextField.stringValue             forKey:SRC_AGE];
    [attributes setObject:self.ageMethodTextField.stringValue       forKey:SRC_AGE_METHOD];
    [attributes setObject:self.ageDataTypeTextField.stringValue     forKey:SRC_AGE_DATATYPE];
    [attributes setObject:self.dateCollectedTextField.stringValue   forKey:SRC_DATE_COLLECTED];
    
    Source *newSource = [[Source alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    [[self.sourcesViewController dataStore] updateLibraryObject:newSource IntoTable:[SourceConstants tableName]];
    [self.view.window close];
}

@end
