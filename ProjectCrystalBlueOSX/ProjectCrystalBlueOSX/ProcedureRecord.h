//
//  ProcedureRecord.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Serializable object that records information about a single procedure instance.
 */
@interface ProcedureRecord : NSObject

/// The tag associated with the procedure that was performed.
/// Generally this is one of the constants defined in ProcedureNameConstants.h
@property (readonly) NSString* tag;

/// The initials of the user who performed the procedure.
@property (readonly) NSString* initials;

/// The date & time that the procedure was performed.
@property (readonly) NSDate* date;

/// Initialize this object from a String (as created by the description method)
-(id)initFromString:(NSString *)stringRepresentation;

/// Initialize this object with a specified tag and initials. Uses the current date.
-(id)initWithTag:(NSString *)tag
     andInitials:(NSString *)initials;

/// Initialize this object with specified tag, initials, and date.
-(id)initWithTag:(NSString *)tag
     andInitials:(NSString *)initials
         andDate:(NSDate *)date;

/// String representation of the object, in the form {TAG|INITIALS|DATE}
-(NSString *)description;

/// Compare this ProcedureRecord to another. The equality is based only on TAG and INITIALS, not date.
-(BOOL)isEqual:(id)object;

/// Generate a hashcode for this ProcedureRecord. The hashcode is based only on TAG and INITIALS, not date.
-(NSUInteger)hash;

@end
