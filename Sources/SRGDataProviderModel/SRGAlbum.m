//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAlbum.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGAlbum ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic) SRGImage *smallCoverImage;
@property (nonatomic) SRGImage *largeCoverImage;

@end

@implementation SRGAlbum

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGAlbum.new, name) : @"name",
            @keypath(SRGAlbum.new, smallCoverImage) : @"coverUrlSmall",
            @keypath(SRGAlbum.new, largeCoverImage) : @"coverUrlLarge"
        };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)smallCoverImageJSONTransformer
{
    return SRGDefaultImageTransformer();
}

+ (NSValueTransformer *)largeCoverImageJSONTransformer
{
    return SRGDefaultImageTransformer();
}

@end
