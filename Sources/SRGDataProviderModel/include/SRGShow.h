//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImage.h"
#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGShowIdentifierMetadata.h"
#import "SRGTopic.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Show information.
 */
@interface SRGShow : SRGModel <SRGImageMetadata, SRGMetadata, SRGShowIdentifierMetadata>

/**
 *  The URL of the show homepage.
 */
@property (nonatomic, readonly, nullable) NSURL *homepageURL;

/**
 *  The URL for podcast subscriptions.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastSubscriptionURL;

/**
 *  The high-definition podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastStandardDefinitionURL;

/**
 *  The standard definition podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastHighDefinitionURL;

/**
 *  The Deezer podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastDeezerURL;

/**
 *  The Spotify podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastSpotifyURL;

/**
 *  The unique identifier of the channel to which the show belongs.
 */
@property (nonatomic, readonly, copy, nullable) NSString *primaryChannelUid;

/**
 *  The associated image.
 */
@property (nonatomic, readonly) SRGImage *image;

/**
 *  The associated banner image.
 */
@property (nonatomic, readonly, nullable) SRGImage *bannerImage;

/**
 *  The associated poster image.
 */
@property (nonatomic, readonly, nullable) SRGImage *posterImage;

/**
 *  The associated podcast image.
 */
@property (nonatomic, readonly, nullable) SRGImage *podcastImage;

/**
 *  The number of episodes available for the show.
 */
@property (nonatomic, readonly, nullable) NSNumber *numberOfEpisodes;

/**
 *  The related topics.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGTopic *> *topics;

/**
 *  Whether to use posterImage as a fallback URL
 */
@property (nonatomic, readonly) BOOL shouldFallbackToPosterImage;

/**
 *  Whether to use podcastImage as a fallback URL
 */
@property (nonatomic, readonly) BOOL shouldFallbackToPodcastImage;


@end

NS_ASSUME_NONNULL_END
