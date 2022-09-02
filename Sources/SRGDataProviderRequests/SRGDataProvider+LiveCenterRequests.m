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
    static NSDictionary<NSNumber *, NSString *> *s_contentTypeFilters;
    dispatch_once(&s_onceToken, ^{
        s_contentTypeFilters = @{
            @(SRGContentTypeFilterScheduledLivestream) : @"scheduled_livestream",
            @(SRGContentTypeFilterEpisode) : @"episode"
        };
    });
    return s_contentTypeFilters[@(contentTypeFilter)];
}

@implementation SRGDataProvider (LiveCenterRequests)

- (NSURLRequest *)requestLiveCenterVideosForVendor:(SRGVendor)vendor
                                 contentTypeFilter:(SRGContentTypeFilter)contentTypeFilter
                              eventsWithResultOnly:(BOOL)eventsWithResultOnly
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/scheduledLivestreams/livecenter", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"onlyEventsWithResult" value:eventsWithResultOnly ? @"true" : @"false"] ];
    if (contentTypeFilter != SRGContentTypeFilterNone) {
        queryItems = [queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"types" value:SRGContentTypeFilterParameter(contentTypeFilter)]];
    }
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

@end
