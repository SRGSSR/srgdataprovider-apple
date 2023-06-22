//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ImageURLs.h"

#import "SRGImage+Private.h"

@implementation SRGDataProvider (ImageURLs)

#pragma mark Public methods

- (NSURL *)requestURLForImage:(SRGImage *)image withWidth:(SRGImageWidth)width scalingService:(SRGImageScalingService)scalingService
{
    return [self requestURLForImageURL:image.URL withWidth:width scalingService:scalingService];
}

- (NSURL *)requestURLForImage:(SRGImage *)image withSize:(SRGImageSize)size scalingService:(SRGImageScalingService)scalingService
{
    return [self requestURLForImageURL:image.URL withSize:size variant:image.variant scalingService:scalingService];
}

- (NSURL *)requestURLForImageURL:(NSURL *)imageURL withWidth:(SRGImageWidth)width scalingService:(SRGImageScalingService)scalingService
{
    if (! imageURL) {
        return nil;
    }
    
    if (imageURL.fileURL) {
        return imageURL;
    }
    
    switch (scalingService) {
        case SRGImageScalingServiceCentralized: {
            return [self centralizedScalingServiceURLForImageURL:imageURL width:width];
            break;
        }
            
        default: {
            return [self businessUnitScalingServiceURLForImageURL:imageURL width:width];
            break;
        }
    }
}

- (NSURL *)requestURLForImageURL:(NSURL *)imageURL withSize:(SRGImageSize)size variant:(SRGImageVariant)variant scalingService:(SRGImageScalingService)scalingService
{
    return [self requestURLForImageURL:imageURL withWidth:SRGRecommendedImageWidth(size, variant) scalingService:scalingService];
}

#pragma mark Centralised image scaling service

- (NSURL *)centralizedScalingServiceURLForImageURL:(NSURL *)imageURL width:(SRGImageWidth)width
{
    static NSDictionary<NSString *, NSString *> *s_formats;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_formats = @{
            @"png" : @"png",
            @"svg" : @"png"
        };
    });
    
    NSURLComponents *rootServiceURLComponents = [[NSURLComponents alloc] init];
    rootServiceURLComponents.scheme = self.serviceURL.scheme;
    rootServiceURLComponents.host = self.serviceURL.host;
    
    NSURL *URL = [rootServiceURLComponents.URL URLByAppendingPathComponent:@"images/"];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];

    NSString *format = s_formats[imageURL.pathExtension] ?: @"jpg";
    URLComponents.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"imageUrl" value:imageURL.absoluteString],
        [NSURLQueryItem queryItemWithName:@"format" value:format],
        [NSURLQueryItem queryItemWithName:@"width" value:@(width).stringValue]
    ];
    return URLComponents.URL;
}

#pragma mark Business Unit image scaling service

- (NSURL *)businessUnitScalingServiceURLForImageURL:(NSURL *)imageURL width:(SRGImageWidth)width
{
    NSString *sizeComponent = [NSString stringWithFormat:@"scale/width/%@", @(width)];
    return [imageURL URLByAppendingPathComponent:sizeComponent];
}

@end
