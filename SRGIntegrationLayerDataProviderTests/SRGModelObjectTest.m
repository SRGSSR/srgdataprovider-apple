//
//  SRGILModelObjectTest.m
//  SRGILMediaPlayer
//
//  Created by Cédric Foellmi on 21/11/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XCTestCase+JSON.h"
#import "SRGILModelObject.h"

@interface SRGILModelObjectTest : XCTestCase
@end

@implementation SRGILModelObjectTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNSObjectInit
{
    XCTAssertThrows([[SRGILModelObject alloc] init], @"Normal init should throw an exception.");
}

- (void)testDefaultInitWithNilDictionary
{
    XCTAssertNil([[SRGILModelObject alloc] initWithDictionary:nil], @"Providing a nil dictionary should return nil.");
}

- (void)testDefaultInitWithValidDictionary
{
    XCTAssertNotNil([[SRGILModelObject alloc] initWithDictionary:[self loadJSONFile:@"video_03" withClassName:@"Video"]],
                    @"Providing a valid dictionary should not return nil.");
}

@end
