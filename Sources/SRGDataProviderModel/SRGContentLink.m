//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContentLink.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGContentLink ()

@property (nonatomic) SRGContentLinkType type;
@property (nonatomic, copy) NSString *target;

@end

@implementation SRGContentLink

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGContentLink.new, type) : @"targetType",
            @keypath(SRGContentLink.new, target) : @"target"
        };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)typeJSONTransformer
{
    return SRGContentLinkTypeJSONTransformer();
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGContentLink *otherContentLink = object;
    return (self.type == otherContentLink.type) && [self.target isEqualToString:otherContentLink.target];
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@,%@", @(self.type), self.target].hash;
}

@end
