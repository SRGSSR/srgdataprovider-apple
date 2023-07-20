//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderModel;
@import XCTest;

@interface ProgramTestCase : XCTestCase

@end

@implementation ProgramTestCase

- (void)testProgramWithImage
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{
        @"title" : @"Tagesschau",
        @"startTime" : @"2023-07-16T21:45:00+02:00",
        @"endTime" : @"2023-07-16T21:55:00+02:00",
        @"imageUrl" : @"https://il.srgssr.ch/integrationlayer/2.0/image-scale-sixteen-to-nine/https://www.srf.ch/static/programm/tv/images/smart_16x9/b6a461ca4cb60f45ba308dbaa297d26b4dbf06b9.jpg",
        @"imageIsFallbackUrl" : @(NO),
        @"imageTitle" : @"SRF News Tagesschau  Keyvisual 2020",
        @"mediaUrn" : @"urn:srf:video:f373c10e-88be-4bd2-b923-724209e7d707",
        @"subtitle" : @"Spätausgabe",
        @"isFollowUp" : @(NO)
    };
    
    SRGProgram *program = [MTLJSONAdapter modelOfClass:SRGProgram.class fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertNotNil(program.image);
}

- (void)testProgramWithFallbackImage
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{
       @"title" : @"BR24",
       @"startTime" : @"2023-07-16T18:30:00+02:00",
       @"endTime" : @"2023-07-16T18:45:00+02:00",
       @"imageUrl" : @"https://il.srgssr.ch/images/https://il.srgssr.ch/image-service/dynamic/ac2b84e.svg/format/png",
       @"imageIsFallbackUrl" : @(YES),
       @"subtitle" : @"Nachrichten - Berichte - Wettervorhersage",
       @"isFollowUp" : @(NO)
    };
    
    SRGProgram *program = [MTLJSONAdapter modelOfClass:SRGProgram.class fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    // See https://github.com/SRGSSR/srgdataprovider-apple/issues/48
    XCTAssertNil(program.image);
}

- (void)testProgramWithoutImage
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{
        @"title" : @"BR24",
        @"startTime" : @"2023-07-16T18:30:00+02:00",
        @"endTime" : @"2023-07-16T18:45:00+02:00",
        @"imageIsFallbackUrl" : @(YES),
        @"subtitle" : @"Nachrichten - Berichte - Wettervorhersage",
        @"isFollowUp" : @(NO)
    };
    
    SRGProgram *program = [MTLJSONAdapter modelOfClass:SRGProgram.class fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertNil(program.image);
}

@end
