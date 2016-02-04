//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 * Our error codes
 *
 * Let's try to keep this in sync with the Android code ( ErrorCursor.java )
 *
 */
typedef NS_ENUM (NSInteger, SRGILDataProviderErrorCode) {
    SRGILDataProviderErrorCodeInvalidRequest,
    SRGILDataProviderErrorCodeInvalidData,
    
    SRGILDataProviderErrorCodeInvalidMediaIdentifier,
    SRGILDataProviderErrorCodeInvalidMediaType,

    SRGILDataProviderErrorContentProviderWrongUri,
    SRGILDataProviderErrorContentProviderBadQuery,
    SRGILDataProviderErrorHttpIo,
    SRGILDataProviderErrorHttpCode, /* for unknown http errors, otherwise it's always >= 100 */
    SRGILDataProviderErrorJsonIo,
    SRGILDataProviderErrorJsonParse,
    SRGILDataProviderErrorJsonMalformedObject,
    SRGILDataProviderErrorJsonEmptyResponse,
    SRGILDataProviderErrorVideoNoSourceURL,
    SRGILDataProviderErrorVideoNoSourceURLForToken
};

// Domain for IL errors
extern NSString *const SRGILDataProviderErrorDomain;
extern NSString *const SRGILFetchListURLComponentsEmptySearchQueryString;

/**
 *  Fetched data from the IL can be returned, organised in different ways.
 */
typedef NS_ENUM(NSInteger, SRGILModelDataOrganisationType){
    /**
     *  The fetched data is returned as a flat list of items.
     */
    SRGILModelDataOrganisationTypeFlat,
    /**
     *  The fetched data is returned as an array of arrays of items, organised alphabetically.
     */
    SRGILModelDataOrganisationTypeAlphabetical,
};

/**
 *  The various entry points of the IL are listed here as 'indices'. A request to one of these indices return a list
 *  of items.
 */
typedef NS_ENUM(NSInteger, SRGILFetchListIndex) {
    SRGILFetchListEnumBegin,
    
    SRGILFetchListVideoLiveStreams = SRGILFetchListEnumBegin,
    SRGILFetchListVideoTrendingPicks,
    SRGILFetchListVideoEditorialPicks,
    SRGILFetchListVideoMostClicked,
    SRGILFetchListVideoMostRecent,
    SRGILFetchListVideoEpisodesByDate,
    SRGILFetchListVideoTopics,
    SRGILFetchListVideoMostRecentByTopic,
    SRGILFetchListVideoSearch,
    SRGILFetchListVideoShowsAlphabetical,
    SRGILFetchListVideoShowsSearch,
    SRGILFetchListVideoShowDetail,

    SRGILFetchListAudioLiveStreams,
    SRGILFetchListAudioEditorialLatest,
    SRGILFetchListAudioMostClicked,
    SRGILFetchListAudioMostRecent,
    SRGILFetchListAudioSearch,
    SRGILFetchListAudioShowsAlphabetical,
    SRGILFetchListAudioShowsSearch,
    SRGILFetchListAudioShowDetail,

    SRGILFetchListSonglogPlaying,
    SRGILFetchListSonglogLatest,

    SRGILFetchListMediaFavorite,
    SRGILFetchListShowFavorite,
    
    SRGILFetchListEnumEnd,
    SRGILFetchListEnumSize = SRGILFetchListEnumEnd - SRGILFetchListEnumBegin
};
