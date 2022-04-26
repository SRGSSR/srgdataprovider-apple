//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImage.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Album information.
 */
@interface SRGAlbum : SRGModel

/**
 *  The album name.
 */
@property (nonatomic, readonly, copy) NSString *name;

/**
 *  The album small cover image.
 */
@property (nonatomic, readonly, nullable) SRGImage *smallCoverImage;

/**
 *  The album large cover image.
 */
@property (nonatomic, readonly, nullable) SRGImage *largeCoverImage;

@end

NS_ASSUME_NONNULL_END
