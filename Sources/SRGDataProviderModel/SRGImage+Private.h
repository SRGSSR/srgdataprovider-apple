//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRGImage (Private)

/**
 *  Initializer.
 */
- (instancetype)initWithURL:(NSURL *)URL variant:(SRGImageVariant)variant;

/**
 *  The URL of the unscaled image.
 */
@property (nonatomic, readonly) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
