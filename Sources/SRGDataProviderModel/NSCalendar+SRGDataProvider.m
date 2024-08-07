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
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.locale = NSLocale.currentLocale;
    calendar.timeZone = NSTimeZone.srg_defaultTimeZone;
    return calendar;
}

@end
