//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for model objects having associated image metadata.
 */
@protocol SRGImageMetadata <NSObject>

/**
 *  The image title.
 */
@property (nonatomic, readonly, copy, nullable) NSString *imageTitle;

/**
 *  The copyright information associated with the image.
 */
@property (nonatomic, readonly, copy, nullable) NSString *imageCopyright;

@end

NS_ASSUME_NONNULL_END
