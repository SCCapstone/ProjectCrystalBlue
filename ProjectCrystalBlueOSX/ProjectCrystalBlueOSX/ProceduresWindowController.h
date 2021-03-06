//
//  ProceduresWindowController.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 3/3/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AbstractLibraryObjectStore, Split, SplitsTableViewController;

@interface ProceduresWindowController : NSWindowController

- (IBAction)cancelButton:(id)sender;
- (IBAction)applyProcedure:(id)sender;

@property (weak) IBOutlet NSTextField *initialsTextField;
@property (weak) IBOutlet NSPopUpButton *procedureSelector;
@property (weak) IBOutlet NSTextField *instructionsText;
@property Split *split;
@property AbstractLibraryObjectStore *dataStore;
@property SplitsTableViewController *splitsTableViewController;

@end

/* Constant string display names for procedures */
static NSString *longNameSlab      = @"Slab from split";
static NSString *longNameBillet    = @"Billet from split";
static NSString *longNameThinSect  = @"Thin-section from split";
static NSString *longNameTrim      = @"Trim split";
static NSString *longNamePulv      = @"Pulverize";
static NSString *longNameJawCrush  = @"Jaw-crush";
static NSString *longNameGemeni    = @"Gemeni separation";
static NSString *longNamePan       = @"Gold-pan separation";
static NSString *longNameSieve10   = @"Sieve 10mm separation";
static NSString *longNameHL330     = @"Heavy Liquid (SG = 3.30) separation";
static NSString *longNameHL290     = @"Heavy Liquid (SG = 2.90) separation";
static NSString *longNameHL265     = @"Heavy Liquid (SG = 2.65) separation";
static NSString *longNameHL255     = @"Heavy Liquid (SG = 2.55) separation";
static NSString *longNameHandMagnet= @"Hand magnet separation";
static NSString *longNameMagnet02A = @"Magnet (0.2 Amps) separation";
static NSString *longNameMagnet04A = @"Magnet (0.4 Amps) separation";
static NSString *longNameMagnet06A = @"Magnet (0.6 Amps) separation";
static NSString *longNameMagnet08A = @"Magnet (0.8 Amps) separation";
static NSString *longNameMagnet10A = @"Magnet (1.0 Amps) separation";
static NSString *longNameMagnet12A = @"Magnet (1.2 Amps) separation";
static NSString *longNameMagnet14A = @"Magnet (1.4 Amps) separation";