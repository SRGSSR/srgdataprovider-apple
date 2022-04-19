//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaAggregations.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@implementation SRGBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGBucket.new, count) : @"count"
        };
    });
    return s_mapping;
}

@end

@implementation SRGDateBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGDateBucket.new, date) : @"date"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)dateJSONTransformer
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        s_transformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *pSuccess, NSError *__autoreleasing *error) {
            return [dateFormatter dateFromString:dateString];
        } reverseBlock:^id(NSDate *date, BOOL *pSuccess, NSError *__autoreleasing *error) {
            return [dateFormatter stringFromDate:date];
        }];
    });
    return s_transformer;
}

@end

@implementation SRGDownloadAvailableBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGDownloadAvailableBucket.new, downloadAvailable) : @"downloadAvailable"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

@end

@implementation SRGDurationBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGDurationBucket.new, duration) : @"duration"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

@end

@implementation SRGMediaTypeBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGMediaTypeBucket.new, mediaType) : @"mediaType"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return SRGMediaTypeJSONTransformer();
}

@end

@implementation SRGPlayableAbroadBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGPlayableAbroadBucket.new, playableAbroad) : @"playableAbroad"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

@end

@implementation SRGQualityBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGQualityBucket.new, quality) : @"quality"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)qualityJSONTransformer
{
    return SRGQualityJSONTransformer();
}

@end

@implementation SRGShowBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGShowBucket.new, URN) : @"urn",
            @keypath(SRGShowBucket.new, title) : @"title"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

@end

@implementation SRGSubtitlesAvailableBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGSubtitlesAvailableBucket.new, subtitlesAvailable) : @"subtitlesAvailable"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

@end

@implementation SRGTopicBucket

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{
            @keypath(SRGShowBucket.new, URN) : @"urn",
            @keypath(SRGShowBucket.new, title) : @"title"
        }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

@end

@implementation SRGMediaAggregations

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGMediaAggregations.new, mediaTypeBuckets) : @"mediaTypeList",
            
            @keypath(SRGMediaAggregations.new, subtitlesAvailableBuckets) : @"subtitleAvailableList",
            @keypath(SRGMediaAggregations.new, downloadAvailableBuckets) : @"downloadAvailableList",
            @keypath(SRGMediaAggregations.new, playableAbroadBuckets) : @"playableAbroadList",
            
            @keypath(SRGMediaAggregations.new, qualityBuckets) : @"qualityList",
            
            @keypath(SRGMediaAggregations.new, showBuckets) : @"showList",
            @keypath(SRGMediaAggregations.new, topicBuckets) : @"topicList",
            
            @keypath(SRGMediaAggregations.new, durationInMinutesBuckets) : @"durationListInMinutes",
            @keypath(SRGMediaAggregations.new, dateBuckets) : @"dateList"
        };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)mediaTypeBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGMediaTypeBucket.class];
}

+ (NSValueTransformer *)subtitlesAvailableBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGSubtitlesAvailableBucket.class];
}

+ (NSValueTransformer *)downloadAvailableBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGDownloadAvailableBucket.class];
}

+ (NSValueTransformer *)playableAbroadBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGPlayableAbroadBucket.class];
}

+ (NSValueTransformer *)qualityBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGQualityBucket.class];
}

+ (NSValueTransformer *)showBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGShowBucket.class];
}

+ (NSValueTransformer *)topicBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGTopicBucket.class];
}

+ (NSValueTransformer *)durationInMinutesBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGDurationBucket.class];
}

+ (NSValueTransformer *)dateBucketsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGDateBucket.class];
}

@end
