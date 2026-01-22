//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+LiveCenterServices.h"

#import "SRGDataProvider+Network.h"

@import SRGDataProviderRequests;

@implementation SRGDataProvider (LiveCenterServices)


- (SRGFirstPageRequest *)liveCenterVideosForVendor:(SRGVendor)vendor
                                 contentTypeFilter:(SRGContentTypeFilter)contentTypeFilter
                              eventsWithResultOnly:(BOOL)eventsWithResultOnly
                                          tags:(NSArray<NSString *> *)tags
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestLiveCenterVideosForVendor:vendor contentTypeFilter:contentTypeFilter eventsWithResultOnly:eventsWithResultOnly tags:tags];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

@end
