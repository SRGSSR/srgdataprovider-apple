//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

@import CoreGraphics;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Sprite sheet properties.
 */
@interface SRGSpriteSheet : SRGModel

/**
 *  The URN of the content which the sprite sheet is associated with.
 */
@property (nonatomic, readonly, copy) NSString *URN;

/**
 *  The URL of the sprite sheet image.
 */
@property (nonatomic, readonly) NSURL *URL;

/**
 *  Number of rows in the sprite sheet.
 */
@property (nonatomic, readonly) NSInteger rows;

/**
 *  Number of columns in the sprite sheet.
 */
@property (nonatomic, readonly) NSInteger columns;

/**
 *  Width of a thumbnail in the sprite sheet.
 */
@property (nonatomic, readonly) CGFloat thumbnailWidth;

/**
 *  Height of a thumbnail in the sprite sheet.
 */
@property (nonatomic, readonly) CGFloat thumbnailHeight;

/**
 *  The time interval between two consecutive thumbnails, in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval interval;

@end

NS_ASSUME_NONNULL_END
