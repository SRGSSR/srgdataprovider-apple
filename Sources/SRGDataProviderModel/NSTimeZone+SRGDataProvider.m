//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSTimeZone+SRGDataProvider.h"

@implementation NSTimeZone (PlaySRG)

+ (NSTimeZone *)srg_defaultTimeZone
{
    return [NSTimeZone timeZoneWithName:@"Europe/Zurich"];
}

@end
