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
 *  Return the URL for an image having a given width.
 */
- (nullable NSURL *)URLForImage:(nullable SRGImage *)image withWidth:(SRGImageWidth)width;

/**
 *  Return the URL for an image having a given semantic size.
 */
- (nullable NSURL *)URLForImage:(nullable SRGImage *)image withSize:(SRGImageSize)size;

@end

NS_ASSUME_NONNULL_END
