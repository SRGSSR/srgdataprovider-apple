//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderModel;
@import SRGDataProviderNetwork;
@import XCTest;

static NSString * const kVideoURN = @"urn:srf:video:24b1f659-052e-4847-a523-a6267bd9596e";

@interface ImageServicesTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation ImageServicesTestCase

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

- (void)testFixedSizeImage
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kVideoURN completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [self.dataProvider URLForImage:media.image withWidth:SRGImageWidth320];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        XCTAssertEqual(image.size.width, 320.);
        XCTAssertEqual(image.size.height, 180.);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testSmallSizeImage
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kVideoURN completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        CGSize expectedSize = SRGRecommendedImageCGSize(SRGImageSizeSmall, SRGImageVariantDefault);
        NSURL *imageURL = [self.dataProvider URLForImage:media.image withSize:SRGImageSizeSmall];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        XCTAssertEqual(image.size.width, expectedSize.width);
        XCTAssertEqual(image.size.height, expectedSize.height);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediumSizeImage
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kVideoURN completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        CGSize expectedSize = SRGRecommendedImageCGSize(SRGImageSizeMedium, SRGImageVariantDefault);
        NSURL *imageURL = [self.dataProvider URLForImage:media.image withSize:SRGImageSizeMedium];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        XCTAssertEqual(image.size.width, expectedSize.width);
        XCTAssertEqual(image.size.height, expectedSize.height);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLargeSizeImage
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kVideoURN completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        CGSize expectedSize = SRGRecommendedImageCGSize(SRGImageSizeLarge, SRGImageVariantDefault);
        NSURL *imageURL = [self.dataProvider URLForImage:media.image withSize:SRGImageSizeLarge];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        XCTAssertEqual(image.size.width, expectedSize.width);
        XCTAssertEqual(image.size.height, expectedSize.height);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
