//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderModel;
@import XCTest;

@interface CalendarTestCase : XCTestCase

@end

@implementation CalendarTestCase

- (void)testLocale
{
    NSCalendar *calendar = NSCalendar.srg_defaultCalendar;
    XCTAssertEqualObjects(calendar.locale, NSLocale.currentLocale);
}

- (void)testTimezone
{
    NSCalendar *calendar = NSCalendar.srg_defaultCalendar;
    XCTAssertEqualObjects(calendar.timeZone.name, @"Europe/Zurich");
}

@end
