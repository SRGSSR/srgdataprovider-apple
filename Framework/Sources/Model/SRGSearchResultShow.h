//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Show information of a search request
 *
 *  @discussion This object does not contain all show information. If you need complete show information or a 
 *              full-fledged `SRGShow` object, you must perform an additional request using the result uid
 */
@interface SRGSearchResultShow : SRGSearchResult

@end

NS_ASSUME_NONNULL_END