//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes how content should be presented.
 */
@interface SRGContentLink : SRGModel

/**
 *  The type of the target.
 */
@property (nonatomic, readonly) NSString *targetType;

/**
 *  The uid of the target.
 */
@property (nonatomic, readonly, nullable) NSString *targetUid;


@end

NS_ASSUME_NONNULL_END
