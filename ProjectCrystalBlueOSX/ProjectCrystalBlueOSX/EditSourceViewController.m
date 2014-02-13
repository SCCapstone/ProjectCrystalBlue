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
    [self.keyTextField          setStringValue:[source.attributes objectForKey:KEY]];
    [self.continentTextField    setStringValue:[source.attributes objectForKey:CONTINENT]];
    [self.typeTextField         setStringValue:[source.attributes objectForKey:TYPE]];
    [self.lithologyTextField    setStringValue:[source.attributes objectForKey:LITHOLOGY]];
    [self.deposystemTextField   setStringValue:[source.attributes objectForKey:DEPOSYSTEM]];
    [self.groupTextField        setStringValue:[source.attributes objectForKey:GROUP]];
    [self.formationTextField    setStringValue:[source.attributes objectForKey:FORMATION]];
    [self.memberTextField       setStringValue:[source.attributes objectForKey:MEMBER]];
    [self.regionTextField       setStringValue:[source.attributes objectForKey:REGION]];
    [self.localityTextField     setStringValue:[source.attributes objectForKey:LOCALITY]];
    [self.sectionTextField      setStringValue:[source.attributes objectForKey:SECTION]];
    [self.meterLevelTextField   setStringValue:[source.attributes objectForKey:METER_LEVEL]];
    [self.latitudeTextField     setStringValue:[source.attributes objectForKey:LATITUDE]];
    [self.longitudeTextField    setStringValue:[source.attributes objectForKey:LONGITUDE]];
    [self.ageTextField          setStringValue:[source.attributes objectForKey:AGE]];
    [self.ageBasis1TextField    setStringValue:[source.attributes objectForKey:AGE_BASIS1]];
    [self.ageBasis2TextField    setStringValue:[source.attributes objectForKey:AGE_BASIS2]];
    [self.dateCollectedTextField setStringValue:[source.attributes objectForKey:DATE_COLLECTED]];
    [self.projectTextField      setStringValue:[source.attributes objectForKey:PROJECT]];
    [self.subProjectTextField   setStringValue:[source.attributes objectForKey:SUBPROJECT]];
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
    
    Source *newSource = [[Source alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    [[self.sourcesViewController sourcesStore] updateLibraryObject:newSource IntoTable:[SourceConstants tableName]];
    [self.view.window close];
}

@end
