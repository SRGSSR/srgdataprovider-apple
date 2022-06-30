//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Focal point description (point of interest in an image).
 */
@interface SRGFocalPoint : SRGModel

/**
 *  The width percentage at which the point is located.
 */
@property (nonatomic, readonly) CGFloat widthPercentage;

/**
 *  The height percentage at which the point is located.
 */
@property (nonatomic, readonly) CGFloat heightPercentage;

@end

NS_ASSUME_NONNULL_END
