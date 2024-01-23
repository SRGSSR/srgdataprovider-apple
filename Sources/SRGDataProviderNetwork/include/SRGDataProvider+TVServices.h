//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of TV-oriented services supported by the data provider. Media list requests collect content for all channels
 *  and do not make any distinction between them.
 */
@interface SRGDataProvider (TVServices)

/**
 *  @name Channels and livestreams
 */

/**
 *  List of TV channels.
 */
- (SRGRequest *)tvChannelsForVendor:(SRGVendor)vendor
                withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  Specific TV channel. Use this request to obtain complete channel information, including current and next programs.
 */
- (SRGRequest *)tvChannelForVendor:(SRGVendor)vendor
                           withUid:(NSString *)channelUid
                   completionBlock:(SRGChannelCompletionBlock)completionBlock;

/**
 *  Latest programs for a specific TV channel, including current and next programs. An optional date range (possibly
 *  half-open) can be specified to only return programs entirely contained in a given interval. If no end date is
 *  provided, only programs up to the current date are returned.
 *
 *  @param livestreamUid An optional media unique identifier (usually regional, but might be the main one). If provided,
 *                       the program of the specified livestream is used, otherwise the one of the main channel.
 *
 *  @discussion Though the completion block does not return an array directly, this request supports pagination (for programs
 *              returned in the program composition object).
 */
- (SRGFirstPageRequest *)tvLatestProgramsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
                                     livestreamUid:(nullable NSString *)livestreamUid
                                          fromDate:(nullable NSDate *)fromDate
                                            toDate:(nullable NSDate *)toDate
                               withCompletionBlock:(SRGPaginatedProgramCompositionCompletionBlock)completionBlock;

/**
 *  Programs for TV channels on a specific day.
 *
 *  @param provider   The provider for which programs are requested. Non-standard providers might not be supported.
 *  @param channelUid The unique identifier of the channel to return programs for. If `nil` all channels available
 *                    for the specified provider are returned.
 *  @param day        The day. If `nil` today is used.
 *  @param minimal    If set to `YES` only minimal program information is returned (fast and lightweight).
 */
- (SRGRequest *)tvProgramsForVendor:(SRGVendor)vendor
                           provider:(SRGProgramProvider)provider
                         channelUid:(nullable NSString *)channelUid
                                day:(nullable SRGDay *)day
                            minimal:(BOOL)minimal
                withCompletionBlock:(SRGProgramCompositionListCompletionBlock)completionBlock;

/**
 *  List of TV livestreams.
 */
- (SRGRequest *)tvLivestreamsForVendor:(SRGVendor)vendor
                   withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List of TV scheduled livestreams.
 *
 *  @param signLanguageOnly  Whether only livestreams with sign language must be returned.
 *  @param eventType                  Specify which event type must be returned.
 */
- (SRGFirstPageRequest *)tvScheduledLivestreamsForVendor:(SRGVendor)vendor
                                        signLanguageOnly:(BOOL)signLanguageOnly
                                               eventType:(SRGScheduledLivestreamEventType)eventType
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Media and episode retrieval
 */

/**
 *  Medias which have been picked by editors.
 */
- (SRGFirstPageRequest *)tvEditorialMediasForVendor:(SRGVendor)vendor
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Medias picked for hero stage display.
 */
- (SRGRequest *)tvHeroStageMediasForVendor:(SRGVendor)vendor
                       withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  Latest medias.
 */
- (SRGFirstPageRequest *)tvLatestMediasForVendor:(SRGVendor)vendor
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Most popular medias.
 */
- (SRGFirstPageRequest *)tvMostPopularMediasForVendor:(SRGVendor)vendor
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Medias which will soon expire.
 */
- (SRGFirstPageRequest *)tvSoonExpiringMediasForVendor:(SRGVendor)vendor
                                   withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Trending medias (with all editorial recommendations).
 *
 *  @param limit The maximum number of results returned (if `nil`, 10 results at most will be returned).
 */
- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor
                                withLimit:(nullable NSNumber *)limit
                          completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  Trending medias. A limit can be set on editorial recommendations and results can be restricted to episodes only
 *  (eliminating clips, teasers, etc.).
 *
 *  @param limit          The maximum number of results returned (if `nil`, 10 results at most will be returned).
 *                        The maximum limit is 50.
 *  @param editorialLimit The maximum number of editorial recommendations returned (if `nil`, all are returned).
 *  @param episodesOnly   Whether only episodes must be returned.
 */
- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor
                                withLimit:(nullable NSNumber *)limit
                           editorialLimit:(nullable NSNumber *)editorialLimit
                             episodesOnly:(BOOL)episodesOnly
                          completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  Latest episodes.
 */
- (SRGFirstPageRequest *)tvLatestEpisodesForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest web first episodes.
 */
- (SRGFirstPageRequest *)tvLatestWebFirstEpisodesForVendor:(SRGVendor)vendor
                                       withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Episodes available for a given day.
 *
 *  @param day The day. If `nil` today is used.
 */
- (SRGFirstPageRequest *)tvEpisodesForVendor:(SRGVendor)vendor
                                         day:(nullable SRGDay *)day
                         withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Topics
 */

/**
 *  Topics.
 */
- (SRGRequest *)tvTopicsForVendor:(SRGVendor)vendor
              withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;

/**
 *  @name Shows
 */

/**
 *  Shows.
 */
- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                      withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query, returning the matching URN list.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get complete show objects,
 *              call the `-showsWithURNs:completionBlock:` request with the returned URN list.
 */
- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                            matchingQuery:(NSString *)query
                      withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock;

/**
 *  Most popular shows for a topic.
 */
- (SRGFirstPageRequest *)tvMostPopularShowsForVendor:(SRGVendor)vendor
                                            topicUid:(NSString *)topicUid
                                 withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
