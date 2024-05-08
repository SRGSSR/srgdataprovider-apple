//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContentLink.h"

@import libextobjc;

@interface SRGContentLink ()

@property (nonatomic, copy) NSString *targetType;
@property (nonatomic, copy) NSString *targetUid;

@end

@implementation SRGContentLink

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGContentLink.new, targetType) : @"targetType",
            @keypath(SRGContentLink.new, targetUid) : @"target"
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
    
    SRGContentLink *otherContentLink = object;
    return [self.targetType isEqualToString:otherContentLink.targetType] && [self.targetUid isEqualToString:otherContentLink.targetUid];
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@,%@", self.targetType, self.targetUid].hash;
}
@end
