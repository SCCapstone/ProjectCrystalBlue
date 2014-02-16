//
//  ProcedureTagDecoder.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class for decoding a list of tags into a user readable form.
 */
@interface ProcedureTagDecoder : NSObject

/**
 *  Generates an array of user-readable procedure names,
 *  from a comma-separated list of procedure TAGS.
 *
 *  e.g. "PR1, PR2, PR3" would return an array with the items "Procedure 1", "Procedure 2", "Procedure 3"
 */
+(NSArray *)nameArrayFromTags:(NSString *)tags;

/**
 *  Parses an array of procedure TAGS,
 *  from a comma separated list.
 *
 *  e.g. "TAG1, TAG2, TAG3" would return an array with the items "TAG1", "TAG2", and "TAG3"
 */
+(NSArray *)tagArrayFromCommaSeparatedTagString:(NSString *)tags;

/**
 *  Generate an array of user-readible procedure names,
 *  from an array of tags.
 *
 *  e.g. An array with the items "PR1", "PR2" would return an array with the items "Procedure 1" and "Procedure 2".
 */
+(NSArray *)nameArrayFromTagArray:(NSArray *)tags;

@end
