//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface MediaURNTestCase : DataProviderBaseTestCase

@end

@implementation MediaURNTestCase

#pragma mark Tests

- (void)testCreation
{
    NSString *URNString = @"urn:swi:video:41981254";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(mediaURN.uid, @"41981254");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorSWI));
    XCTAssertEqualObjects(mediaURN.URNString, URNString);
}

- (void)testCaseInsensitive
{
    SRGMediaURN *mediaURN1 = [[SRGMediaURN alloc] initWithURNString:@"URN:swi:video:41981254"];
    XCTAssertNotNil(mediaURN1);
    
    SRGMediaURN *mediaURN2 = [[SRGMediaURN alloc] initWithURNString:@"urn:SWI:video:41981254"];
    XCTAssertNotNil(mediaURN2);
    
    SRGMediaURN *mediaURN3 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:VIDEO:41981254"];
    XCTAssertNotNil(mediaURN3);
}

- (void)testIncorrectURNs
{
    SRGMediaURN *mediaURN1 = [[SRGMediaURN alloc] initWithURNString:@"fakeURN:swi:video:41981254"];
    XCTAssertNil(mediaURN1);
    
    SRGMediaURN *mediaURN2 = [[SRGMediaURN alloc] initWithURNString:@"swi:video:41981254"];
    XCTAssertNil(mediaURN2);
}

- (void)testEquality
{
    SRGMediaURN *mediaURN1 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:video:41981254"];
    SRGMediaURN *mediaURN2 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:video:41981254"];
    SRGMediaURN *mediaURN3 = [[SRGMediaURN alloc] initWithURNString:@"urn:srf:video:41981254"];
    SRGMediaURN *mediaURN4 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:video:99999999"];
    SRGMediaURN *mediaURN5 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:audio:41981254"];
    
    XCTAssertTrue([mediaURN1 isEqual:mediaURN2]);
    XCTAssertFalse([mediaURN1 isEqual:mediaURN3]);
    XCTAssertFalse([mediaURN1 isEqual:mediaURN4]);
    XCTAssertFalse([mediaURN1 isEqual:mediaURN5]);
}

@end
