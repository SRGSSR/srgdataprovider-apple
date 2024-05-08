//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes how content should be presented.
 */
@interface SRGContentLink : SRGModel

/**
 *  The type of the target.
 */
@property (nonatomic, readonly) SRGContentLinkType type;

/**
 *  The target, if any, related to the type.
 */
@property (nonatomic, readonly, nullable) NSString *target;


@end

NS_ASSUME_NONNULL_END
