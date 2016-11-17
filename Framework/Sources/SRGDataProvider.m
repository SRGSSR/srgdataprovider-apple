//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

#import "NSBundle+SRGDataProvider.h"
#import "SRGDataProviderError.h"
#import "SRGPage+Private.h"
#import "SRGRequest+Private.h"

#import <Mantle/Mantle.h>

SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRSI = @"rsi";
SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRTR = @"rtr";
SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRTS = @"rts";
SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierSRF = @"srf";
SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierSWI = @"swi";

static NSString * const SRGTokenServiceURLString = @"https://tp.srgssr.ch/akahd/token";

static SRGDataProvider *s_currentDataProvider;

static NSString *SRGDataProviderRequestDateString(NSDate *date);

@interface SRGDataProvider ()

@property (nonatomic) NSURL *serviceURL;
@property (nonatomic, copy) NSString *businessUnitIdentifier;
@property (nonatomic) NSURLSession *session;

@end

@implementation SRGDataProvider

#pragma mark Class methods

+ (SRGDataProvider *)currentDataProvider
{
    return s_currentDataProvider;
}

+ (SRGDataProvider *)setCurrentDataProvider:(SRGDataProvider *)currentDataProvider
{
    SRGDataProvider *previousDataProvider = s_currentDataProvider;
    s_currentDataProvider = currentDataProvider;
    return previousDataProvider;
}

#pragma mark Object lifecycle

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier
{
    if (self = [super init]) {
        // According to the standard, the base URL must end with a slash or the last path component will be truncated
        // See http://stackoverflow.com/questions/16582350/nsurl-urlwithstringrelativetourl-is-clipping-relative-url
        if ([serviceURL.absoluteString hasSuffix:@"/"]) {
            self.serviceURL = serviceURL;
        }
        else {
            self.serviceURL = [NSURL URLWithString:[serviceURL.absoluteString stringByAppendingString:@"/"]];
        }
        
        self.businessUnitIdentifier = businessUnitIdentifier;
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark Public requests

- (SRGRequest *)editorialVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/editorial.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)soonExpiringVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/soonExpiring.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videoEpisodesForDate:(NSDate *)date withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    if (!date) {
        date = [NSDate date];
    }
    
    NSString *dateString = SRGDataProviderRequestDateString(date);
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/episodesByDate/%@.json", self.businessUnitIdentifier, dateString];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)trendingVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    return [self trendingVideosWithEditorialLimit:nil episodesOnly:NO completionBlock:completionBlock];
}

- (SRGRequest *)trendingVideosWithEditorialLimit:(NSNumber *)editorialLimit episodesOnly:(BOOL)episodesOnly completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/trending.json", self.businessUnitIdentifier];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (editorialLimit) {
        editorialLimit = @(MAX(0, editorialLimit.integerValue));
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxCountEditorPicks" value:editorialLimit.stringValue]];
    }
    if (episodesOnly) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"onlyEpisodes" value:@"true"]];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videoLivestreamsWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/livestreams.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)audioLivestreamsForChannelWithUid:(NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    
    if (channelUid) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/livestreamsByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/livestreams.json", self.businessUnitIdentifier];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videoChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channelList/tv.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGChannel class] rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects,  SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, nil);
    }];
}

- (SRGRequest *)audioChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channelList/radio.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGChannel class] rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects,  SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, nil);
    }];
}

- (SRGRequest *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/topicList/tv.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGTopic class] rootKey:@"topicList" completionBlock:^(NSArray * _Nullable objects, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)latestVideosForTopicWithUid:(NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    
    if (topicUid) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestByTopic/%@.json", self.businessUnitIdentifier, topicUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latest.json", self.businessUnitIdentifier];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)latestAudiosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/latest.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)mostPopularVideosForTopicWithUid:(NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/mostClicked.json", self.businessUnitIdentifier];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (topicUid) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"topicId" value:topicUid] ];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)mostPopularAudiosForChannelWithUid:(NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    
    if (channelUid) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/mostClickedByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/mostClicked.json", self.businessUnitIdentifier];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)eventsWithCompletionBlock:(SRGEventListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/eventConfigList.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGEvent class] rootKey:@"eventConfigList" completionBlock:^(NSArray * _Nullable objects, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)latestVideosForEventWithUid:(NSString *)eventUid sectionUid:(NSString *)sectionUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    
    if (sectionUid) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestByEventId/%@/sectionId/%@.json", self.businessUnitIdentifier, eventUid, sectionUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestByEventId/%@.json", self.businessUnitIdentifier, eventUid];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)latestVideoEpisodesForChannelWithUid:(NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    
    if (channelUid) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodesByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodes.json", self.businessUnitIdentifier];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)latestAudioEpisodesForChannelWithUid:(NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/latestEpisodesByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/tv/alphabetical.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] rootKey:@"showList" completionBlock:completionBlock];
}

- (SRGRequest *)audioShowsForChannelWithUid:(NSString *)channelUid completionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/radio/alphabeticalByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] rootKey:@"showList" completionBlock:completionBlock];
}

- (SRGRequest *)latestEpisodesForShowWithUid:(NSString *)showUid completionBlock:(SRGEpisodeCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/episodeComposition/latestByShow/%@.json", self.businessUnitIdentifier, showUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGEpisodeComposition class] completionBlock:completionBlock];
}

- (SRGRequest *)audioEpisodesForDate:(NSDate *)date withChannelUid:(NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    if (!date) {
        date = [NSDate date];
    }
    
    NSString *dateString = SRGDataProviderRequestDateString(date);
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/episodesByDateAndChannel/%@/%@.json", self.businessUnitIdentifier, channelUid, dateString];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)showWithUid:(NSString *)showUid completionBlock:(SRGShowCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/show/%@.json", self.businessUnitIdentifier, showUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)mediaCompositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaComposition/video/%@.json", self.businessUnitIdentifier, mediaUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMediaComposition class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)searchVideosMatchingQuery:(NSString *)query withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/search.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)searchAudiosMatchingQuery:(NSString *)query withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/search.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)searchVideoShowsMatchingQuery:(NSString *)query withCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/tv/search.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] rootKey:@"showList" completionBlock:completionBlock];
}

- (SRGRequest *)searchAudioShowsMatchingQuery:(NSString *)query withCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/radio/search.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"showList" completionBlock:completionBlock];
}

- (SRGRequest *)likeMediaComposition:(SRGMediaComposition *)mediaComposition withCompletionBlock:(SRGLikeCompletionBlock)completionBlock
{
    // Assert request parameters. Won't crash in release builds, but the request will most likely fails
    SRGChapter *mainChapter = mediaComposition.mainChapter;
    NSAssert(mainChapter, @"Expect a chapter");
    NSAssert(mediaComposition.event, @"Expect event information");
    
    NSString *mediaTypeString = (mainChapter.mediaType == SRGMediaTypeAudio) ? @"audio" : @"video";
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaStatistic/%@/%@/liked.json", self.businessUnitIdentifier, mediaTypeString, mainChapter.uid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *bodyJSONDictionary = mediaComposition.event ? @{ @"eventData" : mediaComposition.event } : @{};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyJSONDictionary options:0 error:NULL];
    
    return [self fetchObjectWithRequest:request modelClass:[SRGLike class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

#pragma mark Tokenization

+ (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock
{
    NSParameterAssert(URL);
    NSParameterAssert(completionBlock);
    
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSString *acl = [URLComponents.path.stringByDeletingLastPathComponent stringByAppendingPathComponent:@"*"];
    
    NSURLComponents *tokenServiceURLComponents = [NSURLComponents componentsWithURL:[NSURL URLWithString:SRGTokenServiceURLString] resolvingAgainstBaseURL:NO];
    tokenServiceURLComponents.queryItems = @[ [NSURLQueryItem queryItemWithName:@"acl" value:acl] ];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:tokenServiceURLComponents.URL];
    return [[SRGRequest alloc] initWithRequest:request session:[NSURLSession sharedSession] completionBlock:^(NSDictionary * _Nullable JSONDictionary, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        NSString *token = nil;
        
        id tokenDictionary = JSONDictionary[@"token"];
        if ([tokenDictionary isKindOfClass:[NSDictionary class]]) {
            token = [tokenDictionary objectForKey:@"authparams"];
        }
        
        if (!token) {
            completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                     code:SRGDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The stream could not be secured.", nil) }]);
            return;
        }
        
        // Use components to properly extract the token as query items
        NSURLComponents *tokenURLComponents = [[NSURLComponents alloc] init];
        tokenURLComponents.query = token;
        
        // Build the tokenized URL, merging token components with existing ones
        NSURLComponents *tokenizedURLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
        
        NSMutableArray *queryItems = [tokenizedURLComponents.queryItems mutableCopy] ?: [NSMutableArray array];
        if (tokenURLComponents.queryItems) {
            [queryItems addObjectsFromArray:tokenURLComponents.queryItems];
        }
        tokenizedURLComponents.queryItems = [queryItems copy];
        
        completionBlock(tokenizedURLComponents.URL, nil);
    }];
}

#pragma mark Common implementation

- (NSURL *)URLForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSURL *URL = [NSURL URLWithString:resourcePath relativeToURL:self.serviceURL];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URL.absoluteString];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    URLComponents.queryItems = fullQueryItems.count != 0 ? [fullQueryItems copy] : nil;
    
    return URLComponents.URL;
}

- (SRGRequest *)listObjectsWithRequest:(NSURLRequest *)request
                            modelClass:(Class)modelClass
                               rootKey:(NSString *)rootKey
                       completionBlock:(void (^)(NSArray * _Nullable objects, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    return [[SRGRequest alloc] initWithRequest:request session:self.session completionBlock:^(NSDictionary * _Nullable JSONDictionary, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, page, nil, error);
            return;
        }
        
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:[NSArray class]]) {
            NSArray *objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:NULL];
            if (objects) {
                completionBlock(objects, page, nextPage, nil);
                return;
            }
        }
        else {
            // This also correctly handles the special case where the number of results is a multiple of the page size. When retrieved,
            // the last link will return an empty dictionary
            // See https://srfmmz.atlassian.net/wiki/display/SRGPLAY/Developer+Meeting+2016-10-05
            completionBlock(@[], page, nil, nil);
        }
    }];
}

- (SRGRequest *)fetchObjectWithRequest:(NSURLRequest *)request
                            modelClass:(Class)modelClass
                       completionBlock:(void (^)(id _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(modelClass);
    NSParameterAssert(completionBlock);
    
    return [[SRGRequest alloc] initWithRequest:request session:self.session completionBlock:^(NSDictionary * _Nullable JSONDictionary, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, page, nil, error);
            return;
        }
        
        id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:NULL];
        if (!object) {
            completionBlock(nil, page, nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                                code:SRGDataProviderErrorCodeInvalidData
                                                            userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
            return;
        }
        
        completionBlock(object, page, nextPage, nil);
    }];
}

#pragma mark NSURLSessionDelegate protocol

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    // Refuse the redirection and return the redirection response (with the proper HTTP status code)
    completionHandler(nil);
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; serviceURL: %@; businessUnitIdentifier: %@>",
            [self class],
            self,
            self.serviceURL,
            self.businessUnitIdentifier];
}

@end

#pragma mark Functions

NSString *SRGDataProviderMarketingVersion(void)
{
    return [NSBundle srg_dataProviderBundle].infoDictionary[@"CFBundleShortVersionString"];
}

static NSString *SRGDataProviderRequestDateString(NSDate *date)
{
    NSCAssert(date, @"Expect a date");
    
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return [dateFormatter stringFromDate:date];
}
