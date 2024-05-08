//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContentLink.h"
#import "SRGFocalPoint.h"
#import "SRGImage.h"
#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes how content should be presented.
 */
@interface SRGContentPresentation : SRGModel

/**
 *  The presentation type.
 */
@property (nonatomic, readonly) SRGContentPresentationType type;

/**
 *  The image focal point, if any.
 */
@property (nonatomic, readonly, nullable) SRGFocalPoint *imageFocalPoint;

/**
 *  The title to be displayed alongside the content.
 */
@property (nonatomic, readonly, copy, nullable) NSString *title;

/**
 *  The description to be displayed alongside the content.
 */
@property (nonatomic, readonly, copy, nullable) NSString *summary;

/**
 *  Short label associated with the content.
 */
@property (nonatomic, readonly, copy, nullable) NSString *label;

/**
 *  Image associated with the content.
 */
@property (nonatomic, readonly, nullable) SRGImage *image;

/**
 *  `YES` iff a detail page should be made available for the content.
 */
@property (nonatomic, readonly) BOOL hasDetailPage;

/**
 * The content link, if any
 */
@property (nonatomic, readonly, nullable) SRGContentLink *contentLink;

/**
 *  `YES` if the content is randomized.
 */
@property (nonatomic, readonly, getter=isRandomized) BOOL randomized;

@end

NS_ASSUME_NONNULL_END
