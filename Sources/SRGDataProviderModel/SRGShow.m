//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShow.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGShow ()

@property (nonatomic) NSURL *homepageURL;
@property (nonatomic) NSURL *podcastSubscriptionURL;
@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;
@property (nonatomic) NSURL *podcastDeezerURL;
@property (nonatomic) NSURL *podcastSpotifyURL;
@property (nonatomic, copy) NSString *primaryChannelUid;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSURL *bannerImageURL;
@property (nonatomic) NSURL *posterImageURL;
@property (nonatomic) NSURL *podcastImageURL;
@property (nonatomic) NSNumber *numberOfEpisodes;
@property (nonatomic) NSArray<SRGTopic *> *topics;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGTransmission transmission;
@property (nonatomic) SRGVendor vendor;
@property (nonatomic) SRGBroadcastInformation *broadcastInformation;
@property (nonatomic, getter=isPosterImageFallbackURL) BOOL posterImageFallbackURL;
@property (nonatomic, getter=isPodcastImageFallbackURL) BOOL podcastImageFallbackURL;

@end

@implementation SRGShow

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGShow.new, homepageURL) : @"homepageUrl",
            @keypath(SRGShow.new, podcastSubscriptionURL) : @"podcastSubscriptionUrl",
            @keypath(SRGShow.new, podcastStandardDefinitionURL) : @"podcastFeedSdUrl",
            @keypath(SRGShow.new, podcastHighDefinitionURL) : @"podcastFeedHdUrl",
            @keypath(SRGShow.new, podcastDeezerURL) : @"podcastDeezerUrl",
            @keypath(SRGShow.new, podcastSpotifyURL) : @"podcastSpotifyUrl",
            @keypath(SRGShow.new, primaryChannelUid) : @"primaryChannelId",
            @keypath(SRGShow.new, imageURL) : @"imageUrl",
            @keypath(SRGShow.new, bannerImageURL) : @"bannerImageUrl",
            @keypath(SRGShow.new, posterImageURL) : @"posterImageUrl",
            @keypath(SRGShow.new, podcastImageURL) : @"podcastImageUrl",
            @keypath(SRGShow.new, numberOfEpisodes) : @"numberOfEpisodes",
            @keypath(SRGShow.new, topics) : @"topicList",
            
            @keypath(SRGShow.new, title) : @"title",
            @keypath(SRGShow.new, lead) : @"lead",
            @keypath(SRGShow.new, summary) : @"description",
            
            @keypath(SRGShow.new, imageTitle) : @"imageTitle",
            @keypath(SRGShow.new, imageCopyright) : @"imageCopyright",
            
            @keypath(SRGShow.new, uid) : @"id",
            @keypath(SRGShow.new, URN) : @"urn",
            @keypath(SRGShow.new, transmission) : @"transmission",
            @keypath(SRGShow.new, vendor) : @"vendor",
            @keypath(SRGShow.new, broadcastInformation) : @"broadcastInformation",
            @keypath(SRGShow.new, posterImageFallbackURL) : @"posterImageIsFallbackUrl",
            @keypath(SRGShow.new, podcastImageFallbackURL) : @"podcastImageIsFallbackUrl"
        };
    });
    return s_mapping;
}

#pragma mark Getters and setters

- (SRGImage *)image
{
    return [SRGImage imageWithURL:self.imageURL variant:SRGImageVariantDefault];
}

- (SRGImage *)bannerImage
{
    return [SRGImage imageWithURL:self.bannerImageURL variant:SRGImageVariantDefault];
}

- (SRGImage *)posterImage
{
    return [SRGImage imageWithURL:self.posterImageURL variant:SRGImageVariantPoster];
}

- (SRGImage *)podcastImage
{
    return [SRGImage imageWithURL:self.podcastImageURL variant:SRGImageVariantPodcast];
}

#pragma mark Transformers

+ (NSValueTransformer *)homepageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastSubscriptionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastFeedSdURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastFeedHdURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastDeezerURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastSpotifyURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)bannerImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)posterImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)topicsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGTopic.class];
}

+ (NSValueTransformer *)transmissionJSONTransformer
{
    return SRGTransmissionJSONTransformer();
}

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
}

+ (NSValueTransformer *)broadcastInformationJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGBroadcastInformation.class];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGShow *otherShow = object;
    return [self.URN isEqual:otherShow.URN];
}

- (NSUInteger)hash
{
    return self.URN.hash;
}

@end
