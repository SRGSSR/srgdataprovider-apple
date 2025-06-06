//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderNetwork;
@import XCTest;

static BOOL DataProviderURLContainsQueryParameter(NSURL *URL, NSString *name, NSString *value)
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSURLQueryItem * _Nullable queryItem, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [queryItem.name isEqualToString:name];
    }];
    NSURLQueryItem *queryItem = [components.queryItems filteredArrayUsingPredicate:predicate].firstObject;
    return [queryItem.value isEqualToString:value];
}

@interface DataProviderNetworkTestCase : XCTestCase

@end

@implementation DataProviderNetworkTestCase

#pragma mark Helpers

- (XCTestExpectation *)expectationForElapsedTimeInterval:(NSTimeInterval)timeInterval withHandler:(void (^)(void))handler
{
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Wait for %@ seconds", @(timeInterval)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
        handler ? handler() : nil;
    });
    return expectation;
}

#pragma mark Tests

- (void)testRequestCancellationOnProviderDeallocation
{
    [self expectationForElapsedTimeInterval:3. withHandler:nil];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    __weak SRGDataProvider *dataProvider;
    @autoreleasepool {
        dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
        SRGFirstPageRequest *request = [dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
            XCTFail(@"Must not be called since the request must be cancelled if the associated provider was deallocated");
        }];
        [request resume];
    }
#pragma clang diagnostic pop
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testHTTPResponse
{
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request finished"];
    
    SRGFirstPageRequest *request1 = [dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(HTTPResponse.statusCode, 200);
        
        [expectation1 fulfill];
    }];
    [request1 resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request finished"];
    
    SRGRequest *request2 = [dataProvider mediaCompositionForURN:@"bad_URN" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(HTTPResponse.statusCode, 400);
        
        [expectation2 fulfill];
    }];
    [request2 resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testVectorResponse
{
   SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
   
   XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
   
   SRGFirstPageRequest *request = [dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
#if TARGET_OS_TV
       XCTAssertTrue([HTTPResponse.URL.query.lowercaseString containsString:@"vector=tvplay"]);
#else
       XCTAssertTrue([HTTPResponse.URL.query.lowercaseString containsString:@"vector=appplay"]);
#endif
       XCTAssertEqual(HTTPResponse.statusCode, 200);
       
       [expectation fulfill];
   }];
   [request resume];
   
   [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testDefaultMainThreadCompletion
{
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 finished"];
    
    [[dataProvider tvChannelsForVendor:SRGVendorRTS withCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 finished"];
    
    [[dataProvider tvLatestMediasForVendor:SRGVendorRTS withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        [expectation2 fulfill];
    }] resume];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request 3 finished"];
    
    [[dataProvider latestEpisodesForShowWithURN:@"urn:rts:show:tv:6454706" maximumPublicationDay:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testBackgroundThreadCompletion
{
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 finished"];
    
    [[[dataProvider tvChannelsForVendor:SRGVendorRTS withCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertFalse(NSThread.isMainThread);
        [expectation1 fulfill];
    }] requestWithOptions:SRGRequestOptionBackgroundCompletionEnabled] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 finished"];
    
    [[[dataProvider tvLatestMediasForVendor:SRGVendorRTS withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertFalse(NSThread.isMainThread);
        [expectation2 fulfill];
    }] requestWithOptions:SRGRequestOptionBackgroundCompletionEnabled] resume];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request 3 finished"];
    
    [[[dataProvider latestEpisodesForShowWithURN:@"urn:rts:show:tv:6454706" maximumPublicationDay:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertFalse(NSThread.isMainThread);
        [expectation3 fulfill];
    }] requestWithOptions:SRGRequestOptionBackgroundCompletionEnabled] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testDefaultPageSize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [dataProvider tvLatestMediasForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 10);
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testCustomPageSize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [[dataProvider tvLatestMediasForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 7);
        XCTAssertNil(error);
        
        [expectation fulfill];
    }] requestWithPageSize:7];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testPageSizeOverrideTwice
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [[[dataProvider tvLatestMediasForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 3);
        XCTAssertNil(error);
        
        [expectation fulfill];
    }] requestWithPageSize:18] requestWithPageSize:3];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testSupportedUnlimitedPageSize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [[dataProvider tvShowsForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] requestWithPageSize:SRGDataProviderUnlimitedPageSize];
    
    XCTAssertEqual(request.page.number, 0);
    XCTAssertEqual(request.page.size, SRGDataProviderUnlimitedPageSize);
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testUnsupportedUnlimitedPageSize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [[dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] requestWithPageSize:SRGDataProviderUnlimitedPageSize];
    
    XCTAssertEqual(request.page.number, 0);
    XCTAssertEqual(request.page.size, SRGDataProviderUnlimitedPageSize);
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testPagination
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    // Use a small page size to be sure we get two full pages of results (and more to come)
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    __block SRGFirstPageRequest *request = nil;
    request = [[dataProvider tvLatestMediasForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        XCTAssertNotNil(nextPage);
        
        if (page.number == 0 && nextPage) {
            [[request requestWithPage:nextPage] resume];
        }
        else if (page.number == 1) {
            [expectation fulfill];
            request = nil;
        }
        else {
            XCTFail(@"Only first two pages are expected");
        }
    }] requestWithPageSize:2];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testEpisodeCompositionPagination
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    __block SRGFirstPageRequest *request = nil;
    request = [[dataProvider latestEpisodesForShowWithURN:@"urn:rts:show:tv:548307" maximumPublicationDay:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(episodeComposition.episodes.count, 4);
        
        if (page.number == 0) {
            [[request requestWithPage:nextPage] resume];
        }
        else if (page.number == 1) {
            [expectation fulfill];
            request = nil;
        }
        else {
            XCTFail(@"Only two pages exist");
        }
    }] requestWithPageSize:4];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testURNListDefaultPageSize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSArray<NSString *> *URNs = @[
        @"urn:rts:video:10002568", @"urn:rts:video:10002444", @"urn:rts:video:9986412", @"urn:rts:video:9986195",
        @"urn:rts:video:9948638", @"urn:rts:video:9951674", @"urn:rts:video:9951724", @"urn:rts:video:9950129",
        @"urn:rts:video:9949270", @"urn:rts:video:9948800", @"urn:rts:video:9948698", @"urn:rts:video:9946068",
        @"urn:rts:video:9946141"
    ];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [dataProvider mediasWithURNs:URNs completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 10);
        XCTAssertNil(error);
        XCTAssertNotNil(nextPage);
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testURNListPageSize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSArray<NSString *> *URNs = @[
        @"urn:rts:video:10002568", @"urn:rts:video:10002444", @"urn:rts:video:9986412", @"urn:rts:video:9986195",
        @"urn:rts:video:9948638", @"urn:rts:video:9951674", @"urn:rts:video:9951724", @"urn:rts:video:9950129",
        @"urn:rts:video:9949270", @"urn:rts:video:9948800", @"urn:rts:video:9948698", @"urn:rts:video:9946068",
        @"urn:rts:video:9946141"
    ];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [[dataProvider mediasWithURNs:URNs completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 5);
        XCTAssertNil(error);
        XCTAssertNotNil(nextPage);
        [expectation fulfill];
    }] requestWithPageSize:5];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testEmptyURNList
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [dataProvider mediasWithURNs:@[] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        XCTAssertNil(nextPage);
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testURNListPagination
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSArray<NSString *> *URNs = @[
        @"urn:rts:video:10002568", @"urn:rts:video:10002444", @"urn:rts:video:9986412", @"urn:rts:video:9986195",
        @"urn:rts:video:9948638", @"urn:rts:video:9951674", @"urn:rts:video:9951724", @"urn:rts:video:9950129",
        @"urn:rts:video:9949270", @"urn:rts:video:9948800", @"urn:rts:video:9948698", @"urn:rts:video:9946068",
        @"urn:rts:video:9946141"
    ];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    __block SRGFirstPageRequest *request = nil;
    request = [dataProvider mediasWithURNs:URNs completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        if (page.number == 0) {
            XCTAssertEqual(medias.count, 10);
            [[request requestWithPage:nextPage] resume];
        }
        else if (page.number == 1) {
            XCTAssertEqual(medias.count, 3);
            [expectation fulfill];
            request = nil;
        }
        else {
            XCTFail(@"Only two pages exist");
        }
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testHugeURNList
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSMutableArray<NSString *> *URNs = @[
        @"urn:rts:video:10002568", @"urn:rts:video:10002444", @"urn:rts:video:9986412", @"urn:rts:video:9986195",
        @"urn:rts:video:9948638", @"urn:rts:video:9951674", @"urn:rts:video:9951724", @"urn:rts:video:9950129",
        @"urn:rts:video:9949270", @"urn:rts:video:9948800", @"urn:rts:video:9948698", @"urn:rts:video:9946068",
        @"urn:rts:video:9946141"
    ].mutableCopy;
    for (NSUInteger i = 0; i < 100000; ++i) {
        [URNs addObject:NSUUID.UUID.UUIDString];
    }
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGFirstPageRequest *request = [dataProvider mediasWithURNs:URNs completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 10);
        XCTAssertNil(error);
        XCTAssertNotNil(nextPage);
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testURNSmallerFirstPageOverride
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSArray<NSString *> *URNs = @[
        @"urn:rts:video:10002568", @"urn:rts:video:10002444", @"urn:rts:video:9986412", @"urn:rts:video:9986195",
        @"urn:rts:video:9948638", @"urn:rts:video:9951674", @"urn:rts:video:9951724", @"urn:rts:video:9950129",
        @"urn:rts:video:9949270", @"urn:rts:video:9948800", @"urn:rts:video:9948698", @"urn:rts:video:9946068",
        @"urn:rts:video:9946141"
    ];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGPageRequest *request = [[[dataProvider mediasWithURNs:URNs completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 4);
        [expectation fulfill];
    }] requestWithPageSize:4] requestWithPage:nil];
    [request resume];
    
    XCTAssertEqual(request.page.number, 0);
    XCTAssertEqual(request.page.size, 4);
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testURNLargerFirstPageOverride
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSArray<NSString *> *URNs = @[
        @"urn:rts:video:10002568", @"urn:rts:video:10002444", @"urn:rts:video:9986412", @"urn:rts:video:9986195",
        @"urn:rts:video:9948638", @"urn:rts:video:9951674", @"urn:rts:video:9951724", @"urn:rts:video:9950129",
        @"urn:rts:video:9949270", @"urn:rts:video:9948800", @"urn:rts:video:9948698", @"urn:rts:video:9946068",
        @"urn:rts:video:9946141"
    ];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    SRGPageRequest *request = [[[dataProvider mediasWithURNs:URNs completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 12);
        [expectation fulfill];
    }] requestWithPageSize:12] requestWithPage:nil];
    [request resume];
    
    XCTAssertEqual(request.page.number, 0);
    XCTAssertEqual(request.page.size, 12);
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testPaginationRequestGlobalSettingsConsistency
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    dataProvider.globalHeaders = @{ @"Test-Header" : @"Test-Value" };
    dataProvider.globalParameters = @{ @"forceLocation" : @"WW" };
    
    __block SRGFirstPageRequest *request = nil;
    request = [[dataProvider latestMediasForTopicWithURN:@"urn:swi:topic:tv:1" completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        if (page.number == 0) {
            SRGPageRequest *nextRequest = [request requestWithPage:nextPage];
            NSURLRequest *nextPageURLRequest = nextRequest.URLRequest;
            XCTAssertEqualObjects([nextPageURLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
            XCTAssertTrue(DataProviderURLContainsQueryParameter(nextPageURLRequest.URL, @"forceLocation", @"WW"));
            
            [nextRequest resume];
        }
        else if (page.number == 1) {
            NSURLRequest *nextPageURLRequest = [request requestWithPage:nextPage].URLRequest;
            XCTAssertEqualObjects([nextPageURLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
            XCTAssertTrue(DataProviderURLContainsQueryParameter(nextPageURLRequest.URL, @"forceLocation", @"WW"));
            
            [expectation fulfill];
            request = nil;
        }
        else {
            XCTFail(@"Only two pages exist");
        }
    }] requestWithPageSize:4];
    
    NSURLRequest *URLRequest = request.URLRequest;
    XCTAssertEqualObjects(URLRequest.URL.host, SRGIntegrationLayerProductionServiceURL().host);
    XCTAssertEqualObjects([URLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
    XCTAssertTrue(DataProviderURLContainsQueryParameter(URLRequest.URL, @"forceLocation", @"WW"));
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testEpisodeCompositionPaginationRequestGlobalSettingsConsistency
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    dataProvider.globalHeaders = @{ @"Test-Header" : @"Test-Value" };
    dataProvider.globalParameters = @{ @"forceLocation" : @"WW" };
    
    __block SRGFirstPageRequest *request = nil;
    request = [[dataProvider latestEpisodesForShowWithURN:@"urn:rts:show:tv:548307" maximumPublicationDay:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        if (page.number == 0) {
            SRGPageRequest *nextRequest = [request requestWithPage:nextPage];
            NSURLRequest *nextPageURLRequest = nextRequest.URLRequest;
            XCTAssertEqualObjects(nextPageURLRequest.URL.host, SRGIntegrationLayerProductionServiceURL().host);
            XCTAssertEqualObjects([nextPageURLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
            XCTAssertTrue(DataProviderURLContainsQueryParameter(nextPageURLRequest.URL, @"forceLocation", @"WW"));
            
            [nextRequest resume];
        }
        else if (page.number == 1) {
            NSURLRequest *nextPageURLRequest = [request requestWithPage:nextPage].URLRequest;
            XCTAssertEqualObjects(nextPageURLRequest.URL.host, SRGIntegrationLayerProductionServiceURL().host);
            XCTAssertEqualObjects([nextPageURLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
            XCTAssertTrue(DataProviderURLContainsQueryParameter(nextPageURLRequest.URL, @"forceLocation", @"WW"));
            
            [expectation fulfill];
            request = nil;
        }
        else {
            XCTFail(@"Only two pages exist");
        }
    }] requestWithPageSize:4];
    
    NSURLRequest *URLRequest = request.URLRequest;
    XCTAssertEqualObjects(URLRequest.URL.host, SRGIntegrationLayerProductionServiceURL().host);
    XCTAssertEqualObjects([URLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
    XCTAssertTrue(DataProviderURLContainsQueryParameter(URLRequest.URL, @"forceLocation", @"WW"));
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testURNPaginationRequestGlobalSettingsConsistency
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    dataProvider.globalHeaders = @{ @"Test-Header" : @"Test-Value" };
    dataProvider.globalParameters = @{ @"forceLocation" : @"WW" };
    
    NSArray<NSString *> *URNs = @[
        @"urn:rts:video:10002568", @"urn:rts:video:10002444", @"urn:rts:video:9986412", @"urn:rts:video:9986195",
        @"urn:rts:video:9948638", @"urn:rts:video:9951674", @"urn:rts:video:9951724", @"urn:rts:video:9950129",
        @"urn:rts:video:9949270", @"urn:rts:video:9948800", @"urn:rts:video:9948698", @"urn:rts:video:9946068",
        @"urn:rts:video:9946141"
    ];
    
    __block SRGFirstPageRequest *request = nil;
    request = [[dataProvider mediasWithURNs:URNs completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        if (page.number == 0) {
            SRGPageRequest *nextRequest = [request requestWithPage:nextPage];
            NSURLRequest *nextPageURLRequest = nextRequest.URLRequest;
            XCTAssertEqualObjects(nextPageURLRequest.URL.host, SRGIntegrationLayerProductionServiceURL().host);
            XCTAssertEqualObjects([nextPageURLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
            XCTAssertTrue(DataProviderURLContainsQueryParameter(nextPageURLRequest.URL, @"forceLocation", @"WW"));
            
            [nextRequest resume];
        }
        else if (page.number == 1) {
            NSURLRequest *nextPageURLRequest = [request requestWithPage:nextPage].URLRequest;
            XCTAssertEqualObjects(nextPageURLRequest.URL.host, SRGIntegrationLayerProductionServiceURL().host);
            XCTAssertEqualObjects([nextPageURLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
            XCTAssertTrue(DataProviderURLContainsQueryParameter(nextPageURLRequest.URL, @"forceLocation", @"WW"));
            
            [expectation fulfill];
            request = nil;
        }
        else {
            XCTFail(@"Only two pages exist");
        }
    }] requestWithPageSize:4];
    
    NSURLRequest *URLRequest = request.URLRequest;
    XCTAssertEqualObjects(URLRequest.URL.host, SRGIntegrationLayerProductionServiceURL().host);
    XCTAssertEqualObjects([URLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
    XCTAssertTrue(DataProviderURLContainsQueryParameter(URLRequest.URL, @"forceLocation", @"WW"));
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
