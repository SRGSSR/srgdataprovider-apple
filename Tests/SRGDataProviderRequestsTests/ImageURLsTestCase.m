//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderRequests;
@import XCTest;

@interface NSURLComponents (ImageURLsTestCase)

@property (nonatomic, readonly) NSString *imageUrlQueryValue;
@property (nonatomic, readonly) NSString *widthQueryValue;
@property (nonatomic, readonly) NSString *formatQueryValue;

@end

@interface ImageURLsTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation ImageURLsTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
}

#pragma mark Helpers

- (NSURLComponents *)componentsFromUrlString:(NSString *)urlString width:(SRGImageWidth)width
{
    SRGImage *image = [[SRGImage alloc] initWithURL:[NSURL URLWithString:urlString] variant:SRGImageVariantDefault];
    
    NSURL *url = [self.dataProvider requestURLForImage:image withWidth:width];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    
    return components;
}

#pragma mark Tests

- (void)testVideoRSIImage
{
    NSString *urlString = @"http://www.rsi.ch/rsi-api/resize/image/EPISODE_IMAGE/9014815/";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"jpg");
}

- (void)testAudioRSIImage
{
    NSString *urlString = @"http://www.rsi.ch/rsi-api/resize/image/EPISODE_IMAGE/12471012/";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"jpg");
}

- (void)testVideoRTRImage
{
    NSString *urlString = @"https://ws.srf.ch/asset/image/audio/0cf00288-7a91-44bb-a4d5-951d3e72a464/EPISODE_IMAGE/1490033307.png";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"png");
}

- (void)testAudioRTRImage
{
    NSString *urlString = @"https://il.srgssr.ch/integrationlayer/2.0/image-scale-sixteen-to-nine/https://www.srf.ch/static/radio/modules/data/pictures/rtr/2017/03/21/453527.91989900.jpg";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"jpg");
}

- (void)testVideoRTSImage
{
    NSString *urlString = @"https://www.rts.ch/2017/03/20/20/17/8478254.image/16x9";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    // Business unit image service
    XCTAssertEqualObjects(components.host, @"www.rts.ch");
    XCTAssertEqual([components.string rangeOfString:urlString].location, 0);
    XCTAssertNotEqual([components.path rangeOfString:@"/scale/width/320"].location, NSNotFound);
}

- (void)testAudioRTSImage
{
    NSString *urlString = @"https://www.rts.ch/2021/04/30/14/43/7978319.image/16x9";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    // Business unit image service
    XCTAssertEqualObjects(components.host, @"www.rts.ch");
    XCTAssertEqual([components.string rangeOfString:urlString].location, 0);
    XCTAssertNotEqual([components.path rangeOfString:@"/scale/width/320"].location, NSNotFound);
}

- (void)testVideoSRFImage
{
    NSString *urlString = @"https://ws.srf.ch/asset/image/audio/7e18e733-622b-4bd5-9323-971239e49844/WEBVISUAL/1607950376.jpg";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"jpg");
}

- (void)testAudioSRFImage
{
    NSString *urlString = @"https://ws.srf.ch/asset/image/audio/aa35a39d-85cc-4dc4-bf54-8d744cd6304f/EPISODE_IMAGE/1683198311.png";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];

    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"png");
}

- (void)testVideoSWIImage
{
    NSString *urlString = @"https://www.swissinfo.ch/srgscalableimage/43018064/16x9";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"jpg");
}

- (void)testUploadedPACImage
{
    NSString *urlString = @"https://il.srgssr.ch/integrationlayer/2.0/image-scale-sixteen-to-nine/https://play-pac-public-production.s3.eu-central-1.amazonaws.com/images/19bca29e-90b2-45af-9067-28b0755d0305.jpeg";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"jpg");
}

- (void)testProgramGuideRawImage
{
    NSString *urlString = @"https://il.srgssr.ch/image-service/dynamic/7ec4fb9e.svg";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"png");
}

- (void)testProgramGuideImage
{
    NSString *urlString = @"https://il.srgssr.ch/images/https://il.srgssr.ch/image-service/dynamic/7ec4fb9e.svg/format/png";
    NSURLComponents *components = [self componentsFromUrlString:urlString width:SRGImageWidth320];
    
    XCTAssertEqualObjects(components.host, @"il.srgssr.ch");
    XCTAssertEqual([components.path rangeOfString:@"/images"].location, 0);
    XCTAssertEqualObjects(components.imageUrlQueryValue, urlString);
    XCTAssertEqualObjects(components.widthQueryValue, @"320");
    XCTAssertEqualObjects(components.formatQueryValue, @"png");
}

@end

@implementation NSURLComponents (ImageURLsTestCase)

- (NSString *)imageUrlQueryValue
{
    return [self.queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"imageUrl"]].firstObject.value;
}

- (NSString *)widthQueryValue
{
    return [self.queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"width"]].firstObject.value;
}

- (NSString *)formatQueryValue
{
    return [self.queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"format"]].firstObject.value;
}

@end
