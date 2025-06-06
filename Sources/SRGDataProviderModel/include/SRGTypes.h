//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import CoreGraphics;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  @name Integer service types.
 */

/**
 *  Audio codecs.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGAudioCodec) {
    /**
     *  Not specified.
     */
    SRGAudioCodecNone = 0,
    /**
     *  Advanced Audio Coding.
     */
    SRGAudioCodecAAC,
    /**
     *  High-Efficiency Advanced Audio Coding.
     */
    SRGAudioCodecAAC_HE,
    /**
     *  MP3.
     */
    SRGAudioCodecMP3,
    /**
     *  MP2.
     */
    SRGAudioCodecMP2,
    /**
     *  WMAV2.
     */
    SRGAudioCodecWMAV2,
    /**
     *  Unknown.
     */
    SRGAudioCodecUnknown
};

/**
 *  Reasons for content blocking.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGBlockingReason) {
    /**
     *  The content is not blocked.
     */
    SRGBlockingReasonNone = 0,
    /**
     *  The content is blocked because the user is in a country where it is not available.
     */
    SRGBlockingReasonGeoblocking,
    /**
     *  The content is blocked for legal reasons.
     */
    SRGBlockingReasonLegal,
    /**
     *  The content is a commercial.
     */
    SRGBlockingReasonCommercial,
    /**
     *  The content is temporarily not available for editorial reasons.
     */
    SRGBlockingReasonJournalistic,
    /**
     *  The content is not suitable for people under 18.
     */
    SRGBlockingReasonAgeRating18,
    /**
     *  The content is not suitable for people under 12.
     */
    SRGBlockingReasonAgeRating12,
    /**
     *  The content is not available yet.
     */
    SRGBlockingReasonStartDate,
    /**
     *  The content is not available anymore.
     */
    SRGBlockingReasonEndDate,
    /**
     *  The content is accessed through a VPN or proxy.
     */
    SRGBlockingReasonVPNOrProxyDetected,
    /**
     *  The content is blocked for some unknown reason.
     */
    SRGBlockingReasonUnknown
};

/**
 *  Content page types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGContentPageType) {
    /**
     *  Not specified.
     */
    SRGContentPageTypeNone = 0,
    /**
     *  Landing page.
     */
    SRGContentPageTypeLandingPage,
    /**
     *  Topic page.
     */
    SRGContentPageTypeTopicPage,
    /**
     *  Show page.
     */
    SRGContentPageTypeShowPage,
    /**
     *  Default show page.
     */
    SRGContentPageTypeDefaultShowPage,
    /**
     *  Micro page.
     */
    SRGContentPageTypeMicroPage
};

/**
 *  Content presentation types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGContentPresentationType) {
    
    /**
     *  @name Standard presentations.
     */
    
    /**
     *  Not specified.
     */
    SRGContentPresentationTypeNone = 0,
    /**
     *  Swimlane (horizontal row).
     */
    SRGContentPresentationTypeSwimlane,
    /**
     *  Hero stage.
     */
    SRGContentPresentationTypeHeroStage,
    /**
     *  Highlight.
     */
    SRGContentPresentationTypeHighlight,
    /**
     *  Grid.
     */
    SRGContentPresentationTypeGrid,
    /**
     *  Media element (focus on a single media).
     */
    SRGContentPresentationTypeMediaElement,
    /**
     *  Media element swimlane (focus on a several medias).
     */
    SRGContentPresentationTypeMediaElementSwimlane,
    /**
     *  Show element (focus on a single show).
     */
    SRGContentPresentationTypeShowElement,
    /**
     *  Show promotion (highlight a single show).
     */
    SRGContentPresentationTypeShowPromotion,
    
    /**
     *  @name Presentations for predefined sections.
     */
    
    /**
     *  Favorite shows.
     */
    SRGContentPresentationTypeFavoriteShows,
    /**
     *  Livestreams.
     */
    SRGContentPresentationTypeLivestreams,
    /**
     *  Topic selector.
     */
    SRGContentPresentationTypeTopicSelector,
    /**
     *  Show access.
     */
    SRGContentPresentationTypeShowAccess,
    /**
     *  Continue watching (resume playback).
     */
    SRGContentPresentationTypeContinueWatching,
    /**
     *  Continue streaming (resume playback).
     */
    SRGContentPresentationTypeContinueStreaming,
    /**
     *  Watch later.
     */
    SRGContentPresentationTypeWatchLater,
    /**
     *  Stream later.
     */
    SRGContentPresentationTypeStreamLater,
    /**
     *  My program (personalized playback).
     */
    SRGContentPresentationTypeMyProgram,
    /**
     *  Available episodes for a show.
     */
    SRGContentPresentationTypeAvailableEpisodes,
    /**
     *  Trending shows by topic.
     */
    SRGContentPresentationTypeTrendingShowsByTopic
};

/**
 *  Content section types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGContentSectionType) {
    /**
     *  Not specified.
     */
    SRGContentSectionTypeNone = 0,
    /**
     *  List of medias.
     */
    SRGContentSectionTypeMedias,
    /**
     *  Show followed by a list of medias.
     */
    SRGContentSectionTypeShowAndMedias,
    /**
     *  List of shows.
     */
    SRGContentSectionTypeShows,
    /**
     *  Predefined section with content supplied client-side.
     */
    SRGContentSectionTypePredefined
};

/**
 *  Content types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGContentType) {
    /**
     *  Not specified.
     */
    SRGContentTypeNone = 0,
    /**
     *  Episode.
     */
    SRGContentTypeEpisode,
    /**
     *  Extract.
     */
    SRGContentTypeExtract,
    /**
     *  Trailer.
     */
    SRGContentTypeTrailer,
    /**
     *  Clip.
     */
    SRGContentTypeClip,
    /**
     *  Livestream.
     */
    SRGContentTypeLivestream,
    /**
     *  Scheduled livestram with start and end times.
     */
    SRGContentTypeScheduledLivestream
};

/**
 *  Content type filter
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGContentTypeFilter) {
    /**
     *  Any content.
     */
    SRGContentTypeFilterNone = 0,
    /**
     *  Scheduled livestreams with start and end times.
     */
    SRGContentTypeFilterScheduledLivestream,
    /**
     *  Episodes.
     */
    SRGContentTypeFilterEpisode
};

/**
 *  Digital Rights Management (DRM) types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGDRMType) {
    /**
     *  Not specified.
     */
    SRGDRMTypeNone = 0,
    /**
     *  FairPlay.
     */
    SRGDRMTypeFairPlay,
    /**
     *  Widevine.
     */
    SRGDRMTypeWidevine,
    /**
     *  PlayReady.
     */
    SRGDRMTypePlayReady
};

/**
 *  Media containers.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGMediaContainer) {
    /**
     *  Not specified.
     */
    SRGMediaContainerNone = 0,
    /**
     *  MP4.
     */
    SRGMediaContainerMP4,
    /**
     *  MKV.
     */
    SRGMediaContainerMKV,
    /**
     *  Unknown.
     */
    SRGMediaContainerUnknown
};

/**
 *  Media types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGMediaType) {
    /**
     *  Not specified.
     */
    SRGMediaTypeNone = 0,
    /**
     *  Video.
     */
    SRGMediaTypeVideo,
    /**
     *  Audio.
     */
    SRGMediaTypeAudio
};

/**
 *  Module types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGModuleType) {
    /**
     *  Not specified.
     */
    SRGModuleTypeNone = 0,
    /**
     *  Event.
     */
    SRGModuleTypeEvent
};

/**
 *  Content presentation types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGPresentation) {
    /**
     *  Not specified.
     */
    SRGPresentationNone = 0,
    /**
     *  Default presentation.
     */
    SRGPresentationDefault,
    /**
     *  360° presentation.
     */
    SRGPresentation360
};

/**
 *  Media qualities.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGQuality) {
    /**
     *  Not specified.
     */
    SRGQualityNone = 0,
    /**
     *  Standard definition.
     */
    SRGQualitySD,
    /**
     *  High definition.
     */
    SRGQualityHD,
    /**
     *  High quality.
     */
    SRGQualityHQ
};

/**
 *  Types of social or popularity measurement services.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGSocialCountType) {
    /**
     *  Not specified.
     */
    SRGSocialCountTypeNone = 0,
    /**
     *  SRG view count service.
     */
    SRGSocialCountTypeSRGView,
    /**
     *  SRG like service.
     */
    SRGSocialCountTypeSRGLike,
    /**
     *  Facebook.
     */
    SRGSocialCountTypeFacebookShare,
    /**
     *  Twitter.
     */
    SRGSocialCountTypeTwitterShare,
    /**
     *  Google+.
     */
    SRGSocialCountTypeGooglePlusShare,
    /**
     *  WhatsApp.
     */
    SRGSocialCountTypeWhatsAppShare
};

/**
 *  Media providing sources
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGSource) {
    /**
     *  Not specified.
     */
    SRGSourceNone = 0,
    /**
     *  Editorial.
     */
    SRGSourceEditor,
    /**
     *  Trending media identification system.
     */
    SRGSourceTrending,
    /**
     *  Recommendation system.
     */
    SRGSourceRecommendation
};

/**
 *  Streaming methods.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGStreamingMethod) {
    /**
     *  Not specified.
     */
    SRGStreamingMethodNone = 0,
    /**
     *  Progressive download.
     */
    SRGStreamingMethodProgressive,
    /**
     *  M3U playlist.
     */
    SRGStreamingMethodM3UPlaylist,
    /**
     *  HTTP Live Streaming.
     */
    SRGStreamingMethodHLS,
    /**
     *  HTTP Dynamic Streaming.
     */
    SRGStreamingMethodHDS,
    /**
     *  Real Time Messaging Protocol.
     */
    SRGStreamingMethodRTMP,
    /**
     *  HTTP.
     */
    SRGStreamingMethodHTTP,
    /**
     *  HTTPS.
     */
    SRGStreamingMethodHTTPS,
    /**
     *  DASH.
     */
    SRGStreamingMethodDASH,
    /**
     *  Unknown.
     */
    SRGStreamingMethodUnknown
};

/**
 *  Subtitle formats.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGSubtitleFormat) {
    /**
     *  Not specified.
     */
    SRGSubtitleFormatNone = 0,
    /**
     *  Timed Text Markup Language.
     */
    SRGSubtitleFormatTTML,
    /**
     *  Video Text Tracks.
     */
    SRGSubtitleFormatVTT
};

/**
 *  Token types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGTokenType) {
    /**
     *  Not specified.
     */
    SRGTokenTypeNone = 0,
    /**
     *  Akamai token.
     */
    SRGTokenTypeAkamai
};

/**
 *  Transmission types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGTransmission) {
    /**
     *  Not specified.
     */
    SRGTransmissionNone = 0,
    /**
     *  Television.
     */
    SRGTransmissionTV,
    /**
     *  Radio.
     */
    SRGTransmissionRadio,
    /**
     *  Online.
     */
    SRGTransmissionOnline,
    /**
     *  Unknown.
     */
    SRGTransmissionUnknown
};

/**
 *  Sources which variants can be retrieved from.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGVariantSource) {
    /**
     *  Not specified.
     */
    SRGVariantSourceNone = 0,
    /**
     *  Supplied as an external file.
     */
    SRGVariantSourceExternal,
    /**
     *  Supplied within an HLS stream.
     */
    SRGVariantSourceHLS,
    /**
     *  Supplied within an HDS stream.
     */
    SRGVariantSourceHDS,
    /**
     *  Supplied within a DASH stream.
     */
    SRGVariantSourceDASH
};

/**
 *  Variant types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGVariantType) {
    /**
     *  Not specified.
     */
    SRGVariantTypeNone = 0,
    /**
     *  Audio description.
     */
    SRGVariantTypeAudioDescription,
    /**
     *  Subtitles for the Deaf and Hard of Hearing.
     */
    SRGVariantTypeSDH
};

/**
 *  Content producers and providers.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGVendor) {
    /**
     *  Not specified.
     */
    SRGVendorNone = 0,
    /**
     *  SRG SSR business units.
     */
    SRGVendorRSI,
    SRGVendorRTR,
    SRGVendorRTS,
    SRGVendorSRF,
    SRGVendorSWI,
    /**
     *  Regional radios and televisions.
     */
    SRGVendorTVO,
    SRGVendorCanalAlpha,
    /**
     *  Swiss satellite radios.
     */
    SRGVendorSSATR
};

/**
 *  Video codecs.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGVideoCodec) {
    /**
     *  Not specified.
     */
    SRGVideoCodecNone = 0,
    /**
     *  H.264.
     */
    SRGVideoCodecH264,
    /**
     *  VP6F.
     */
    SRGVideoCodecVP6F,
    /**
     *  MPEG2.
     */
    SRGVideoCodecMPEG2,
    /**
     *  WMV3.
     */
    SRGVideoCodecWMV3,
    /**
     *  Unknown.
     */
    SRGVideoCodecUnknown
};

/**
 *  Youth protection colors.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGYouthProtectionColor) {
    /**
     *  Not specified.
     */
    SRGYouthProtectionColorNone = 0,
    /**
     *  Yellow.
     */
    SRGYouthProtectionColorYellow,
    /**
     *  Red.
     */
    SRGYouthProtectionColorRed
};

/**
 *  @name Data provider library types.
 */

/**
 *  Content providers.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGContentProviders) {
    /**
     *  Default behavior (does not include third party content).
     */
    SRGContentProvidersDefault = 0,
    /**
     *  SRG SSR and and all third party content.
     */
    SRGContentProvidersAll,
    /**
     *  Swiss Satellite Radio content only.
     */
    SRGContentProvidersSwissSatelliteRadio
};

/**
 *  Semantic image sizes.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGImageSize) {
    SRGImageSizeSmall = 0,
    SRGImageSizeMedium,
    SRGImageSizeLarge
};

/**
 *  Semantic image variant.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGImageVariant) {
    SRGImageVariantDefault = 0,
    SRGImageVariantPoster,
    SRGImageVariantPodcast
};

/**
 *  Image widths for image retrieval.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGImageWidth) {
    SRGImageWidth240 = 240,
    SRGImageWidth320 = 320,
    SRGImageWidth480 = 480,
    SRGImageWidth960 = 960,
    SRGImageWidth1920 = 1920
};

/**
 *  Return the recommended image width corresponding to a given semantic size and variant.
 */
OBJC_EXPORT SRGImageWidth SRGRecommendedImageWidth(SRGImageSize size, SRGImageVariant variant);

/**
 *  Return the recommended image `CGSize` corresponding to a given semantic size and variant.
 */
OBJC_EXPORT CGSize SRGRecommendedImageCGSize(SRGImageSize size, SRGImageVariant variant);

/**
 *  Filter for requesting medias.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGMediaFilter) {
    /**
     *  No filter.
     */
    SRGMediaFilterNone = 0,
    /**
     *  Only episodes.
     */
    SRGMediaFilterEpisodesOnly,
    /**
     *  Exclude episodes.
     */
    SRGMediaFilterEpisodesExcluded
};

/**
 *  Program providers.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGProgramProvider) {
    /**
     *  SRG SSR channels (default).
     */
    SRGProgramProviderSRG = 0,
    /**
     *  Third-party channels.
     */
    SRGProgramProviderThirdParty
};

/**
 *  Search match behavior.
 */
typedef NS_OPTIONS(NSUInteger, SRGSearchMatchingOptions) {
    /**
     *  Match any term within the search query. By default all search terms must be matched.
     */
    SRGSearchMatchingOptionAny = (1UL << 0),
    /**
     *  Exact matching. Search is fuzzy by default.
     */
    SRGSearchMatchingOptionExact = (1UL << 1)
};

/**
 *  Sort criteria.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGSortCriterium) {
    /**
     *  Use the default order returned by the service.
     */
    SRGSortCriteriumDefault = 0,
    /**
     *  Sort by date.
     */
    SRGSortCriteriumDate
};

/**
 *  Sort directions.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGSortDirection) {
    /**
     *  Descending order.
     */
    SRGSortDirectionDescending = 0,
    /**
     *  Ascending order.
     */
    SRGSortDirectionAscending
};

/**
 *  Stream types.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGStreamType) {
    /**
     *  Not specified.
     */
    SRGStreamTypeNone = 0,
    /**
     *  On-demand stream.
     */
    SRGStreamTypeOnDemand,
    /**
     *  Live-only stream.
     */
    SRGStreamTypeLive,
    /**
     *  DVR stream (live with timeshift support).
     */
    SRGStreamTypeDVR
};

/**
 *  Media time availability.
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGTimeAvailability) {
    /**
     *  The media is available.
     */
    SRGTimeAvailabilityAvailable = 0,
    /**
     *  The media is not yet available.
     */
    SRGTimeAvailabilityNotYetAvailable,
    /**
     *  The media is not available anymore.
     */
    SRGTimeAvailabilityNotAvailableAnymore
};

/**
 *  Scheduled livestream event types
 */
typedef NS_CLOSED_ENUM(NSInteger, SRGScheduledLivestreamEventType) {
    /**
     *  All types.
     */
    SRGScheduledLivestreamEventTypeAll = 0,
    /**
     *  News scheduled livestreams.
     */
    SRGScheduledLivestreamEventTypeNews,
    /**
     *  Sport scheduled livestreams.
     */
    SRGScheduledLivestreamEventTypeSport
};

typedef NS_CLOSED_ENUM(NSInteger, SRGContentLinkType) {
    /**
     *  Not specified.
     */
    SRGContentLinkTypeNone = 0,
    /**
     *  Detail page.
     */
    SRGContentLinkTypeDetailPage,
    /**
     *  Micro page.
     */
    SRGContentLinkTypeMicroPage
};

typedef NS_CLOSED_ENUM(NSInteger, SRGContentSectionMediaType) {
    /**
     *  Not specified.
     */
    SRGContentSectionMediaTypeNone = 0,
    /**
     *  AUDIO
     */
    SRGContentSectionMediaTypeAudio,
    /**
     * VIDEO
     */
    SRGContentSectionMediaTypeVideo
};

/**
 *  @name Known products.
 */
typedef NSString * SRGProduct NS_TYPED_ENUM;

OBJC_EXPORT SRGProduct const SRGProductPlayVideo;
OBJC_EXPORT SRGProduct const SRGProductPlayAudio;
OBJC_EXPORT SRGProduct const SRGProductNewsApp;
OBJC_EXPORT SRGProduct const SRGProductNewsVideo;
OBJC_EXPORT SRGProduct const SRGProductNewsAudio;

/**
 *  @name Constants
 */
static CGFloat SRGAspectRatioUndefined = -1.f;          // Undefined aspect ratio

static const NSUInteger SRGDataProviderDefaultPageSize = 10;                // The default page size.
static const NSUInteger SRGDataProviderMaximumPageSize = 100;               // The maximum supported page size.
static const NSUInteger SRGDataProviderUnlimitedPageSize = NSUIntegerMax;   // Unlimited page size (i.e. all results are returned). Not available for all services.

NS_ASSUME_NONNULL_END
