//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGFocalPoint.h"

@import libextobjc;

@interface SRGFocalPoint ()

@property (nonatomic) CGFloat percentageX;
@property (nonatomic) CGFloat percentageY;

@end

@implementation SRGFocalPoint

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGFocalPoint.new, percentageX) : @"percentageX",
            @keypath(SRGFocalPoint.new, percentageY) : @"percentageY"
        };
    });
    return s_mapping;
}

#pragma mark Getters and setters

- (CGFloat)relativeWidth
{
    // In the IL metadata 0 corresponds to the leading edge
    return self.percentageX / 100.f;
}

- (CGFloat)relativeHeight
{
    // In the IL metadata 0 corresponds to the top edge, which is counter-intuitive in UIKit where the coordinate
    // system starts at the lower left. Fix.
    return 1.f - self.percentageY / 100.f;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGFocalPoint *otherFocalPoint = object;
    return self.percentageX == otherFocalPoint.percentageX && self.percentageY == otherFocalPoint.percentageY;
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@,%@", @(self.percentageX), @(self.percentageY)].hash;
}

@end
