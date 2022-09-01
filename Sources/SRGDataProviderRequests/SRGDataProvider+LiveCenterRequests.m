//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+LiveCenterRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

static NSString *SRGContentTypeFilterParameter(SRGContentTypeFilter contentTypeFilter)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_liveCenterFilters;
    dispatch_once(&s_onceToken, ^{
        s_liveCenterFilters = @{
            @(SRGContentTypeFilterScheduledLivestream) : @"scheduled_livestream",
            @(SRGContentTypeFilterEpisode) : @"episode"
        };
    });
    return s_liveCenterFilters[@(contentTypeFilter)];
}

@implementation SRGDataProvider (LiveCenterRequests)

- (NSURLRequest *)requestLiveCenterVideosForVendor:(SRGVendor)vendor contentTypeFilter:(SRGContentTypeFilter)contentTypeFilter
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/scheduledLivestreams/livecenter", SRGPathComponentForVendor(vendor)];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (contentTypeFilter != SRGContentTypeFilterNone) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"types" value:SRGContentTypeFilterParameter(contentTypeFilter)]];
    }
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

@end
