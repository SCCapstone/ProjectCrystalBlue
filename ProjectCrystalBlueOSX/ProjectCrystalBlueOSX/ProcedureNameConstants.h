//
//  ProcedureConstants.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Constants class to hold names and tags of procedures that can be applied to samples.
 */


/*  Human-readable procedure names.
 *  These can be presented in a list when viewing an individual sample.
 *  Some (e.g. HEAVY LIQUID) require a format argument.
 *  Each should have a one-to-one correspondence to a unique tag below.
 */
static NSString *const PROC_NAME_SLAB                       = @"Slab";
static NSString *const PROC_NAME_BILLET                     = @"Billet";
static NSString *const PROC_NAME_THIN_SECTION               = @"Thin-section";
static NSString *const PROC_NAME_TRIM                       = @"Trimmed";
static NSString *const PROC_NAME_PULVERIZE                  = @"Pulverized";
static NSString *const PROC_NAME_JAWCRUSH                   = @"Jaw-crushed";
static NSString *const PROC_NAME_GEMINI_DOWN                = @"Gemini DOWN";
static NSString *const PROC_NAME_GEMINI_UP                  = @"Gemini UP";
static NSString *const PROC_NAME_PAN_DOWN                   = @"Pan DOWN";
static NSString *const PROC_NAME_PAN_UP                     = @"Pan UP";
static NSString *const PROC_NAME_SIEVE_10_DOWN              = @"Sieve 10mm DOWN";
static NSString *const PROC_NAME_SIEVE_10_UP                = @"Sieve 10mm UP";
static NSString *const PROC_NAME_HEAVY_LIQUID_330_DOWN      = @"Heavy Liquid 3.30 DOWN";
static NSString *const PROC_NAME_HEAVY_LIQUID_330_UP        = @"Heavy Liquid 3.30 UP";
static NSString *const PROC_NAME_HEAVY_LIQUID_290_DOWN      = @"Heavy Liquid 2.90 DOWN";
static NSString *const PROC_NAME_HEAVY_LIQUID_290_UP        = @"Heavy Liquid 2.90 UP";
static NSString *const PROC_NAME_HEAVY_LIQUID_265_DOWN      = @"Heavy Liquid 2.65 DOWN";
static NSString *const PROC_NAME_HEAVY_LIQUID_265_UP        = @"Heavy Liquid 2.65 UP";
static NSString *const PROC_NAME_HEAVY_LIQUID_255_DOWN      = @"Heavy Liquid 2.55 DOWN";
static NSString *const PROC_NAME_HEAVY_LIQUID_255_UP        = @"Heavy Liquid 2.55 UP";
static NSString *const PROC_NAME_HAND_MAGNET_DOWN           = @"Hand-magnet DOWN";
static NSString *const PROC_NAME_HAND_MAGNET_UP             = @"Hand-magnet UP";
static NSString *const PROC_NAME_MAGNET_02_AMPS_UP          = @"Magnet 0.2 A UP";
static NSString *const PROC_NAME_MAGNET_02_AMPS_DOWN        = @"Magnet 0.2 A DOWN";
static NSString *const PROC_NAME_MAGNET_04_AMPS_UP          = @"Magnet 0.4 A UP";
static NSString *const PROC_NAME_MAGNET_04_AMPS_DOWN        = @"Magnet 0.4 A DOWN";
static NSString *const PROC_NAME_MAGNET_06_AMPS_UP          = @"Magnet 0.6 A UP";
static NSString *const PROC_NAME_MAGNET_06_AMPS_DOWN        = @"Magnet 0.6 A DOWN";
static NSString *const PROC_NAME_MAGNET_08_AMPS_UP          = @"Magnet 0.8 A UP";
static NSString *const PROC_NAME_MAGNET_08_AMPS_DOWN        = @"Magnet 0.8 A DOWN";
static NSString *const PROC_NAME_MAGNET_10_AMPS_UP          = @"Magnet 1.0 A UP";
static NSString *const PROC_NAME_MAGNET_10_AMPS_DOWN        = @"Magnet 1.0 A DOWN";
static NSString *const PROC_NAME_MAGNET_12_AMPS_UP          = @"Magnet 1.2 A UP";
static NSString *const PROC_NAME_MAGNET_12_AMPS_DOWN        = @"Magnet 1.2 A DOWN";
static NSString *const PROC_NAME_MAGNET_14_AMPS_UP          = @"Magnet 1.4 A UP";
static NSString *const PROC_NAME_MAGNET_14_AMPS_DOWN        = @"Magnet 1.4 A DOWN";

/**
 *  A special string format used to display a custom tag.
 *  The tag value should be passed as a format arg.
 */
static NSString *const PROC_NAME_CUSTOM                     = @"Custom Tag: '%@'";

/*  Short "tags" for internal/database storage purposes.
 *  A lowercase 'v' is used to indicate DOWN, while a caret ^ indicates UP.
 *  If any more tags are added to this, ensure that the corresponding item is added to
 *  the 'setupTagToNameMap' method in the implementation file.
 */
static NSString *const PROC_TAG_SLAB                    = @"SLB";
static NSString *const PROC_TAG_BILLET                  = @"BLT";
static NSString *const PROC_TAG_THIN_SECTION            = @"SCT";
static NSString *const PROC_TAG_TRIM                    = @"TRM";
static NSString *const PROC_TAG_PULVERIZE               = @"PLV";
static NSString *const PROC_TAG_JAWCRUSH                = @"JC";
static NSString *const PROC_TAG_GEMINI_DOWN             = @"GMv";
static NSString *const PROC_TAG_GEMINI_UP               = @"GM^";
static NSString *const PROC_TAG_PAN_DOWN                = @"PNv";
static NSString *const PROC_TAG_PAN_UP                  = @"PN^";
static NSString *const PROC_TAG_SIEVE_10_DOWN           = @"S10v";
static NSString *const PROC_TAG_SIEVE_10_UP             = @"S10^";
static NSString *const PROC_TAG_HEAVY_LIQUID_330_DOWN   = @"HL330v";
static NSString *const PROC_TAG_HEAVY_LIQUID_330_UP     = @"HL330^";
static NSString *const PROC_TAG_HEAVY_LIQUID_290_DOWN   = @"HL290v";
static NSString *const PROC_TAG_HEAVY_LIQUID_290_UP     = @"HL290^";
static NSString *const PROC_TAG_HEAVY_LIQUID_265_DOWN   = @"HL265v";
static NSString *const PROC_TAG_HEAVY_LIQUID_265_UP     = @"HL265^";
static NSString *const PROC_TAG_HEAVY_LIQUID_255_DOWN   = @"HL255v";
static NSString *const PROC_TAG_HEAVY_LIQUID_255_UP     = @"HL255^";
static NSString *const PROC_TAG_HAND_MAGNET_DOWN        = @"MHv";
static NSString *const PROC_TAG_HAND_MAGNET_UP          = @"MH^";
static NSString *const PROC_TAG_MAGNET_02_AMPS_UP       = @"M02^";
static NSString *const PROC_TAG_MAGNET_02_AMPS_DOWN     = @"M02v";
static NSString *const PROC_TAG_MAGNET_04_AMPS_UP       = @"M04^";
static NSString *const PROC_TAG_MAGNET_04_AMPS_DOWN     = @"M04v";
static NSString *const PROC_TAG_MAGNET_06_AMPS_UP       = @"M06^";
static NSString *const PROC_TAG_MAGNET_06_AMPS_DOWN     = @"M06v";
static NSString *const PROC_TAG_MAGNET_08_AMPS_UP       = @"M08^";
static NSString *const PROC_TAG_MAGNET_08_AMPS_DOWN     = @"M08v";
static NSString *const PROC_TAG_MAGNET_10_AMPS_UP       = @"M10^";
static NSString *const PROC_TAG_MAGNET_10_AMPS_DOWN     = @"M10v";
static NSString *const PROC_TAG_MAGNET_12_AMPS_UP       = @"M12^";
static NSString *const PROC_TAG_MAGNET_12_AMPS_DOWN     = @"M12v";
static NSString *const PROC_TAG_MAGNET_14_AMPS_UP       = @"M14^";
static NSString *const PROC_TAG_MAGNET_14_AMPS_DOWN     = @"M14v";

static NSString *const TAG_DELIMITER = @", ";

@interface ProcedureNameConstants : NSObject

/**
 *  Fetch a human-readable name that corresponds to a given tag.
 */
+(NSString *)procedureNameForTag:(NSString *)tag;

+(NSOrderedSet *)allProcedureTags;
+(NSOrderedSet *)allProcedureNames;

@end
