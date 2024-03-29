//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChannel.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGChannel ()

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSURL *rawImageURL;
@property (nonatomic) NSURL *timetableURL;
@property (nonatomic) SRGProgram *currentProgram;
@property (nonatomic) SRGProgram *nextProgram;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGTransmission transmission;
@property (nonatomic) SRGVendor vendor;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@end

@implementation SRGChannel

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGChannel.new, imageURL) : @"imageUrl",
            @keypath(SRGChannel.new, rawImageURL) : @"imageUrlRaw",
            @keypath(SRGChannel.new, timetableURL) : @"timeTableUrl",
            @keypath(SRGChannel.new, currentProgram) : @"now",
            @keypath(SRGChannel.new, nextProgram) : @"next",
            
            @keypath(SRGChannel.new, uid) : @"id",
            @keypath(SRGChannel.new, URN) : @"urn",
            @keypath(SRGChannel.new, transmission) : @"transmission",
            @keypath(SRGChannel.new, vendor) : @"vendor",
            
            @keypath(SRGChannel.new, title) : @"title",
            @keypath(SRGChannel.new, lead) : @"lead",
            @keypath(SRGChannel.new, summary) : @"description",
            
            @keypath(SRGChannel.new, imageTitle) : @"imageTitle",
            @keypath(SRGChannel.new, imageCopyright) : @"imageCopyright"
        };
    });
    return s_mapping;
}

#pragma mark Getters and setters

- (SRGImage *)image
{
    return [SRGImage imageWithURL:self.imageURL variant:SRGImageVariantDefault];
}

- (SRGImage *)rawImage
{
    return [SRGImage imageWithURL:self.rawImageURL variant:SRGImageVariantDefault];
}

#pragma mark Transformers

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)rawImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)timetableURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)currentProgramJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGProgram.class];
}

+ (NSValueTransformer *)nextProgramJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGProgram.class];
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
    
    SRGChannel *otherChannel = object;
    return [self.uid isEqualToString:otherChannel.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
