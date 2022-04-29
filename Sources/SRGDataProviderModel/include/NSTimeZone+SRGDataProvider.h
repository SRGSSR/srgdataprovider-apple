//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSTimeZone (SRGDataProvider)

/**
 *  The time zone which the SRG SSR is located in (Zurich). Should be used for calendrical calculations involving SRG
 *  SSR data.
 */
@property (class, readonly, copy) NSTimeZone *srg_defaultTimeZone;

@end

NS_ASSUME_NONNULL_END
