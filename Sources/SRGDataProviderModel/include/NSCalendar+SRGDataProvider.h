//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (SRGDataProvider)

/**
 *  The calendar which the SRG SSR is located in, with its associated timezone (Zurich). Should be used for calendrical
 *  calculations involving SRG SSR data.
 */
@property (class, readonly, copy) NSCalendar *srg_defaultCalendar;

@end

NS_ASSUME_NONNULL_END
