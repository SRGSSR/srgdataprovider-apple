//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ContentRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@implementation SRGDataProvider (ContentRequests)

- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                          uid:(NSString *)uid
                                    published:(BOOL)published
                                       atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/page/%@", SRGPathComponentForVendor(vendor), uid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                  productName:(NSString *)productName
                                    published:(BOOL)published
                                       atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/page/landingPage/byProduct/%@", SRGPathComponentForVendor(vendor), productName];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                 topicWithURN:(NSString *)topicURN
                                    published:(BOOL)published
                                       atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/page/byTopicUrn/%@", SRGPathComponentForVendor(vendor), topicURN];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestContentSectionForVendor:(SRGVendor)vendor
                                             uid:(NSString *)uid
                                       published:(BOOL)published
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/section/%@", SRGPathComponentForVendor(vendor), uid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestMediasForVendor:(SRGVendor)vendor
                       contentSectionUid:(NSString *)contentSectionUid
                                  userId:(NSString *)userId
                               published:(BOOL)published
                                  atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/section/mediaSection/%@", SRGPathComponentForVendor(vendor), contentSectionUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (userId) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"userId" value:userId]];
    }
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestShowsForVendor:(SRGVendor)vendor
                      contentSectionUid:(NSString *)contentSectionUid
                                 userId:(NSString *)userId
                              published:(BOOL)published
                                 atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/section/showSection/%@", SRGPathComponentForVendor(vendor), contentSectionUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (userId) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"userId" value:userId]];
    }
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestShowAndMediasForVendor:(SRGVendor)vendor
                              contentSectionUid:(NSString *)contentSectionUid
                                         userId:(NSString *)userId
                                      published:(BOOL)published
                                         atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/section/mediaSectionWithShow/%@", SRGPathComponentForVendor(vendor), contentSectionUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (userId) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"userId" value:userId]];
    }
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

@end
