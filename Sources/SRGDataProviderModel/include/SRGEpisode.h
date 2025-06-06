//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImage.h"
#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGSocialCount.h"

// Forward declarations.
@class SRGMedia;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Episode (broadcasted unit of a show).
 */
@interface SRGEpisode : SRGModel <SRGImageMetadata, SRGMetadata>

/**
 *  The unique episode identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The episode date.
 */
@property (nonatomic, readonly, nullable) NSDate *date;

/**
 *  The associated image.
 */
@property (nonatomic, readonly) SRGImage *image;

/**
 *  The full-length URN, if any.
 */
@property (nonatomic, readonly, copy, nullable) NSString *fullLengthURN;

/**
 *  The medias associated with this episode.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGMedia *> *medias;

/**
 *  Social network and popularity information.
 */
@property (nonatomic, readonly, nullable) SRGSocialCount *socialCount;

/**
 * The number of the season containing the episode
 */
@property (nonatomic, readonly, nullable) NSNumber *seasonNumber;

/**
 * The number of the episode in the season
 */
@property (nonatomic, readonly, nullable) NSNumber *episodeNumber;

@end

NS_ASSUME_NONNULL_END
