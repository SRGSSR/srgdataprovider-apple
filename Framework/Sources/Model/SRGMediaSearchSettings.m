//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaSearchSettings.h"

#import "NSDateFormatter+SRGDataProvider.h"

static NSString *SRGMediaTypeParameter(SRGMediaType mediaType)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_mediaTypes;
    dispatch_once(&s_onceToken, ^{
        s_mediaTypes = @{ @(SRGMediaTypeVideo) : @"video",
                          @(SRGMediaTypeAudio) : @"audio" };
    });
    return s_mediaTypes[@(mediaType)];
}

static NSString *SRGQualityParameter(SRGQuality quality)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_qualities;
    dispatch_once(&s_onceToken, ^{
        s_qualities = @{ @(SRGQualitySD) : @"sd",
                         @(SRGQualityHD) : @"hd",
                         @(SRGQualityHQ) : @"hd" /* Same value as for HD */ };
    });
    return s_qualities[@(quality)];
}

static NSString *SRGSortCriteriumParameter(SRGSortCriterium sortCriterium)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_sortCriteria;
    dispatch_once(&s_onceToken, ^{
        s_sortCriteria = @{ @(SRGSortCriteriumDefault) : @"default",
                            @(SRGSortCriteriumDate) : @"date" };
    });
    return s_sortCriteria[@(sortCriterium)];
}

static NSString *SRGSortDirectionParameter(SRGSortDirection sortDirection)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_sortDirections;
    dispatch_once(&s_onceToken, ^{
        s_sortDirections = @{ @(SRGSortDirectionDescending) : @"desc",
                              @(SRGSortDirectionAscending) : @"asc" };
    });
    return s_sortDirections[@(sortDirection)];
}

static NSString *SRGBoolParameter(BOOL boolean)
{
    return boolean ? @"true" : @"false";
}

@implementation SRGMediaSearchSettings

#pragma mark Getters and setters

- (NSArray<NSURLQueryItem *> *)queryItemsForVendor:(SRGVendor)vendor
{
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    
    // SWI has currently no support for parameters. Omit entirely
    if (vendor == SRGVendorSWI) {
        return [queryItems copy];
    }
    
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"includeAggregations" value:SRGBoolParameter(self.aggregationsEnabled)]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"includeSuggestions" value:SRGBoolParameter(self.suggestionsEnabled)]];

    if ((self.matchingOptions & SRGSearchMatchingOptionAny) != 0) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"operator" value:@"or"]];
    }
    
    if ((self.matchingOptions & SRGSearchMatchingOptionExact) != 0) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"enableFuzzySearch" value:@"false"]];
    }
    
    if (self.showURNs) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"showUrns" value:[self.showURNs componentsJoinedByString:@","]]];
    }
    if (self.topicURNs) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"topicUrns" value:[self.topicURNs componentsJoinedByString:@","]]];
    }
    
    NSString *mediaType = SRGMediaTypeParameter(self.mediaType);
    if (mediaType) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"mediaType" value:mediaType]];
    }
    
    if (self.subtitlesAvailable) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"subtitlesAvailable" value:SRGBoolParameter(self.subtitlesAvailable.boolValue)]];
    }
    if (self.downloadAvailable) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"downloadAvailable" value:SRGBoolParameter(self.downloadAvailable.boolValue)]];
    }
    if (self.playableAbroad) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"playableAbroad" value:SRGBoolParameter(self.playableAbroad.boolValue)]];
    }
    
    NSString *quality = SRGQualityParameter(self.quality);
    if (quality) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"quality" value:quality]];
    }
    
    if (self.minimumDurationInMinutes) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"durationFromInMinutes" value:self.minimumDurationInMinutes.stringValue]];
    }
    if (self.maximumDurationInMinutes) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"durationToInMinutes" value:self.maximumDurationInMinutes.stringValue]];
    }
    
    if (self.afterDate) {
        NSString *afterDate = [NSDateFormatter.srgdataprovider_dayDateFormatter stringFromDate:self.afterDate];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"publishedDateFrom" value:afterDate]];
    }
    if (self.beforeDate) {
        NSString *beforeDate = [NSDateFormatter.srgdataprovider_dayDateFormatter stringFromDate:self.beforeDate];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"publishedDateTo" value:beforeDate]];
    }
    
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"sortBy" value:SRGSortCriteriumParameter(self.sortCriterium)]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"sortDir" value:SRGSortDirectionParameter(self.sortDirection)]];
        
    return [queryItems copy];
}

@end
