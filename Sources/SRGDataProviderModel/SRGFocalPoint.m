//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGFocalPoint.h"

@import libextobjc;

@interface SRGFocalPoint ()

@property (nonatomic) CGFloat widthPercentage;
@property (nonatomic) CGFloat heightPercentage;

@end

@implementation SRGFocalPoint

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGFocalPoint.new, widthPercentage) : @"percentageX",
            @keypath(SRGFocalPoint.new, heightPercentage) : @"percentageY"
        };
    });
    return s_mapping;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGFocalPoint *otherFocalPoint = object;
    return self.widthPercentage == otherFocalPoint.widthPercentage && self.heightPercentage == otherFocalPoint.heightPercentage;
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@,%@", @(self.widthPercentage), @(self.heightPercentage)].hash;
}

@end
