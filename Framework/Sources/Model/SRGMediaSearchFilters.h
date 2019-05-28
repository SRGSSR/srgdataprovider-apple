//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Additional filters for media search queries.
 */
@interface SRGMediaSearchFilters : NSObject

/**
 *  How the query must be matched. Defaults to `SRGSearchMatchAll`, i.e. all words in the query must be matched.
 */
@property (nonatomic) SRGSearchMatch match;

/**
 *  Restrict results to a list of show URNs.
 */
@property (nonatomic, nullable) NSArray<NSString *> *showURNs;

/**
 *  Restrict results to a list of topic URNs.
 */
@property (nonatomic, nullable) NSArray<NSString *> *topicURNs;

/**
 *  Restrict results to a given media type. Default is `SRGMediaTypeNone`, i.e. no such filter is applied.
 */
@property (nonatomic) SRGMediaType mediaType;

/**
 *  If `@YES`, restrict results to medias with subtitles, if `@NO` to medias without. The default is `nil`, i.e.
 *  no such filter is applied.
 */
@property (nonatomic, nullable) NSNumber *subtitlesAvailable;

/**
 *  If `@YES`, restrict results to medias which can be downloaded, if `@NO` to medias which cannot be. The default is
 *  `nil`, i.e. no such filter is applied.
 */
@property (nonatomic, nullable) NSNumber *downloadAvailable;

/**
 *  If `@YES`, restrict results to medias playable abroad, if `@NO` to medias playable within Switzerland only. The
 *  default is `nil`, i.e. no such filter is applied.
 */
@property (nonatomic, nullable) NSNumber *playableAbroad;

/**
 *  Restrict results to a given quality. Default is `SRGQualityNone`, i.e. no such filter is applied.
 *
 *  @discussion `SRGQualityHD` and `SRGQualityHQ` equivalently filter out high-quality content.
 */
@property (nonatomic) SRGQuality quality;

/**
 *  The minimum / maximum media duration, in minutes.
 */
@property (nonatomic, nullable) NSNumber *minimumDurationInMinutes;
@property (nonatomic, nullable) NSNumber *maximumDurationInMinutes;

/**
 *  The dates after / before which medias must be considered.
 */
@property (nonatomic, nullable) NSDate *afterDate;
@property (nonatomic, nullable) NSDate *beforeDate;

/**
 *  The sort criterium to be applied. Default is `SRGSortCriteriumDefault`, i.e. the order is the default one
 *  returned by the service.
 */
@property (nonatomic) SRGSortCriterium sortCriterium;

/**
 *  The sort direction to be applied. Default is `SRGSortDirectionDescending`.
 */
@property (nonatomic) SRGSortDirection sortDirection;

@property (nonatomic, readonly) NSArray<NSURLQueryItem *> *queryItems;

@end

NS_ASSUME_NONNULL_END
