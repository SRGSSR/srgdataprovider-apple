//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"
#import "SRGScheduledLivestreamMetadata.h"
#import "SRGSegment.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Chapter (unit of media playback characterized by a URL to be played).
 */
@interface SRGChapter : SRGSegment <SRGScheduledLivestreamMetadata>

/**
 *  The list of available resources.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGResource *> *resources;

/**
 *  The list of segments associated with the chapter.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSegment *> *segments;

@end

@interface SRGChapter (Resources)

/**
 *  The recommended streaming method to use. Might return `SRGStreamingMethodNone` if no good match is found.
 */
@property (nonatomic, readonly) SRGStreamingMethod recommendedStreamingMethod;

/**
 *  Return resources matching the specified streaming method, from the highest to the lowest available qualities.
 */
- (nullable NSArray<SRGResource *> *)resourcesForStreamingMethod:(SRGStreamingMethod)streamingMethod;

@end

NS_ASSUME_NONNULL_END
