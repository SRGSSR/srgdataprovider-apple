//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMediaURN.h"
#import "SRGMetadata.h"
#import "SRGSocialCount.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Mantle/Mantle.h>

@class SRGMedia;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Episode (broadcasted unit of a show)
 */
@interface SRGEpisode : MTLModel <SRGImageMetadata, SRGMetadata, MTLJSONSerializing>

/**
 *  The unique episode identifier
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The episode date
 */
@property (nonatomic, readonly, nullable) NSDate *date;

/**
 *  The full-length URN, if any
 */
@property (nonatomic, readonly, copy, nullable) SRGMediaURN *fullLengthURN;

/**
 *  The medias associated with this episode
 */
@property (nonatomic, readonly, nullable) NSArray<SRGMedia *> *medias;

/**
 *  Social network and popularity information
 */
@property (nonatomic, readonly, nullable) SRGSocialCount *socialCount;

@end

NS_ASSUME_NONNULL_END
