//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ImageURLs.h"

#import "SRGImage+Private.h"

@implementation SRGDataProvider (ImageURLs)

#pragma mark Public methods

- (NSURL *)requestURLForImage:(SRGImage *)image withWidth:(SRGImageWidth)width
{
    return [self requestURLForImageURL:image.URL withWidth:width];
}

- (NSURL *)requestURLForImage:(SRGImage *)image withSize:(SRGImageSize)size
{
    return [self requestURLForImageURL:image.URL withSize:size variant:image.variant];
}

- (NSURL *)requestURLForImageURL:(NSURL *)imageURL withWidth:(SRGImageWidth)width
{
    if (! imageURL) {
        return nil;
    }
    
    if (imageURL.fileURL) {
        return imageURL;
    }
    
    // See https://github.com/SRGSSR/srgdataprovider-apple/issues/47
    if ([imageURL.host containsString:@"rts.ch"] && [imageURL.path containsString:@".image"]) {
        return [self businessUnitScalingServiceURLForImageURL:imageURL width:width];
    }
    else {
        return [self playsrgScalingServiceURLForImageURL:imageURL width:width];
    }
}

- (NSURL *)requestURLForImageURL:(NSURL *)imageURL withSize:(SRGImageSize)size variant:(SRGImageVariant)variant
{
    return [self requestURLForImageURL:imageURL withWidth:SRGRecommendedImageWidth(size, variant)];
}

#pragma mark PlaySRG image scaling service

- (NSURL *)playsrgScalingServiceURLForImageURL:(NSURL *)imageURL width:(SRGImageWidth)width
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
    
    NSString *format = s_formats[imageURL.pathExtension] ?: s_formats[imageURL.pathComponents.lastObject] ?: @"jpg";
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
