//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContentPresentation.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGContentPresentation ()

@property (nonatomic) SRGContentPresentationType type;
@property (nonatomic) SRGFocalPoint *imageFocalPoint;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *label;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) BOOL hasDetailPage;
@property (nonatomic, getter=isRandomized) BOOL randomized;

@end

@implementation SRGContentPresentation

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGContentPresentation.new, type) : @"name",
            @keypath(SRGContentPresentation.new, imageFocalPoint) : @"properties.imageFocalPoint",
            @keypath(SRGContentPresentation.new, title) : @"properties.title",
            @keypath(SRGContentPresentation.new, summary) : @"properties.description",
            @keypath(SRGContentPresentation.new, label) : @"properties.label",
            @keypath(SRGContentPresentation.new, imageURL) : @"properties.imageUrl",
            @keypath(SRGContentPresentation.new, hasDetailPage) : @"properties.hasDetailPage",
            @keypath(SRGContentPresentation.new, randomized) : @"properties.pickRandomElement"
        };
    });
    return s_mapping;
}

#pragma mark Getters and setters

- (SRGImage *)image
{
    return [SRGImage imageWithURL:self.imageURL variant:SRGImageVariantDefault];
}

#pragma mark Transformers

+ (NSValueTransformer *)imageFocalPointJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGFocalPoint.class];
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return SRGContentPresentationTypeJSONTransformer();
}

@end
