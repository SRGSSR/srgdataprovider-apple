//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderNetwork;
@import XCTest;

@import libextobjc;

static NSString * const kAudioSearchQuery = @"tennis";
static NSString * const kAudioURN = @"urn:rsi:audio:2198491";

static NSString * const kRadioChannelUid = @"rete-uno";
static NSString * const kRadioLivestreamUid = @"livestream_ReteUno";
static NSString * const kRadioShowSearchQuery = @"modem";

static NSString * const kVideoURN = @"urn:rsi:video:1391801";

static NSString * const kTVChannelUid = @"la1";
static NSString * const kTVLivestreamUid = @"livestream_La1";
static NSString * const kTVShowSearchQuery = @"telegiornale";

static NSString * const kTVTopicUid = @"7";

static NSString * const kTVShowURN = @"urn:rsi:show:tv:703571";
static NSString * const kTVShowOtherURN = @"urn:rsi:show:tv:704146";
static NSString * const kRadioShowURN = @"urn:rsi:show:radio:703560";
static NSString * const kRadioShowOtherURN = @"urn:rsi:show:radio:1864030";
static NSString * const kInvalidShowURN = @"urn:rsi:show:tv:999999999999999";
static NSString * const kInvalidShowOtherURN = @"urn:srf:show:tv:999999999999999";

static NSString * const kTag1 = @"sportapp";
static NSString * const kTag2 = @"curling";

static NSString * const kUserId = @"test_user_id";

@interface RSIServicesTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation RSIServicesTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testTVChannels
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvChannelsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(channels);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvChannelForVendor:SRGVendorRSI withUid:kTVChannelUid completionBlock:^(SRGChannel * _Nullable channel, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestPrograms
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLatestProgramsForVendor:SRGVendorRSI channelUid:kTVChannelUid livestreamUid:nil fromDate:nil toDate:nil withCompletionBlock:^(SRGProgramComposition * _Nullable programComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(programComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLatestProgramsForVendor:SRGVendorRSI channelUid:kTVChannelUid livestreamUid:kTVLivestreamUid fromDate:nil toDate:nil withCompletionBlock:^(SRGProgramComposition * _Nullable programComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(programComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVPrograms
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvProgramsForVendor:SRGVendorRSI provider:SRGProgramProviderSRG channelUid:nil day:nil minimal:NO withCompletionBlock:^(NSArray<SRGProgramComposition *> * _Nullable programCompositions, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(programCompositions);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvProgramsForVendor:SRGVendorRSI provider:SRGProgramProviderThirdParty channelUid:nil day:nil minimal:NO withCompletionBlock:^(NSArray<SRGProgramComposition *> * _Nullable programCompositions, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLivestreams
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLivestreamsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVScheduledLivestreams
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvScheduledLivestreamsForVendor:SRGVendorRSI signLanguageOnly:NO eventType:SRGScheduledLivestreamEventTypeAll withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvScheduledLivestreamsForVendor:SRGVendorRSI signLanguageOnly:YES eventType:SRGScheduledLivestreamEventTypeAll withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvScheduledLivestreamsForVendor:SRGVendorRSI signLanguageOnly:NO eventType:SRGScheduledLivestreamEventTypeNews withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvScheduledLivestreamsForVendor:SRGVendorRSI signLanguageOnly:NO eventType:SRGScheduledLivestreamEventTypeSport withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVEditorialMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvEditorialMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Not supported for RSI
- (void)testTVHeroStageMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvHeroStageMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvLatestMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVMostPopularMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvMostPopularMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVSoonExpiringMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvSoonExpiringMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVTrendingMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvTrendingMediasForVendor:SRGVendorRSI withLimit:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestEpisodes
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLatestEpisodesForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestWebFirstEpisodes
{
    XCTSkip("Not supported anymore");
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLatestWebFirstEpisodesForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvEpisodesForVendor:SRGVendorRSI day:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    SRGDay *day = [SRGDay day:12 month:5 year:2016];
    [[self.dataProvider tvEpisodesForVendor:SRGVendorRSI day:day withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVTopics
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvTopicsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(topics);
        XCTAssertNil(error);
        
        SRGTopic *topic = topics.firstObject;
        XCTAssertNotNil(topic);
        XCTAssertNotEqual(topic.subtopics.count, 0);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShows
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShowsMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowsForVendor:SRGVendorRSI matchingQuery:kTVShowSearchQuery withCompletionBlock:^(NSArray<NSString *> * _Nullable showURNs, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(showURNs);
        XCTAssertNotNil(total);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVMostPopularShowsForTopic
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvMostPopularShowsForVendor:SRGVendorRSI topicUid:kTVTopicUid withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertTrue(shows.count > 0);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioChannels
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioChannelsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(channels);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioChannelPrograms
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestProgramsForVendor:SRGVendorRSI channelUid:kRadioChannelUid livestreamUid:nil fromDate:nil toDate:nil withCompletionBlock:^(SRGProgramComposition * _Nullable programComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(programComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestProgramsForVendor:SRGVendorRSI channelUid:kRadioChannelUid livestreamUid:kRadioLivestreamUid fromDate:nil toDate:nil withCompletionBlock:^(SRGProgramComposition * _Nullable programComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(programComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioChannel
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioChannelForVendor:SRGVendorRSI withUid:kRadioChannelUid livestreamUid:nil completionBlock:^(SRGChannel * _Nullable channel, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    [[self.dataProvider radioChannelForVendor:SRGVendorRSI withUid:kRadioChannelUid livestreamUid:kRadioLivestreamUid completionBlock:^(SRGChannel * _Nullable channel, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLivestreamsForContentProviders
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioLivestreamsForVendor:SRGVendorRSI contentProviders:SRGContentProvidersDefault withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    [[self.dataProvider radioLivestreamsForVendor:SRGVendorRSI contentProviders:SRGContentProvidersAll withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request 3 succeeded"];
    
    [[self.dataProvider radioLivestreamsForVendor:SRGVendorRSI contentProviders:SRGContentProvidersSwissSatelliteRadio withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLivestreamsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLivestreamsForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestMediasForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestMediasForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioMostPopularMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioMostPopularMediasForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestEpisodesForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestEpisodesForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioEpisodesForVendor:SRGVendorRSI channelUid:kRadioChannelUid day:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    SRGDay *day = [SRGDay day:12 month:5 year:2016];
    [[self.dataProvider radioEpisodesForVendor:SRGVendorRSI channelUid:kRadioChannelUid day:day withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestVideosForChannel
{
    XCTSkip("Not supported anymore for RSI");
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestVideosForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioTopics
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioTopicsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(topics);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsForVendor:SRGVendorRSI matchingQuery:kRadioShowSearchQuery withCompletionBlock:^(NSArray<NSString *> * _Nullable showURNs, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(showURNs);
        XCTAssertNotNil(total);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioSongsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioSongsForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGSong *> * _Nullable songs, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(songs);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioCurrentSongForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioCurrentSongForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(SRGSong * _Nullable song, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        // The song might be nil if nothing is being played on air 
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLiveCenterVideos
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI contentTypeFilter:SRGContentTypeFilterNone eventsWithResultOnly:YES withTags:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI contentTypeFilter:SRGContentTypeFilterScheduledLivestream eventsWithResultOnly:YES withTags:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGMedia.new, contentType), @(SRGContentTypeScheduledLivestream)];
        XCTAssertEqual([medias filteredArrayUsingPredicate:predicate].count, medias.count);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI contentTypeFilter:SRGContentTypeFilterEpisode eventsWithResultOnly:YES withTags:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGMedia.new, contentType), @(SRGContentTypeEpisode)];
        XCTAssertEqual([medias filteredArrayUsingPredicate:predicate].count, medias.count);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI contentTypeFilter:SRGContentTypeFilterNone eventsWithResultOnly:NO withTags:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];

    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];

    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI contentTypeFilter:SRGContentTypeFilterScheduledLivestream eventsWithResultOnly:NO withTags:@[kTag1] withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation5 fulfill];
    }] resume];

    [self waitForExpectationsWithTimeout:30. handler:nil];

    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];

    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI contentTypeFilter:SRGContentTypeFilterScheduledLivestream eventsWithResultOnly:NO withTags:@[kTag1, kTag2] withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation6 fulfill];
    }] resume];

    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediasMatchingQuery
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    SRGMediaSearchSettings *settings = [[SRGMediaSearchSettings alloc] init];
    settings.matchingOptions = SRGSearchMatchingOptionAny;
    settings.showURNs = [NSSet setWithObjects:@"urn:rsi:show:tv:3566695", @"urn:rsi:show:tv:9376660", nil];
    settings.topicURNs = [NSSet setWithObjects:@"urn:rsi:topic:tv:7", @"urn:rsi:topic:tv:8", nil];
    settings.mediaType = SRGMediaTypeVideo;
    settings.subtitlesAvailable = NO;
    settings.downloadAvailable = NO;
    settings.playableAbroad = YES;
    settings.quality = SRGQualityHD;
    settings.minimumDurationInMinutes = @0.;
    settings.maximumDurationInMinutes = @60.;
    settings.toDay = SRGDay.today;
    settings.fromDay = [SRGDay dayByAddingDays:-1 months:0 years:0 toDay:SRGDay.today];
    settings.sortCriterium = SRGSortCriteriumDate;
    settings.sortDirection = SRGSortDirectionAscending;
    
    [[self.dataProvider mediasForVendor:SRGVendorRSI matchingQuery:@"fderer" withSettings:settings completionBlock:^(NSArray<NSString *> * _Nullable mediaURNs, NSNumber * _Nullable total, SRGMediaAggregations * _Nullable aggregations, NSArray<SRGSearchSuggestion *> * _Nullable suggestions, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaURNs);
        XCTAssertNotNil(aggregations);
        XCTAssertNil(suggestions);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    settings.aggregationsEnabled = NO;
    settings.suggestionsEnabled = YES;
    
    [[self.dataProvider mediasForVendor:SRGVendorRSI matchingQuery:@"fderer" withSettings:settings completionBlock:^(NSArray<NSString *> * _Nullable mediaURNs, NSNumber * _Nullable total, SRGMediaAggregations * _Nullable aggregations, NSArray<SRGSearchSuggestion *> * _Nullable suggestions, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaURNs);
        XCTAssertNil(aggregations);
        XCTAssertNil(suggestions); // Not supported by the new search
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasForVendor:SRGVendorRSI matchingQuery:@"fderer" withSettings:nil completionBlock:^(NSArray<NSString *> * _Nullable mediaURNs, NSNumber * _Nullable total, SRGMediaAggregations * _Nullable aggregations, NSArray<SRGSearchSuggestion *> * _Nullable suggestions, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaURNs);
        XCTAssertNotNil(aggregations);
        XCTAssertNil(suggestions);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowsMatchingQuery
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForVendor:SRGVendorRSI matchingQuery:kTVShowSearchQuery mediaType:SRGMediaTypeNone withCompletionBlock:^(NSArray<NSString *> * _Nullable showURNs, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(showURNs);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForVendor:SRGVendorRSI matchingQuery:kTVShowSearchQuery mediaType:SRGMediaTypeVideo withCompletionBlock:^(NSArray<NSString *> * _Nullable showURNs, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(showURNs);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForVendor:SRGVendorRSI matchingQuery:kTVShowSearchQuery transmission:SRGTransmissionNone withCompletionBlock:^(NSArray<NSString *> * _Nullable showURNs, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(showURNs);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForVendor:SRGVendorRSI matchingQuery:kTVShowSearchQuery transmission:SRGTransmissionTV withCompletionBlock:^(NSArray<NSString *> * _Nullable showURNs, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(showURNs);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Deprecated service
- (void)testMostSearchedShows
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mostSearchedShowsForVendor:SRGVendorRSI matchingTransmission:SRGTransmissionNone withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNil(shows);
        XCTAssertNotNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mostSearchedShowsForVendor:SRGVendorRSI matchingTransmission:SRGTransmissionTV withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNil(shows);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mostSearchedShowsForVendor:SRGVendorRSI matchingTransmission:SRGTransmissionRadio withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNil(shows);
        XCTAssertNotNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideosWithTags
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosForVendor:SRGVendorRSI withTags:@[kTag1] excludedTags:nil fullLengthExcluded:YES completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosForVendor:SRGVendorRSI withTags:@[kTag1] excludedTags:@[kTag1] fullLengthExcluded:YES completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosForVendor:SRGVendorRSI withTags:@[kTag1, kTag2] excludedTags:nil fullLengthExcluded:YES completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];

    [[self.dataProvider videosForVendor:SRGVendorRSI withTags:@[kTag1] excludedTags:nil fullLengthExcluded:NO completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosForVendor:SRGVendorRSI withTags:@[] excludedTags:nil fullLengthExcluded:YES completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Not supported for RSI
- (void)testRecommendedMedias
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider recommendedMediasForURN:kVideoURN userId:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider recommendedMediasForURN:kVideoURN userId:kUserId withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testIncreaseSocialCount
{
    XCTSkip("Not supported anymore");
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kVideoURN standalone:YES withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGView URN:mainChapter.URN event:mainChapter.event withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTAssertNil(socialCountOverview);
            XCTAssertNotNil(error);
            [expectation1 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kVideoURN standalone:YES withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGLike URN:mainChapter.URN event:mainChapter.event withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTAssertNil(socialCountOverview);
            XCTAssertNotNil(error);
            [expectation2 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kVideoURN standalone:YES withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeFacebookShare URN:mainChapter.URN event:mainChapter.event withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTAssertNil(socialCountOverview);
            XCTAssertNotNil(error);
            [expectation3 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kVideoURN standalone:YES withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeTwitterShare URN:mainChapter.URN event:mainChapter.event withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTAssertNil(socialCountOverview);
            XCTAssertNotNil(error);
            [expectation4 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kVideoURN standalone:YES withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeGooglePlusShare URN:mainChapter.URN event:mainChapter.event withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTAssertNil(socialCountOverview);
            XCTAssertNotNil(error);
            [expectation5 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kVideoURN standalone:YES withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeWhatsAppShare URN:mainChapter.URN event:mainChapter.event withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTAssertNil(socialCountOverview);
            XCTAssertNotNil(error);
            [expectation6 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testIncreaseSearchResultsViewCountForShow
{
    XCTSkip("Not supported anymore");
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:kTVShowURN completionBlock:^(SRGShow * _Nullable show, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        
        [[self.dataProvider increaseSearchResultsViewCountForShow:show withCompletionBlock:^(SRGShowStatisticsOverview * _Nullable showStatisticsOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTAssertNil(showStatisticsOverview);
            XCTAssertNotNil(error);
            [expectation1 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:kRadioShowURN completionBlock:^(SRGShow * _Nullable show, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        
        [[self.dataProvider increaseSearchResultsViewCountForShow:show withCompletionBlock:^(SRGShowStatisticsOverview * _Nullable showStatisticsOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTAssertNil(showStatisticsOverview);
            XCTAssertNotNil(error);
            [expectation2 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testModules
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider modulesForVendor:SRGVendorRSI type:SRGModuleTypeEvent withCompletionBlock:^(NSArray<SRGModule *> * _Nullable modules, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(modules);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Cannot test -latestMediasForModuleWithType:uid:sectionUid:completionBlock: yet due to missing reliable data

- (void)testFullLength
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    // Full-length VOD
    [[self.dataProvider mediaCompositionForURN:@"urn:rsi:video:1391801" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"1391801");
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // VOD segment
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:@"urn:rsi:video:1011766" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"1391801");
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // VOD clip
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:@"urn:rsi:video:2695109" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"2695109");
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // Video livestream
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:@"urn:rsi:video:livestream_La1" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"livestream_La1");
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // AOD clip
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:@"urn:rsi:audio:2704094" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"2704094");
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // Audio livestream
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:@"urn:rsi:audio:livestream_ReteUno" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"livestream_ReteUno");
        [expectation6 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowsWithURNs
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowURN, kTVShowOtherURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kRadioShowURN, kRadioShowOtherURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowURN, kRadioShowURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowURN, kRadioShowURN, kInvalidShowURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowURN, kRadioShowURN, kInvalidShowOtherURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoImage
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kVideoURN completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [self.dataProvider URLForImage:media.image withWidth:SRGImageWidth320];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        // 16:9 ratio expected
        XCTAssertEqual(image.size.width, 320.);
        XCTAssertEqual(image.size.height, 180.);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioImage
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kAudioURN completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [self.dataProvider URLForImage:media.image withWidth:SRGImageWidth320];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        // 16:9 ratio expected
        XCTAssertEqual(image.size.width, 320.);
        XCTAssertEqual(image.size.height, 180.);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowWithTopics
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:kTVShowURN completionBlock:^(SRGShow * _Nullable show, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNotNil(show.topics);
        XCTAssertTrue(show.topics.count > 0);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
