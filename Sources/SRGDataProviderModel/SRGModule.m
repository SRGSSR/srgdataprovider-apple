//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModule.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"
#import "NSURL+SRGDataProvider.h"

@import libextobjc;

@interface SRGModule ()

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic, copy) NSString *seoName;
@property (nonatomic) SRGImage *backgroundImage;
@property (nonatomic) SRGImage *logoImage;
@property (nonatomic) SRGImage *keyVisualImage;
@property (nonatomic) UIColor *headerBackgroundColor;
@property (nonatomic) UIColor *headerTextColor;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *linkColor;
@property (nonatomic, copy) NSString *websiteTitle;
@property (nonatomic) NSURL *websiteURL;
@property (nonatomic) NSArray<SRGSection *> *sections;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGModuleType moduleType;
@property (nonatomic) SRGVendor vendor;

@end

@implementation SRGModule

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGModule.new, startDate) : @"publishStartTimestamp",
            @keypath(SRGModule.new, endDate) : @"publishEndTimestamp",
            @keypath(SRGModule.new, seoName) : @"seoName",
            @keypath(SRGModule.new, backgroundImage) : @"bgImageUrl",
            @keypath(SRGModule.new, logoImage) : @"logoImageUrl",
            @keypath(SRGModule.new, keyVisualImage) : @"keyVisualImageUrl",
            @keypath(SRGModule.new, headerBackgroundColor) : @"headerBackgroundColor",
            @keypath(SRGModule.new, headerTextColor) : @"headerTitleColor",
            @keypath(SRGModule.new, backgroundColor) : @"bgColor",
            @keypath(SRGModule.new, textColor) : @"textColor",
            @keypath(SRGModule.new, linkColor) : @"linkColor",
            @keypath(SRGModule.new, websiteTitle) : @"microSiteTitle",
            @keypath(SRGModule.new, websiteURL) : @"microSiteUrl",
            @keypath(SRGModule.new, sections) : @"sectionList",
            
            @keypath(SRGModule.new, title) : @"title",
            @keypath(SRGModule.new, lead) : @"lead",
            @keypath(SRGModule.new, summary) : @"description",
            
            @keypath(SRGModule.new, uid) : @"id",
            @keypath(SRGModule.new, URN) : @"urn",
            @keypath(SRGModule.new, moduleType) : @"moduleConfigType",
            @keypath(SRGModule.new, vendor) : @"vendor"
        };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)startDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)endDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)backgroundImageJSONTransformer
{
    return SRGDefaultImageTransformer();
}

+ (NSValueTransformer *)logoImageJSONTransformer
{
    return SRGDefaultImageTransformer();
}

+ (NSValueTransformer *)keyVisualImageJSONTransformer
{
    return SRGDefaultImageTransformer();
}

+ (NSValueTransformer *)headerBackgroundColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)headerTextColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)backgroundColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)textColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)linkColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)sectionsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGSection.class];
}

+ (NSValueTransformer *)moduleTypeJSONTransformer
{
    return SRGModuleTypeJSONTransformer();
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
    
    SRGModule *otherModule = object;
    return [self.uid isEqualToString:otherModule.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
