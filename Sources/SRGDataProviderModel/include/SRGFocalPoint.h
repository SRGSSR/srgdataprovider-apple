//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

@import CoreGraphics;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Focal point description (point of interest in an image).
 */
@interface SRGFocalPoint : SRGModel

/**
 *  The relative width (value between 0 and 1) at which the point is located, 0 corresponding to the leading edge,
 *  1 to the trailing edge.
 */
@property (nonatomic, readonly) CGFloat relativeWidth;

/**
 *  The relative height (value between 0 and 1) at which the point is located, 0 corresponding to the bottom edge,
 *  1 to the top edge.
 */
@property (nonatomic, readonly) CGFloat relativeHeight;

@end

NS_ASSUME_NONNULL_END
