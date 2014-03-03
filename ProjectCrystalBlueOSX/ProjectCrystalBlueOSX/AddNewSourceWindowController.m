//
//  AddNewSourceWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddNewSourceWindowController.h"
#import "SourcesViewController.h"
#import "SourceConstants.h"
#import "Source.h"

#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface AddNewSourceWindowController ()

@end

@implementation AddNewSourceWindowController

@synthesize sourcesViewController;

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
    [self.keyTextField          setStringValue:SRC_DEF_VAL_KEY];
    [self.continentTextField    setStringValue:SRC_DEF_VAL_CONTINENT];
    [self.typeTextField         setStringValue:SRC_DEF_VAL_TYPE];
    [self.lithologyTextField    setStringValue:SRC_DEF_VAL_LITHOLOGY];
    [self.deposystemTextField   setStringValue:SRC_DEF_VAL_DEPOSYSTEM];
    [self.groupTextField        setStringValue:SRC_DEF_VAL_GROUP];
    [self.formationTextField    setStringValue:SRC_DEF_VAL_FORMATION];
    [self.memberTextField       setStringValue:SRC_DEF_VAL_MEMBER];
    [self.regionTextField       setStringValue:SRC_DEF_VAL_REGION];
    [self.localityTextField     setStringValue:SRC_DEF_VAL_LOCALITY];
    [self.sectionTextField      setStringValue:SRC_DEF_VAL_SECTION];
    [self.meterLevelTextField   setStringValue:SRC_DEF_VAL_METER_LEVEL];
    [self.latitudeTextField     setStringValue:SRC_DEF_VAL_LATITUDE];
    [self.longitudeTextField    setStringValue:SRC_DEF_VAL_LONGITUDE];
    [self.ageTextField          setStringValue:SRC_DEF_VAL_AGE];
    [self.ageBasis1TextField    setStringValue:SRC_DEF_VAL_AGE_BASIS1];
    [self.ageBasis2TextField    setStringValue:SRC_DEF_VAL_AGE_BASIS2];
    [self.projectTextField      setStringValue:SRC_DEF_VAL_PROJECT];
    [self.subProjectTextField   setStringValue:SRC_DEF_VAL_SUBPROJECT];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self close];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *key = self.keyTextField.stringValue;

    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjects:[SourceConstants attributeDefaultValues]
                                                                           forKeys:[SourceConstants attributeNames]];

    [attributes setObject:self.keyTextField.stringValue         forKey:SRC_KEY];
    [attributes setObject:self.continentTextField.stringValue   forKey:SRC_CONTINENT];
    [attributes setObject:self.typeTextField.stringValue        forKey:SRC_TYPE];
    [attributes setObject:self.lithologyTextField.stringValue   forKey:SRC_LITHOLOGY];
    [attributes setObject:self.deposystemTextField.stringValue  forKey:SRC_DEPOSYSTEM];
    [attributes setObject:self.groupTextField.stringValue       forKey:SRC_GROUP];
    [attributes setObject:self.formationTextField.stringValue   forKey:SRC_FORMATION];
    [attributes setObject:self.memberTextField.stringValue      forKey:SRC_MEMBER];
    [attributes setObject:self.regionTextField.stringValue      forKey:SRC_REGION];
    [attributes setObject:self.localityTextField.stringValue    forKey:SRC_LOCALITY];
    [attributes setObject:self.sectionTextField.stringValue     forKey:SRC_SECTION];
    [attributes setObject:self.meterLevelTextField.stringValue  forKey:SRC_METER_LEVEL];
    [attributes setObject:self.latitudeTextField.stringValue    forKey:SRC_LATITUDE];
    [attributes setObject:self.longitudeTextField.stringValue   forKey:SRC_LONGITUDE];
    [attributes setObject:self.ageTextField.stringValue         forKey:SRC_AGE];
    [attributes setObject:self.ageBasis1TextField.stringValue   forKey:SRC_AGE_BASIS1];
    [attributes setObject:self.ageBasis2TextField.stringValue   forKey:SRC_AGE_BASIS2];
    [attributes setObject:self.projectTextField.stringValue     forKey:SRC_PROJECT];
    [attributes setObject:self.subProjectTextField.stringValue  forKey:SRC_SUBPROJECT];

    NSDate *dateCollected = self.dateCollectedPicker.dateValue;

    DDLogInfo(@"%@: %@", NSStringFromClass(self.class), dateCollected);

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [formatter stringFromDate:dateCollected];

    [attributes setObject:dateString
                   forKey:SRC_DATE_COLLECTED];

    DDLogInfo(@"%@: %@", NSStringFromClass(self.class), dateString);

    Source* s = [[Source alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    [self.sourcesViewController addSource:s];
    [self close];
}


@end
