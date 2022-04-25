//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ImageURLs.h"

#import "SRGImage+Private.h"

@implementation SRGDataProvider (ImageURLs)

#pragma mark Public methods

- (NSURL *)requestURLForImage:(SRGImage *)image withWidth:(SRGImageWidth)width scaling:(SRGImageScaling)scaling
{
    return [self requestURLForImageURL:image.URL withWidth:width scaling:scaling];
}

- (NSURL *)requestURLForImage:(SRGImage *)image withSize:(SRGImageSize)size scaling:(SRGImageScaling)scaling
{
    return [self requestURLForImageURL:image.URL withSize:size variant:image.variant scaling:scaling];
}

- (NSURL *)requestURLForImageURL:(NSURL *)imageURL withWidth:(SRGImageWidth)width scaling:(SRGImageScaling)scaling
{
    if (! imageURL) {
        return nil;
    }
    
    switch (scaling) {
        case SRGImageScalingAspectFitSixteenToNine: {
            return [self scaledImageURLForResourcePath:@"integrationlayer/2.0/image-scale-pillarbox" imageURL:imageURL width:width];
            break;
        }
        
        case SRGImageScalingAspectFitBlackSquare: {
            return [self scaledImageURLForResourcePath:@"integrationlayer/2.0/image-scale-one-to-one" imageURL:imageURL width:width];
            break;
        }
        
        case SRGImageScalingAspectFitTransparentSquare: {
            return [self scaledImageURLForResourcePath:@"integrationlayer/2.0/image-scale-one-to-one-transparent-background" imageURL:imageURL width:width];
            break;
        }
            
        case SRGImageScalingPreserveAspectRatio: {
            return [self scaledImageURL:imageURL width:width];
            break;
        }
            
        default: {
            return [self scaledImageURLForResourcePath:@"integrationlayer/2.0/image-scale-sixteen-to-nine" imageURL:imageURL width:width];
            break;
        }
    }
}

- (NSURL *)requestURLForImageURL:(NSURL *)imageURL withSize:(SRGImageSize)size variant:(SRGImageVariant)variant scaling:(SRGImageScaling)scaling
{
    return [self requestURLForImageURL:imageURL withWidth:SRGRecommendedImageWidth(size, variant) scaling:scaling];
}

#pragma mark Modern image scaling

- (NSURL *)imageServiceURLForImageURL:(NSURL *)imageURL width:(SRGImageWidth)width
{
    static NSDictionary<NSString *, NSString *> *s_formats;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_formats = @{
            @"png" : @"png",
            @"svg" : @"png"
        };
    });
    
    NSURL *URL = [self.serviceURL URLByAppendingPathComponent:@"images/"];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    
    NSString *format = s_formats[imageURL.pathExtension] ?: @"jpg";
    URLComponents.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"imageUrl" value:imageURL.absoluteString],
        [NSURLQueryItem queryItemWithName:@"format" value:format],
        [NSURLQueryItem queryItemWithName:@"width" value:@(width).stringValue]
    ];
    return URLComponents.URL;
}

#pragma mark Legacy image scaling

- (NSURL *)scaledImageURL:(NSURL *)imageURL width:(SRGImageWidth)width
{
    NSString *sizeComponent = [NSString stringWithFormat:@"scale/width/%@", @(width)];
    return [imageURL URLByAppendingPathComponent:sizeComponent];
}

- (NSURL *)scaledImageURLForResourcePath:(NSString *)resourcePath imageURL:(NSURL *)imageURL width:(SRGImageWidth)width
{
    NSString *sizeComponent = [NSString stringWithFormat:@"scale/width/%@", @(width)];
    return [[[self.serviceURL URLByAppendingPathComponent:resourcePath] URLByAppendingPathComponent:imageURL.absoluteString] URLByAppendingPathComponent:sizeComponent];
}

@end
