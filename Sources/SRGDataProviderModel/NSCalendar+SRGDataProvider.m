//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSCalendar+SRGDataProvider.h"

#import "NSTimeZone+SRGDataProvider.h"

@implementation NSCalendar (PlaySRG)

+ (NSCalendar *)srg_defaultCalendar
{
    static dispatch_once_t s_onceToken;
    static NSCalendar *s_calendar;
    dispatch_once(&s_onceToken, ^{
        s_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        s_calendar.timeZone = NSTimeZone.srg_defaultTimeZone;
    });
    return s_calendar.copy;
}

@end
