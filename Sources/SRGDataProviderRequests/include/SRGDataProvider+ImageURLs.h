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
 *  Return the request URL for an image having a given width.
 */
- (nullable NSURL *)requestURLForImage:(nullable SRGImage *)image withWidth:(SRGImageWidth)width;

/**
 *  Return the request URL for an image having a given semantic size.
 */
- (nullable NSURL *)requestURLForImage:(nullable SRGImage *)image withSize:(SRGImageSize)size;

@end

NS_ASSUME_NONNULL_END
