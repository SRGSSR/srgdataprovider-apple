//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGBaseTopic.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGBaseTopic ()

@property (nonatomic) NSURL *imageURL;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGTransmission transmission;
@property (nonatomic) SRGVendor vendor;

@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@end

@implementation SRGBaseTopic

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGBaseTopic.new, imageURL) : @"imageUrl",
            
            @keypath(SRGBaseTopic.new, title) : @"title",
            @keypath(SRGBaseTopic.new, lead) : @"lead",
            @keypath(SRGBaseTopic.new, summary) : @"description",
            
            @keypath(SRGBaseTopic.new, uid) : @"id",
            @keypath(SRGBaseTopic.new, URN) : @"urn",
            @keypath(SRGBaseTopic.new, transmission) : @"transmission",
            @keypath(SRGBaseTopic.new, vendor) : @"vendor",
            
            @keypath(SRGBaseTopic.new, imageTitle) : @"imageTitle",
            @keypath(SRGBaseTopic.new, imageCopyright) : @"imageCopyright"
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

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)transmissionJSONTransformer
{
    return SRGTransmissionJSONTransformer();
}

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGBaseTopic *otherBaseTopic = object;
    return [self.uid isEqualToString:otherBaseTopic.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
