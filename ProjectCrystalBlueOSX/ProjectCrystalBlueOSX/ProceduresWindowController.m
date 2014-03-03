//
//  ProceduresWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/3/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProceduresWindowController.h"
#import "SamplesWindowController.h"
#import "ProcedureNameConstants.h"
#import "Procedures.h"
#import "Sample.h"

// Logging
#import "DDLog.h"
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface ProceduresWindowController ()

@end

@implementation ProceduresWindowController

@synthesize initialsTextField;
@synthesize procedureSelector;
@synthesize instructionsText;
@synthesize sample;
@synthesize dataStore;
@synthesize samplesWindow;

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
    NSString *instructions;
    instructions = [NSString stringWithFormat:@"Select a procedure to apply to %@. Please triple-check that you are applying the correct procedure, enter your initials, then click Apply Procedure.",
                        sample.key];
    [instructionsText setStringValue:instructions];

    [self populateProcedureSelector];
}

- (IBAction)cancelButton:(id)sender {
    [self.window close];
}

- (IBAction)applyProcedure:(id)sender {
    NSString *selectedProcedureName = [[procedureSelector selectedItem] title];
    DDLogDebug(@"%s: %@", __PRETTY_FUNCTION__, selectedProcedureName);

    if ([longNameSlab isEqualToString:selectedProcedureName]) {
        [Procedures makeSlabfromSample:sample
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    } else if ([longNameBillet isEqualToString:selectedProcedureName]) {
        [Procedures makeBilletfromSample:sample
                            withInitials:initialsTextField.stringValue
                                 inStore:dataStore];
    } else if ([longNameThinSect isEqualToString:selectedProcedureName]) {
        [Procedures makeThinSectionfromSample:sample
                                 withInitials:initialsTextField.stringValue
                                      inStore:dataStore];
    } else if ([longNameTrim isEqualToString:selectedProcedureName]) {
        [Procedures trimSample:sample
                  withInitials:initialsTextField.stringValue
                       inStore:dataStore];
    } else if ([longNamePulv isEqualToString:selectedProcedureName]) {
        [Procedures pulverizeSample:sample
                       withInitials:initialsTextField.stringValue
                            inStore:dataStore];
    } else if ([longNameJawCrush isEqualToString:selectedProcedureName]) {
        [Procedures jawCrushSample:sample
                      withInitials:initialsTextField.stringValue
                           inStore:dataStore];
    }
    [samplesWindow reloadSamples];
    [self.window close];
}

- (void)populateProcedureSelector
{
    [procedureSelector addItemWithTitle:longNameSlab];
    [procedureSelector addItemWithTitle:longNameBillet];
    [procedureSelector addItemWithTitle:longNameThinSect];
    [procedureSelector addItemWithTitle:longNameTrim];
    [procedureSelector addItemWithTitle:longNamePulv];
    [procedureSelector addItemWithTitle:longNameJawCrush];
    [procedureSelector addItemWithTitle:longNameGemini];
    [procedureSelector addItemWithTitle:longNamePan];
    [procedureSelector addItemWithTitle:longNameSieve10];
    [procedureSelector addItemWithTitle:longNameHL330];
    [procedureSelector addItemWithTitle:longNameHL290];
    [procedureSelector addItemWithTitle:longNameHL265];
    [procedureSelector addItemWithTitle:longNameHL255];
    [procedureSelector addItemWithTitle:longNameHandMagnet];
    [procedureSelector addItemWithTitle:longNameMagnet02A];
    [procedureSelector addItemWithTitle:longNameMagnet04A];
    [procedureSelector addItemWithTitle:longNameMagnet06A];
    [procedureSelector addItemWithTitle:longNameMagnet08A];
    [procedureSelector addItemWithTitle:longNameMagnet10A];
    [procedureSelector addItemWithTitle:longNameMagnet12A];
    [procedureSelector addItemWithTitle:longNameMagnet14A];
}
@end
