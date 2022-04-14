//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGProgram.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGProgram ()

@property (nonatomic, copy) NSString *uid;      // Not parsed from JSON but privately introduced to ensure uniqueness

@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSURL *URL;
@property (nonatomic) SRGShow *show;
@property (nonatomic) NSArray<SRGProgram *> *subprograms;
@property (nonatomic, copy) NSString *mediaURN;
@property (nonatomic, copy) NSString *genre;
@property (nonatomic) NSNumber *seasonNumber;
@property (nonatomic) NSNumber *episodeNumber;
@property (nonatomic) NSNumber *numberOfEpisodes;
@property (nonatomic) NSNumber *productionYear;
@property (nonatomic, copy) NSString *productionCountry;
@property (nonatomic, copy) NSString *originalTitle;
@property (nonatomic) NSArray<SRGCrewMember *> *crewMembers;
@property (nonatomic) BOOL isRebroadcast;
@property (nonatomic, copy) NSString *rebroadcastDescription;
@property (nonatomic) BOOL subtitlesAvailable;
@property (nonatomic) BOOL alternateAudioAvailable;
@property (nonatomic) BOOL signLanguageAvailable;
@property (nonatomic) BOOL audioDescriptionAvailable;
@property (nonatomic) BOOL dolbyDigitalAvailable;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@end

@implementation SRGProgram

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGProgram.new, subtitle) : @"subtitle",
                       @keypath(SRGProgram.new, startDate) : @"startTime",
                       @keypath(SRGProgram.new, endDate) : @"endTime",
                       @keypath(SRGProgram.new, URL) : @"url",
                       @keypath(SRGProgram.new, show) : @"show",
                       @keypath(SRGProgram.new, subprograms) : @"subProgramList",
                       @keypath(SRGProgram.new, mediaURN) : @"mediaUrn",
                       @keypath(SRGProgram.new, genre) : @"genre",
                       @keypath(SRGProgram.new, seasonNumber) : @"seasonNumber",
                       @keypath(SRGProgram.new, episodeNumber) : @"episodeNumber",
                       @keypath(SRGProgram.new, numberOfEpisodes) : @"episodesTotal",
                       @keypath(SRGProgram.new, productionYear) : @"productionYear",
                       @keypath(SRGProgram.new, productionCountry) : @"productionCountry",
                       @keypath(SRGProgram.new, originalTitle) : @"originalTitle",
                       
                       @keypath(SRGProgram.new, crewMembers) : @"creditList",
                       @keypath(SRGProgram.new, isRebroadcast) : @"isRepetition",
                       @keypath(SRGProgram.new, rebroadcastDescription) : @"repetitionDescription",
                       @keypath(SRGProgram.new, subtitlesAvailable) : @"subtitlesAvailable",
                       @keypath(SRGProgram.new, alternateAudioAvailable) : @"hasTwoLanguages",
                       @keypath(SRGProgram.new, signLanguageAvailable) : @"hasSignLanguage",
                       @keypath(SRGProgram.new, audioDescriptionAvailable) : @"hasVisualDescription",
                       @keypath(SRGProgram.new, dolbyDigitalAvailable) : @"isDolbyDigital",
                       
                       @keypath(SRGProgram.new, title) : @"title",
                       @keypath(SRGProgram.new, lead) : @"lead",
                       @keypath(SRGProgram.new, summary) : @"description",
                       
                       @keypath(SRGProgram.new, imageURL) : @"imageUrl",
                       @keypath(SRGProgram.new, imageTitle) : @"imageTitle",
                       @keypath(SRGProgram.new, imageCopyright) : @"imageCopyright" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)startDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)endDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)showJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGShow.class];
}

+ (NSValueTransformer *)subprogramsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGProgram.class];
}

+ (NSValueTransformer *)crewMembersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGCrewMember.class];
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark SRGImageMetadata protocol

- (NSURL *)imageURLForWidth:(SRGImageWidth)width type:(SRGImageType)type
{
    return [self.imageURL srg_URLForWidth:width];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGProgram *otherProgram = object;
    return [self.uid isEqual:otherProgram.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end

static NSArray<SRGProgram *> *SRGSanitizedProgramsAndSubprograms(NSArray<SRGProgram *> *programs, SRGProgram *nextParentProgram)
{
    if (! programs) {
        return nil;
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@keypath(SRGProgram.new, startDate) ascending:YES];
    NSArray<SRGProgram *> *sortedPrograms = [programs sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray<SRGProgram *> *sanitizedPrograms = [NSMutableArray array];
    NSUInteger numberOfPrograms = sortedPrograms.count;
    for (NSUInteger i = 0; i < numberOfPrograms; ++i) {
        SRGProgram *program = sortedPrograms[i].copy;
        SRGProgram *nextProgram = (i < numberOfPrograms - 1) ? sortedPrograms[i + 1] : nil;
        if (nextProgram) {
            program.endDate = nextProgram.startDate;
        }
        else if (nextParentProgram) {
            program.endDate = nextParentProgram.startDate;
        }
        program.subprograms = SRGSanitizedProgramsAndSubprograms(program.subprograms, nextProgram);
        [sanitizedPrograms addObject:program];
    }
    return sanitizedPrograms.copy;
}

NSArray<SRGProgram *> *SRGSanitizedPrograms(NSArray<SRGProgram *> *programs)
{
    return SRGSanitizedProgramsAndSubprograms(programs, nil);
}
