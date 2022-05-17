//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGProgramComposition.h"

#import "SRGProgram+Private.h"
#import "SRGJSONTransformers.h"

@import libextobjc;

static void SRGProgramCompositionAssignUidToProgram(SRGProgram *program, SRGChannel *channel)
{
    NSString *startDateString = [SRGISO8601DateJSONTransformer() reverseTransformedValue:program.startDate];
    NSString *endDateString = [SRGISO8601DateJSONTransformer() reverseTransformedValue:program.endDate];
    program.uid = [NSString stringWithFormat:@"%@-%@-%@-%@-%@", channel.URN, program.title, program.subtitle, startDateString, endDateString];
    
    [program.subprograms enumerateObjectsUsingBlock:^(SRGProgram * _Nonnull subprogram, NSUInteger idx, BOOL * _Nonnull stop) {
        SRGProgramCompositionAssignUidToProgram(subprogram, channel);
    }];
}

@interface SRGProgramComposition ()

@property (nonatomic) SRGChannel *channel;
@property (nonatomic) NSArray<SRGProgram *> *programs;

@end

@implementation SRGProgramComposition

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{
            @keypath(SRGProgramComposition.new, channel) : @"channel",
            @keypath(SRGProgramComposition.new, programs) : @"programList"
        };
    });
    return s_mapping;
}

#pragma mark Object lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    if (self = [super initWithDictionary:dictionaryValue error:error]) {
        [self.programs enumerateObjectsUsingBlock:^(SRGProgram * _Nonnull program, NSUInteger idx, BOOL * _Nonnull stop) {
            SRGProgramCompositionAssignUidToProgram(program, _channel);
        }];
    }
    return self;
}

#pragma mark Transformers

+ (NSValueTransformer *)channelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGChannel.class];
}

+ (NSValueTransformer *)programsJSONTransformer
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *JSONArray, BOOL *pSuccess, NSError *__autoreleasing *error) {
            NSArray<SRGProgram *> *programs = [MTLJSONAdapter modelsOfClass:SRGProgram.class fromJSONArray:JSONArray error:error];
            if (! programs) {
                return nil;
            }
            
            return SRGSanitizedPrograms(programs);
        } reverseBlock:^id(NSArray *objects, BOOL *pSuccess, NSError *__autoreleasing *error) {
            return [MTLJSONAdapter JSONArrayFromModels:objects error:error];
        }];
    });
    return s_transformer;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGProgramComposition *otherProgramComposition = object;
    return [self.channel.uid isEqual:otherProgramComposition.channel.uid];
}

- (NSUInteger)hash
{
    return self.channel.uid.hash;
}

@end
