//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ImageServices.h"

@import SRGDataProviderRequests;

@implementation SRGDataProvider (ImageServices)

#pragma mark Public methods

- (NSURL *)URLForImage:(SRGImage *)image withWidth:(SRGImageWidth)width scalingService:(SRGImageScalingService)scalingService
{
    return [self requestURLForImage:image withWidth:width scalingService:scalingService];
}

- (NSURL *)URLForImage:(SRGImage *)image withSize:(SRGImageSize)size scalingService:(SRGImageScalingService)scalingService
{
    return [self requestURLForImage:image withSize:size scalingService:scalingService];
}

@end
