//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGTypes.h"

@import CoreGraphics;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Data provider extensions to `NSURL`.
 */
@interface NSURL (SRGDataProvider)

/**
 *  Augment the receiver URL for retrieval of an image with the specified width.
 *
 *  @discussion Does not take the device screen scale into account.
 */
- (NSURL *)srg_URLForWidth:(SRGImageWidth)width;

@end

NS_ASSUME_NONNULL_END
