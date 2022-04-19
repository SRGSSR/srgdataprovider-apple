//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSpriteSheet.h"

@import libextobjc;

@interface SRGSpriteSheet ()

@property (nonatomic, copy) NSString *URN;
@property (nonatomic) NSURL *URL;
@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger columns;
@property (nonatomic) CGFloat thumbnailWidth;
@property (nonatomic) CGFloat thumbnailHeight;
@property (nonatomic) NSTimeInterval interval;

@end

@implementation SRGSpriteSheet

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGSpriteSheet.new, URN) : @"urn",
            @keypath(SRGSpriteSheet.new, URL) : @"url",
            @keypath(SRGSpriteSheet.new, rows) : @"rows",
            @keypath(SRGSpriteSheet.new, columns) : @"columns",
            @keypath(SRGSpriteSheet.new, thumbnailWidth) : @"thumbnailWidth",
            @keypath(SRGSpriteSheet.new, thumbnailHeight) : @"thumbnailHeight",
            @keypath(SRGSpriteSheet.new, interval) : @"interval"
        };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
