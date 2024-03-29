//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaComposition.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGMediaComposition ()

@property (nonatomic, copy) NSString *chapterURN;
@property (nonatomic, copy) NSString *segmentURN;
@property (nonatomic) SRGChannel *channel;
@property (nonatomic) SRGEpisode *episode;
@property (nonatomic) SRGShow *show;
@property (nonatomic) NSArray<SRGChapter *> *chapters;
@property (nonatomic) NSDictionary<NSString *, NSString *> *analyticsLabels;
@property (nonatomic) NSDictionary<NSString *, NSString *> *comScoreAnalyticsLabels;

@end

@implementation SRGMediaComposition

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGMediaComposition.new, chapterURN) : @"chapterUrn",
            @keypath(SRGMediaComposition.new, segmentURN) : @"segmentUrn",
            @keypath(SRGMediaComposition.new, channel) : @"channel",
            @keypath(SRGMediaComposition.new, episode) : @"episode",
            @keypath(SRGMediaComposition.new, show) : @"show",
            @keypath(SRGMediaComposition.new, chapters) : @"chapterList",
            @keypath(SRGMediaComposition.new, analyticsLabels) : @"analyticsMetadata",
            @keypath(SRGMediaComposition.new, comScoreAnalyticsLabels) : @"analyticsData"
        };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)channelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGChannel.class];
}

+ (NSValueTransformer *)episodeJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGEpisode.class];
}

+ (NSValueTransformer *)showJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGShow.class];
}

+ (NSValueTransformer *)chaptersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGChapter.class];
}

#pragma mark Getters and setters

- (SRGChapter *)mainChapter
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGChapter.new, URN), self.chapterURN];
    return [self.chapters filteredArrayUsingPredicate:predicate].firstObject;
}

- (SRGSegment *)mainSegment
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGChapter.new, URN), self.segmentURN];
    return [self.mainChapter.segments filteredArrayUsingPredicate:predicate].firstObject;
}

- (SRGMedia *)fullLengthMedia
{
    SRGChapter *mainChapter = self.mainChapter;
    if (mainChapter.fullLengthURN) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGChapter.new, URN), mainChapter.fullLengthURN];
        SRGChapter *fullLengthChapter = [self.chapters filteredArrayUsingPredicate:predicate].firstObject;
        return fullLengthChapter ? [self mediaForSubdivision:fullLengthChapter] : [self mediaForSubdivision:mainChapter];
    }
    else {
        return [self mediaForSubdivision:mainChapter];
    }    
}

#pragma mark Media and media composition generation

// Return the media composition subdivision which matches the one provided as parameter, nil if not found.
- (SRGSubdivision *)subdivisionMatchingSubdivision:(SRGSubdivision *)subdivision
{
    for (SRGChapter *chapter in self.chapters) {
        if ([chapter isEqual:subdivision]) {
            return chapter;
        }
        else {
            for (SRGSegment *chapterSegment in chapter.segments) {
                if ([chapterSegment isEqual:subdivision]) {
                    return chapterSegment;
                }
            }
        }
    }
    
    return nil;
}

// Return the media composition chapter which matches the subdivision provided as parameter, it-self, it chapter parent, nil if not found.
- (SRGChapter *)chapterMatchingSubdivision:(SRGSubdivision *)subdivision
{
    for (SRGChapter *chapter in self.chapters) {
        if ([chapter isEqual:subdivision]) {
            return chapter;
        }
        else {
            for (SRGSegment *chapterSegment in chapter.segments) {
                if ([chapterSegment isEqual:subdivision]) {
                    return chapter;
                }
            }
        }
    }
    
    return nil;
}

- (SRGMedia *)mediaForSubdivision:(SRGSubdivision *)subdivision
{
    SRGSubdivision *matchingSubdivision = [self subdivisionMatchingSubdivision:subdivision];
    if (! matchingSubdivision) {
        return nil;
    }
    
    SRGMedia *media = [[SRGMedia alloc] init];
    
    // Start from the subdivision belonging to the media composition, so that values are as accurate as possible (the
    // subdivision as parameter might namely have diverged).
    NSMutableDictionary *values = matchingSubdivision.dictionaryValue.mutableCopy;
    
    // Merge with parent metadata available at the media composition level
    if (self.channel) {
        values[@keypath(media.channel)] = self.channel;
    }
    if (self.episode) {
        values[@keypath(media.episode)] = self.episode;
    }
    if (self.show) {
        values[@keypath(media.show)] = self.show;
    }
    
    // Fill the presentation property
    SRGChapter *chapter = [self chapterMatchingSubdivision:subdivision];
    values[@keypath(media.presentation)] = @(chapter.presentation);
    
    // Fill the media object
    for (NSString *key in [SRGMedia propertyKeys]) {
        id value = values[key];
        if (value && value != [NSNull null]) {
            [media setValue:value forKey:key];
        }
    }
    
    return media;
}

- (SRGMediaComposition *)mediaCompositionForSubdivision:(SRGSubdivision *)subdivision
{
    for (SRGChapter *chapter in self.chapters) {
        if ([chapter isEqual:subdivision]) {
            SRGMediaComposition *mediaComposition = self.copy;
            mediaComposition.chapterURN = chapter.URN;
            mediaComposition.segmentURN = nil;
            return mediaComposition;
        }
        else {
            for (SRGSegment *chapterSegment in chapter.segments) {
                if ([chapterSegment isEqual:subdivision]) {
                    SRGMediaComposition *mediaComposition = self.copy;
                    mediaComposition.chapterURN = chapter.URN;
                    mediaComposition.segmentURN = chapterSegment.URN;
                    return mediaComposition;
                }
            }
        }
    }
    
    // No match found
    return nil;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGMediaComposition *otherMediaComposition = object;
    if (self.segmentURN) {
        return [self.segmentURN isEqual:otherMediaComposition.segmentURN];
    }
    else {
        return [self.chapterURN isEqual:otherMediaComposition.chapterURN];
    }
}

- (NSUInteger)hash
{
    return self.segmentURN ? self.segmentURN.hash : self.chapterURN.hash;
}

@end
