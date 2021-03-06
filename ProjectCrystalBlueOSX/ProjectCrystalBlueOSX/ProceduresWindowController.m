//
//  ProceduresWindowController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/3/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProceduresWindowController.h"
#import "SplitsTableViewController.h"
#import "ProcedureNameConstants.h"
#import "ProcedureFieldValidator.h"
#import "Procedures.h"
#import "Split.h"
#import "PCBLogWrapper.h"

@interface ProceduresWindowController ()

@end

@implementation ProceduresWindowController

@synthesize initialsTextField;
@synthesize procedureSelector;
@synthesize instructionsText;
@synthesize split;
@synthesize dataStore;
@synthesize splitsTableViewController;

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
                        split.key];
    [instructionsText setStringValue:instructions];

    [self populateProcedureSelector];
}

/// Validates the contents of the initials field. If the values are not valid, then a pop-up will
/// be displayed to the user with the validation issue(s).
- (BOOL)initialsAreValid
{
    ValidationResponse *response = [ProcedureFieldValidator validateInitials:initialsTextField.stringValue];

    if (!response.isValid) {

        NSAlert *alert = [response alertWithFieldName:@"initials"
                                           fieldValue:initialsTextField.stringValue];

        [alert runModal];
    }

    return response.isValid;
}

- (IBAction)cancelButton:(id)sender {
    [self.window close];
}

- (IBAction)applyProcedure:(id)sender {
    if (![self initialsAreValid]) {
        return;
    }

    NSString *selectedProcedureName = [[procedureSelector selectedItem] title];
    DDLogDebug(@"%s: %@", __PRETTY_FUNCTION__, selectedProcedureName);

    if ([longNameSlab isEqualToString:selectedProcedureName]) {
        [Procedures makeSlabfromSplit:split
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    } else if ([longNameBillet isEqualToString:selectedProcedureName]) {
        [Procedures makeBilletfromSplit:split
                            withInitials:initialsTextField.stringValue
                                 inStore:dataStore];
    } else if ([longNameThinSect isEqualToString:selectedProcedureName]) {
        [Procedures makeThinSectionfromSplit:split
                                 withInitials:initialsTextField.stringValue
                                      inStore:dataStore];
    } else if ([longNameTrim isEqualToString:selectedProcedureName]) {
        [Procedures trimSplit:split
                  withInitials:initialsTextField.stringValue
                       inStore:dataStore];
    } else if ([longNamePulv isEqualToString:selectedProcedureName]) {
        [Procedures pulverizeSplit:split
                       withInitials:initialsTextField.stringValue
                            inStore:dataStore];
    } else if ([longNameJawCrush isEqualToString:selectedProcedureName]) {
        [Procedures jawCrushSplit:split
                      withInitials:initialsTextField.stringValue
                           inStore:dataStore];
    } else if ([longNameGemeni isEqualToString:selectedProcedureName]) {
        [Procedures gemeniSplit:split
                    withInitials:initialsTextField.stringValue
                         inStore:dataStore];
    } else if ([longNamePan isEqualToString:selectedProcedureName]) {
        [Procedures panSplit:split
                 withInitials:initialsTextField.stringValue
                      inStore:dataStore];
    } else if ([longNameSieve10 isEqualToString:selectedProcedureName]) {
        [Procedures sievesTenSplit:split
                       withInitials:initialsTextField.stringValue
                            inStore:dataStore];
    } else if ([longNameHL330 isEqualToString:selectedProcedureName]) {
        [Procedures heavyLiquid_330_Split:split
                      withInitials:initialsTextField.stringValue
                           inStore:dataStore];
    } else if ([longNameHL290 isEqualToString:selectedProcedureName]) {
        [Procedures heavyLiquid_290_Split:split
                              withInitials:initialsTextField.stringValue
                                   inStore:dataStore];
    } else if ([longNameHL265 isEqualToString:selectedProcedureName]) {
        [Procedures heavyLiquid_265_Split:split
                              withInitials:initialsTextField.stringValue
                                   inStore:dataStore];
    } else if ([longNameHL255 isEqualToString:selectedProcedureName]) {
        [Procedures heavyLiquid_255_Split:split
                              withInitials:initialsTextField.stringValue
                                   inStore:dataStore];
    } else if ([longNameHandMagnet isEqualToString:selectedProcedureName]) {
        [Procedures handMagnetSplit:split
                        withInitials:initialsTextField.stringValue
                             inStore:dataStore];
    } else if ([longNameMagnet02A isEqualToString:selectedProcedureName]) {
        [Procedures magnet02AmpsSplit:split
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    } else if ([longNameMagnet04A isEqualToString:selectedProcedureName]) {
        [Procedures magnet04AmpsSplit:split
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    } else if ([longNameMagnet06A isEqualToString:selectedProcedureName]) {
        [Procedures magnet06AmpsSplit:split
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    } else if ([longNameMagnet08A isEqualToString:selectedProcedureName]) {
        [Procedures magnet08AmpsSplit:split
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    } else if ([longNameMagnet10A isEqualToString:selectedProcedureName]) {
        [Procedures magnet10AmpsSplit:split
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    } else if ([longNameMagnet12A isEqualToString:selectedProcedureName]) {
        [Procedures magnet12AmpsSplit:split
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    } else if ([longNameMagnet14A isEqualToString:selectedProcedureName]) {
        [Procedures magnet14AmpsSplit:split
                          withInitials:initialsTextField.stringValue
                               inStore:dataStore];
    }
    [splitsTableViewController updateDisplayedSplits];
    [self.window close];
}

- (void)populateProcedureSelector
{
    [procedureSelector addItemWithTitle:longNameSlab];
    [procedureSelector addItemWithTitle:longNameBillet];
    [procedureSelector addItemWithTitle:longNameThinSect];
    [procedureSelector addItemWithTitle:longNameTrim];
    [procedureSelector addItemWithTitle:longNameJawCrush];
    [procedureSelector addItemWithTitle:longNamePulv];
    [procedureSelector addItemWithTitle:longNameGemeni];
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
