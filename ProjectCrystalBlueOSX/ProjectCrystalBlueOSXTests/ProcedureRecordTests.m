//
//  ProcedureTagTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProcedureRecord.h"

@interface ProcedureRecordTests : XCTestCase

@end

/**
 *  Test functionality of the ProcedureTag class.
 */
@implementation ProcedureRecordTests

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

/// Two objects created with identical tag/initials should be equal, even if they have different dates.
- (void)testEquality
{
    NSString *testTag = @"PROC1";
    NSString *testInitials = @"AAA";
    NSDate *now = [[NSDate alloc] init];
    NSDate *notNow = [NSDate distantFuture];
    
    ProcedureRecord *original = [[ProcedureRecord alloc] initWithTag:testTag
                                            andInitials:testInitials
                                                andDate:now];
    
    ProcedureRecord *diffDate = [[ProcedureRecord alloc] initWithTag:testTag
                                            andInitials:testInitials
                                                andDate:notNow];
    
    ProcedureRecord *diffTag = [[ProcedureRecord alloc] initWithTag:[[[NSUUID alloc] init] UUIDString]
                                            andInitials:testInitials
                                                andDate:now];
    
    ProcedureRecord *diffInitials = [[ProcedureRecord alloc] initWithTag:testTag
                                            andInitials:[[[NSUUID alloc] init] UUIDString]
                                                andDate:now];
    
    XCTAssertEqualObjects(original, original, @"A single object should be equal to itself.");
    XCTAssertEqual([original hash], [original hash], @"A single object should have generated the same hash.");
    XCTAssertEqualObjects(original, diffDate, @"The two procedure records should be equal");
    XCTAssertEqual([original hash], [diffDate hash], @"The two objects should have generated the same hash.");
    
    XCTAssertNotEqualObjects(original, diffTag,
                             @"The procedure with a different tag should not be equal.");
    XCTAssertNotEqualObjects(original, diffInitials,
                             @"The procedure with different initials should not be equal.");
}

/// Create a ProcedureRecord, convert it to a string, then initial another one from that string.
/// The new one should be equal to the old one.
- (void)testReadWrite
{
    NSString *testTag = @"PROC1";
    NSString *testInitials = @"AAA";
    NSDate *now = [[NSDate alloc] init];
    
    ProcedureRecord *original = [[ProcedureRecord alloc] initWithTag:testTag
                                                   andInitials:testInitials
                                                       andDate:now];
    
    NSString *originalAsString = [NSString stringWithFormat:@"%@", original];
    
    ProcedureRecord *fromString = [[ProcedureRecord alloc] initFromString:originalAsString];
    
    XCTAssertEqualObjects(original, fromString, @"The two records should be equal.");
}

@end
