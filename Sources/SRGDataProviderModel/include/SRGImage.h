//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Opaque image. Use services from `SRGDataProvider+ImageServices.h` to scale to a desired size.
 */
@interface SRGImage : NSObject

/**
 *  Convenience constructor for an image variant at the specified URL.
 */
+ (nullable SRGImage *)imageWithURL:(nullable NSURL *)URL variant:(SRGImageVariant)variant;

/**
 *  Initializer for an image variant at the specified URL.
 */
- (nullable instancetype)initWithURL:(nullable NSURL *)URL variant:(SRGImageVariant)variant;

/**
 *  The image variant.
 */
@property (nonatomic, readonly) SRGImageVariant variant;

@end

NS_ASSUME_NONNULL_END
