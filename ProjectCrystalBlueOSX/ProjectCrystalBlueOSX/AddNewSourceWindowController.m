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
#import "GenerateQRCode.h"

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
    [self.meterTextField        setStringValue:SRC_DEF_VAL_METER];
    [self.latitudeTextField     setStringValue:SRC_DEF_VAL_LATITUDE];
    [self.longitudeTextField    setStringValue:SRC_DEF_VAL_LONGITUDE];
    [self.ageTextField          setStringValue:SRC_DEF_VAL_AGE];
    [self.ageMethodTextField    setStringValue:SRC_DEF_VAL_AGE_METHOD];
    [self.ageDataTypeTextField  setStringValue:SRC_DEF_VAL_AGE_DATATYPE];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self close];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *key = self.keyTextField.stringValue;
    [GenerateQRCode writeQRCode:self.keyTextField.stringValue];
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
    [attributes setObject:self.meterTextField.stringValue       forKey:SRC_METER];
    [attributes setObject:self.latitudeTextField.stringValue    forKey:SRC_LATITUDE];
    [attributes setObject:self.longitudeTextField.stringValue   forKey:SRC_LONGITUDE];
    [attributes setObject:self.ageTextField.stringValue         forKey:SRC_AGE];
    [attributes setObject:self.ageMethodTextField.stringValue   forKey:SRC_AGE_METHOD];
    [attributes setObject:self.ageDataTypeTextField.stringValue forKey:SRC_AGE_DATATYPE];

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
