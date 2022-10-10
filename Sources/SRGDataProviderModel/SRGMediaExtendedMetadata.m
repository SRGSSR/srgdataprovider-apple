//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaExtendedMetadata.h"

#import "NSDate+PlaySRG.h"

SRGBlockingReason SRGBlockingReasonForMediaMetadata(id<SRGMediaExtendedMetadata> mediaMetadata, NSDate *date)
{
    if (mediaMetadata.originalBlockingReason != SRGBlockingReasonNone) {
        return mediaMetadata.originalBlockingReason;
    }
    
    if (mediaMetadata.endDate && [mediaMetadata.endDate compare:date] == NSOrderedAscending) {
        return SRGBlockingReasonEndDate;
    }
    else if (mediaMetadata.startDate && [date compare:mediaMetadata.startDate] == NSOrderedAscending) {
        return SRGBlockingReasonStartDate;
    }
    else {
        return SRGBlockingReasonNone;
    }
}

SRGTimeAvailability SRGTimeAvailabilityForMediaMetadata(id<SRGMediaExtendedMetadata> mediaMetadata, NSDate *date)
{
    if (mediaMetadata.originalBlockingReason == SRGBlockingReasonStartDate) {
        return SRGTimeAvailabilityNotYetAvailable;
    }
    
    if (mediaMetadata.originalBlockingReason == SRGBlockingReasonEndDate) {
        return SRGTimeAvailabilityNotAvailableAnymore;
    }
    
    return SRGTimeAvailabilityForStartAndEndDate(mediaMetadata.startDate, mediaMetadata.endDate, date);
}
