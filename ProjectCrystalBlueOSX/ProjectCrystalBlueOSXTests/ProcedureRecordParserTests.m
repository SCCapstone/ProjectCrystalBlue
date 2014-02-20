//
//  ProcedureTagDecoderTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProcedureRecordParser.h"
#import "ProcedureNameConstants.h"
#import "ProcedureRecord.h"

@interface ProcedureRecordParserTests : XCTestCase

@end

@implementation ProcedureRecordParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseCommaSeparatedRecordsIntoArray
{
    NSString *initials = @"Bob";
    
    // generate a list of procedure records, comma separated.
    NSMutableString *commaSeparatedRecords = [NSMutableString stringWithString:@""];
    for (NSString *tag in [ProcedureNameConstants allProcedureTags]) {
        ProcedureRecord *record = [[ProcedureRecord alloc] initWithTag:tag andInitials:initials];
        if ([commaSeparatedRecords isEqualToString:@""]) {
            [commaSeparatedRecords appendFormat:@"%@", record];
        } else {
            [commaSeparatedRecords appendFormat:@"%@%@", TAG_DELIMITER, record];
        }
    }
    
    NSArray *parsedRecords = [ProcedureRecordParser procedureRecordArrayFromList:commaSeparatedRecords];
    
    for (NSString *tag in [ProcedureNameConstants allProcedureTags]) {
        ProcedureRecord *expected = [[ProcedureRecord alloc] initWithTag:tag andInitials:initials];
        XCTAssertTrue([parsedRecords containsObject:expected], @"Parsed records was missing record %@", expected);
    }
}

/// Checks that comma separated records are properly parsed into user-readible name list.
- (void)testParseCommaSeparatedRecordsIntoNames
{
    NSString *initials = @"Bob";
    
    // generate a list of procedure records, comma separated.
    NSMutableString *commaSeparatedRecords = [NSMutableString stringWithString:@""];
    for (NSString *tag in [ProcedureNameConstants allProcedureTags]) {
        ProcedureRecord *record = [[ProcedureRecord alloc] initWithTag:tag andInitials:initials];
        if ([commaSeparatedRecords isEqualToString:@""]) {
            [commaSeparatedRecords appendFormat:@"%@", record];
        } else {
            [commaSeparatedRecords appendFormat:@"%@%@", TAG_DELIMITER, record];
        }
    }
    
    NSArray *names = [ProcedureRecordParser nameArrayFromRecordList:commaSeparatedRecords];
    
    // We expect every name to be present in the final array.
    XCTAssertEqual(names.count, [ProcedureNameConstants allProcedureNames].count);
    
    for (NSString *name in [ProcedureNameConstants allProcedureNames]) {
        XCTAssertTrue([names containsObject:name], @"Decoded array didn't include %@", name);
    }
}

/// Tests the decoder handles custom tags properly ("custom" meaning a tag not predefined in ProcedureNameConstants).
- (void)testCustomTag
{
    NSString *initials = @"Alf";
    
    NSString *CUSTOM_TAG01 = @"CSTM";
    NSString *expectedNameForCustomTag01 = [NSString stringWithFormat:PROC_NAME_CUSTOM, CUSTOM_TAG01];
    
    NSString *CUSTOM_TAG02 = @"ASDF";
    NSString *expectedNameForCustomTag02 = [NSString stringWithFormat:PROC_NAME_CUSTOM, CUSTOM_TAG02];
    
    // To test this behavior, we'll use a mix of custom and supported tags.
    NSString *commaSeparatedRecords = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                                    [[ProcedureRecord alloc] initWithTag:CUSTOM_TAG01 andInitials:initials],
                                    TAG_DELIMITER,
                                    [[ProcedureRecord alloc] initWithTag:PROC_TAG_BILLET andInitials:initials],
                                    TAG_DELIMITER,
                                    [[ProcedureRecord alloc] initWithTag:CUSTOM_TAG02 andInitials:initials],
                                    TAG_DELIMITER,
                                    [[ProcedureRecord alloc] initWithTag:PROC_TAG_GEMINI_DOWN andInitials:initials]];
    
    NSArray *nameArray = [ProcedureRecordParser nameArrayFromRecordList:commaSeparatedRecords];
    
    XCTAssertEqualObjects([nameArray objectAtIndex:0], expectedNameForCustomTag01);
    XCTAssertEqualObjects([nameArray objectAtIndex:1], PROC_NAME_BILLET);
    XCTAssertEqualObjects([nameArray objectAtIndex:2], expectedNameForCustomTag02);
    XCTAssertEqualObjects([nameArray objectAtIndex:3], PROC_NAME_GEMINI_DOWN);
}

/// Checks that all the methods give expected results for empty string or empty array as args
- (void)testEmptyStringArguments
{
    NSArray *emptyArray = [[NSArray alloc] init];
    NSString *emptyString = @"";
    
    NSArray *nameArrayFromEmptyTagString = [ProcedureRecordParser nameArrayFromRecordList:emptyString];
    XCTAssertEqualObjects(nameArrayFromEmptyTagString, emptyArray,
                          @"Actual array generated by nameArrayFromTags wasn't empty!");
    
    NSArray *tagArrayFromEmptyString = [ProcedureRecordParser tagArrayFromRecordList:emptyString];
    XCTAssertEqualObjects(tagArrayFromEmptyString, emptyArray,
                          @"Actual array generated by tagArrayFromCommaSeparatedTagString wasn't empty!");
    
    NSArray *nameArrayFromEmptyArray = [ProcedureRecordParser nameArrayFromTagArray:emptyArray];
    XCTAssertEqualObjects(nameArrayFromEmptyArray, emptyArray,
                          @"Actual array generated by nameArrayFromTagArray wasn't empty!");
}

@end
