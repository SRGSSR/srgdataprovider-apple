//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImage.h"
#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGTopicIdentifierMetadata.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Abstract base class for topic representation.
 */
@interface SRGBaseTopic : SRGModel <SRGImageMetadata, SRGMetadata, SRGTopicIdentifierMetadata>

/**
 *  The associated image.
 */
@property (nonatomic, readonly, nullable) SRGImage *image;

@end

NS_ASSUME_NONNULL_END
