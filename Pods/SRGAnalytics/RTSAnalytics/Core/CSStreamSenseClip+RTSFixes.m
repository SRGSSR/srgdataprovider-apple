//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import <ComScore-iOS/CSStreamSenseClip.h>
#import <JRSwizzle/JRSwizzle.h>

// See CSStreamSense+SRGFixes.m
@interface CSStreamSenseClip (SRGFixes)

- (NSMutableDictionary *)swizzled_createLabels:(CSStreamSenseEventType)eventType initialLabels:(NSDictionary *)initialLabels;

@end

@implementation CSStreamSenseClip (SRGFixes)

+ (void)load
{
    [self jr_swizzleMethod:@selector(createLabels:initialLabels:) withMethod:@selector(swizzled_createLabels:initialLabels:) error:NULL];
}

- (NSMutableDictionary *)swizzled_createLabels:(CSStreamSenseEventType)eventType initialLabels:(NSDictionary *)initialLabels
{
    if ([[NSThread currentThread] isMainThread]) {
        return [self swizzled_createLabels:eventType initialLabels:initialLabels];
    }
    else {
        __block NSMutableDictionary *labels = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            labels = [self swizzled_createLabels:eventType initialLabels:initialLabels];
        });
        return labels;
    }
}

@end
