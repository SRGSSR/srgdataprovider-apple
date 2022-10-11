//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Return the time availability associated with the start date and end date at the specified date.
 *
 *  @discussion Time availability is only intended for informative purposes.
 */
OBJC_EXPORT SRGTimeAvailability SRGTimeAvailabilityForStartDateAndEndDate(NSDate * _Nullable startDate, NSDate * _Nullable endDate, NSDate *date);

NS_ASSUME_NONNULL_END
