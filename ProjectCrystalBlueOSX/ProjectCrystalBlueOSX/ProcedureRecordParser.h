//
//  ProcedureTagDecoder.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sample.h"

/**
 *  Class for decoding a list of tags into a user readable form.
 */
@interface ProcedureRecordParser : NSObject

/**
 *  Generates an array of user-readable procedure names,
 *  from a comma-separated list of record strings.
 *
 *  e.g. "{PR1|ME|1/1/00},{PR2|ME|1/1/00}" would return an array with the items "Procedure 1", "Procedure 2".
 */
+(NSArray *)nameArrayFromRecordList:(NSString *)recordList;

/**
 *  Generates an array of ProcedureRecord objects,
 *  from a comma-separated list of ProcedureRecords.
 *
 *  e.g. "{PR1|ME|1/1/00},{PR2|ME|1/1/00}" would return an array with the appropriate ProcedureRecord objects.
 */
+(NSArray *)procedureRecordArrayFromList:(NSString *)recordList;

/**
 *  Return the most recent procedure performed on this sample.
 *  If no procedures have been performed, returns the string "None".
 */
+(NSString *)mostRecentProcedurePerformedOnSample:(Sample *)sample;

/**
 *  Parses an array of Procedure TAGS,
 *  from a comma separated list of ProcedureRecords.
 *
 *  e.g. "{PR1|ME|1/1/00},{PR2|ME|1/1/00}" would return an array with the items "PR1", "PR2".
 */
+(NSArray *)tagArrayFromRecordList:(NSString *)recordList;

/**
 *  Generate an array of user-readible procedure names,
 *  from an array of tags.
 *
 *  e.g. An array with the items "PR1", "PR2" would return an array with the items "Procedure 1" and "Procedure 2".
 */
+(NSArray *)nameArrayFromTagArray:(NSArray *)tagList;

@end
