//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGDataProviderModel;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common `NSURLRequest` builders. Refer to the service documentation for more information about the purpose and
 *  parameters of each request.
 */
@interface SRGDataProvider (LiveCenterRequests)

- (NSURLRequest *)requestLiveCenterVideosForVendor:(SRGVendor)vendor
                                 contentTypeFilter:(SRGContentTypeFilter)contentTypeFilter
                                        withResult:(BOOL)withResult;

@end

NS_ASSUME_NONNULL_END
