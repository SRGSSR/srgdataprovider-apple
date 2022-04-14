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
 *  For a given URL, return the full URL for the specified width.
 *
 *  @param width The desired image width.
 *
 *  @discussion The device scale is NOT automatically taken into account. Be sure that the required size in pixels
 *              matches the scale of your device.
 */
- (NSURL *)srg_URLForWidth:(SRGImageWidth)width;

@end

NS_ASSUME_NONNULL_END
