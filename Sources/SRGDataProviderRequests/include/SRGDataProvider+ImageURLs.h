//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGDataProviderModel;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common image URL builders.
 */
@interface SRGDataProvider (ImageURLs)

/**
 *  Return the request URL for an image having a given width and scaled by applying the specified behavior.
 */
- (nullable NSURL *)requestURLForImage:(nullable SRGImage *)image withWidth:(SRGImageWidth)width scaling:(SRGImageScaling)scaling;

/**
 *  Return the request URL for an image having a given semantic size and scaled by applying the specified behavior.
 */
- (nullable NSURL *)requestURLForImage:(nullable SRGImage *)image withSize:(SRGImageSize)size scaling:(SRGImageScaling)scaling;

/**
 *  Return the request URL created from an image URL for a given width and scaled by applying the specified behavior.
 */
- (nullable NSURL *)requestURLForImageURL:(nullable NSURL *)imageURL withWidth:(SRGImageWidth)width scaling:(SRGImageScaling)scaling;

@end

NS_ASSUME_NONNULL_END
