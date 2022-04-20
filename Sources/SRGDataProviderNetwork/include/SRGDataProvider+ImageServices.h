//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

@interface SRGDataProvider (ImageServices)

/**
 *  Return the URL for an image having a given width and scaled by applying the specified behavior.
 */
- (nullable NSURL *)URLForImage:(nullable SRGImage *)image withWidth:(SRGImageWidth)width scaling:(SRGImageScaling)scaling;

/**
 *  Return the URL for an image having a given semantic size and scaled by applying the specified behavior.
 */
- (nullable NSURL *)URLForImage:(nullable SRGImage *)image withSize:(SRGImageSize)size scaling:(SRGImageScaling)scaling;

/**
 *  Return the request URL created from an image URL for a given width and scaled by applying the specified behavior.
 */
- (nullable NSURL *)URLForImageURL:(nullable NSURL *)imageURL withWidth:(SRGImageWidth)width scaling:(SRGImageScaling)scaling;

/**
 *  Return the request URL for an image URL for a given semantic size / variant and scaled by applying the specified behavior.
 */
- (nullable NSURL *)URLForImageURL:(nullable NSURL *)imageURL withSize:(SRGImageSize)size variant:(SRGImageVariant)variant scaling:(SRGImageScaling)scaling;

@end

NS_ASSUME_NONNULL_END
