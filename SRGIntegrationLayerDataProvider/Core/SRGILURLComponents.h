//
//  SRGILFetchPath.h
//  SRGIntegrationLayerDataProvider
//  Copyright © 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProviderConstants.h"

// Note: overriding host and scheme has no effect.

@interface SRGILURLComponents : NSURLComponents

@property(nonatomic, assign) SRGILFetchListIndex index;

+ (nullable SRGILURLComponents *)URLComponentsForFetchListIndex:(SRGILFetchListIndex)index
                                                 withIdentifier:(nullable NSString *)identifier
                                                          error:(NSError * __nullable __autoreleasing * __nullable)error;

// Convenient methods to update the query
- (void)updateQueryItemsWithSearchString:(nonnull NSString *)newQueryString;
- (void)updateQueryItemsWithPageSize:(nonnull NSString *)newPageSize;
- (void)updateQueryItemsWithDate:(nonnull NSDate *)newDate;

@end
