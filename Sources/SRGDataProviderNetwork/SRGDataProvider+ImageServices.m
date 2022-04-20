//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ImageServices.h"

@import SRGDataProviderRequests;

@implementation SRGDataProvider (ImageServices)

#pragma mark Public methods

- (NSURL *)URLForImage:(SRGImage *)image withWidth:(SRGImageWidth)width scaling:(SRGImageScaling)scaling
{
    return [self requestURLForImage:image withWidth:width scaling:scaling];
}

- (NSURL *)URLForImage:(SRGImage *)image withSize:(SRGImageSize)size scaling:(SRGImageScaling)scaling
{
    return [self requestURLForImage:image withSize:size scaling:scaling];
}

- (NSURL *)URLForImageURL:(NSURL *)imageURL withWidth:(SRGImageWidth)width scaling:(SRGImageScaling)scaling
{
    return [self requestURLForImageURL:imageURL withWidth:width scaling:scaling];
}

- (NSURL *)URLForImageURL:(NSURL *)imageURL withSize:(SRGImageSize)size variant:(SRGImageVariant)variant scaling:(SRGImageScaling)scaling
{
    return [self requestURLForImageURL:imageURL withSize:size variant:variant scaling:scaling];
}

@end
