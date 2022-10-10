//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSDate+PlaySRG.h"

SRGTimeAvailability SRGTimeAvailabilityForStartAndEndDate(NSDate *startDate, NSDate *endDate, NSDate *date)
{
    if (endDate && [endDate compare:date] == NSOrderedAscending) {
        return SRGTimeAvailabilityNotAvailableAnymore;
    }
    else if (startDate && [date compare:startDate] == NSOrderedAscending) {
        return SRGTimeAvailabilityNotYetAvailable;
    }
    else {
        return SRGTimeAvailabilityAvailable;
    }
}
