//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+TVRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

static NSString *SRGScheduledLivestreamEventTypeParameter(SRGScheduledLivestreamEventType type)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_types;
    dispatch_once(&s_onceToken, ^{
        s_types = @{
            @(SRGScheduledLivestreamEventTypeNews) : @"news",
            @(SRGScheduledLivestreamEventTypeSport) : @"sport"
        };
    });
    return s_types[@(type)];
}

@implementation SRGDataProvider (TVRequests)

- (NSURLRequest *)requestTVChannelsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channelList/tv", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVChannelForVendor:(SRGVendor)vendor
                                    withUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channel/%@/tv/nowAndNext", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVLatestProgramsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
                                     livestreamUid:(NSString *)livestreamUid
                                          fromDate:(NSDate *)fromDate
                                            toDate:(NSDate *)toDate
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/programListComposition/tv/byChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (livestreamUid) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid]];
    }
    if (fromDate) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"minEndTime" value:SRGStringFromDate(fromDate)]];
    }
    if (toDate) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxStartTime" value:SRGStringFromDate(toDate)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestTVProgramsForVendor:(SRGVendor)vendor
                                    provider:(SRGProgramProvider)provider
                                  channelUid:(NSString *)channelUid
                                         day:(SRGDay *)day
                                     minimal:(BOOL)minimal
{
    if (! day) {
        day = SRGDay.today;
    }
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (channelUid) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"channelId" value:channelUid]];
    }
    if (minimal) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"reduced" value:@"true"]];
    }
    
    NSString *resourcePath = nil;
    switch (provider) {
        case SRGProgramProviderSRG: {
            resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/programGuide/tv/byDate/%@", SRGPathComponentForVendor(vendor), day.string];
            break;
        }
            
        case SRGProgramProviderThirdParty: {
            resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/programGuideNonSrg/tv/byDate/%@", SRGPathComponentForVendor(vendor), day.string];
            break;
        }
    }
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestTVLivestreamsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/livestreams", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVScheduledLivestreamsForVendor:(SRGVendor)vendor
                                        signLanguageOnly:(BOOL)signLanguageOnly
                                               eventType:(SRGScheduledLivestreamEventType)eventType
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/scheduledLivestreams", SRGPathComponentForVendor(vendor)];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray new];
    if (signLanguageOnly) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"signLanguageOnly" value:@"true"]];
    }
    NSString *eventTypeValue = SRGScheduledLivestreamEventTypeParameter(eventType);
    if (eventTypeValue) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"eventType" value:eventTypeValue]];
    }
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.count > 0 ? queryItems.copy : nil];
}

- (NSURLRequest *)requestTVEditorialMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/editorial", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVHeroStageMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/heroStage", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVLatestMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodes", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVMostPopularMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/mostClicked", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVSoonExpiringMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/soonExpiring", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVTrendingMediasForVendor:(SRGVendor)vendor
                                         withLimit:(NSNumber *)limit
                                    editorialLimit:(NSNumber *)editorialLimit
                                      episodesOnly:(BOOL)episodesOnly
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/trending", SRGPathComponentForVendor(vendor)];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    
    // This request does not support pagination, but a maximum number of results, specified via a pageSize parameter.
    // The name is sadly misleading, see https://srfmmz.atlassian.net/browse/AIS-15970. Maximum page size is 50.
    if (limit) {
        limit = @(MIN(MAX(0, limit.integerValue), 50));
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:limit.stringValue]];
    }
    if (editorialLimit) {
        editorialLimit = @(MAX(0, editorialLimit.integerValue));
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxCountEditorPicks" value:editorialLimit.stringValue]];
    }
    if (episodesOnly) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"onlyEpisodes" value:@"true"]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestTVLatestEpisodesForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodes", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVLatestWebFirstEpisodesForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodes/webFirst", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVEpisodesForVendor:(SRGVendor)vendor
                                         day:(SRGDay *)day
{
    if (! day) {
        day = SRGDay.today;
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/episodesByDate/%@", SRGPathComponentForVendor(vendor), day.string];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVTopicsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/topicList/tv", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVShowsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/tv/alphabetical", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVShowsForVendor:(SRGVendor)vendor
                            matchingQuery:(NSString *)query
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultShowList/tv", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestTVMostPopularShowsForVendor:(SRGVendor)vendor
                                            topicUid:(NSString *)topicUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/tv/byTopic/%@/mostClicked", SRGPathComponentForVendor(vendor), topicUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end
