//
//  SRGILDataProviderMediaPlayerTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 15/06/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <RTSAnalytics/RTSAnalytics.h>
#import "SRGILDataProvider.h"
#import "SRGILDataProvider+MediaPlayer.h"

@interface SRGILDataProviderMediaPlayerTest : XCTestCase

@end

@implementation SRGILDataProviderMediaPlayerTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDataProviderConformances
{
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    XCTAssertTrue([dataProvider conformsToProtocol:@protocol(RTSMediaPlayerControllerDataSource)]);
    XCTAssertTrue([dataProvider conformsToProtocol:@protocol(RTSMediaSegmentsDataSource)]);
    XCTAssertTrue([dataProvider conformsToProtocol:@protocol(RTSAnalyticsMediaPlayerDataSource)]);
}

- (void)testDataProviderMediaPlayerControllerDataSourceWithValidIdentifier
{
    // http://www.rts.ch/play/tv/infrarouge/video/fifa-un-hôte-trop-encombrant-?id=6853450
    NSString *identifier = @"6853450";
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       identifier]];
    
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    [dataProvider mediaPlayerController:nil
                contentURLForIdentifier:identifier
                      completionHandler:^(NSURL *contentURL, NSError *error) {
                          XCTAssertNotNil(contentURL, @"Content URL must be present.");
                          XCTAssertNil(error, @"Error must be nil.");
                          
                          if (!error && contentURL) {
                              NSLog(@"The contentURL is: %@", contentURL);
                              [expectation fulfill];
                          }
                      }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testDataProviderMediaPlayerControllerDataSourceWithInvalidIdentifier
{
    // Invalid identifier
    NSString *identifier = @"685345028262-9320282";
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       identifier]];
    
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    [dataProvider mediaPlayerController:nil
                contentURLForIdentifier:identifier
                      completionHandler:^(NSURL *contentURL, NSError *error) {
                          XCTAssertNil(contentURL, @"Content URL must be nil.");
                          XCTAssertNotNil(error, @"Error must be present.");

                          if (error) {
                              NSLog(@"completion error: %@", error);
                              [expectation fulfill];
                          }
                      }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
