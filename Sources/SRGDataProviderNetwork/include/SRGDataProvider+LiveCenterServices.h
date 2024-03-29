//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of services offered by the SwissTXT Live Center.
 */
@interface SRGDataProvider (LiveCenterServices)

/**
 *  List of videos available from the Live Center (Sport Manager).
 *
 *  @param contentTypeFilter    The content type filter to apply.
 *  @param eventsWithResultOnly Whether only medias which are in the Live & Result Center (LRC) must be returned.
 */
- (SRGFirstPageRequest *)liveCenterVideosForVendor:(SRGVendor)vendor
                                 contentTypeFilter:(SRGContentTypeFilter)contentTypeFilter
                              eventsWithResultOnly:(BOOL)eventsWithResultOnly
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
