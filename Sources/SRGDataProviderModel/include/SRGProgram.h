//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGCrewMember.h"
#import "SRGImage.h"
#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGShow.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Program information (information about what is currently on air or what will be).
 */
@interface SRGProgram : SRGModel <SRGImageMetadata, SRGMetadata>

/**
 *  Subtitle describing the program further.
 */
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

/**
 *  The date at which the content starts or started.
 */
@property (nonatomic, readonly) NSDate *startDate;

/**
 *  The date at which the content ends.
 */
@property (nonatomic, readonly) NSDate *endDate;

/**
 *  Return the time availability associated with the program at the specified date.
 *
 *  @discussion Time availability is only intended for informative purposes.
 */
- (SRGTimeAvailability)timeAvailabilityAtDate:(NSDate *)date;

/**
 *  The associated image.
 */
@property (nonatomic, readonly) SRGImage *image;

/**
 *  A URL page associated with the content.
 */
@property (nonatomic, readonly, nullable) NSURL *URL;

/**
 *  The show to which the content belongs.
 */
@property (nonatomic, readonly, nullable) SRGShow *show;

/**
 *  Programs contained in the program.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGProgram *> *subprograms;

/**
 *  The URN of the media associated with the program, if any.
 */
@property (nonatomic, readonly, copy, nullable) NSString *mediaURN;

/**
 *  The genre of the program.
 */
@property (nonatomic, readonly, copy, nullable) NSString *genre;

/**
 *  The season number.
 */
@property (nonatomic, readonly, nullable) NSNumber *seasonNumber;

/**
 *  The episode number.
 */
@property (nonatomic, readonly, nullable) NSNumber *episodeNumber;

/**
 *  The number of episodes.
 */
@property (nonatomic, readonly, nullable) NSNumber *numberOfEpisodes;

/**
 *  The production year.
 */
@property (nonatomic, readonly, nullable) NSNumber *productionYear;

/**
 *  The production country (displayable name).
 */
@property (nonatomic, readonly, copy, nullable) NSString *productionCountry;

/**
 *  The youth protection color.
 */
@property (nonatomic, readonly) SRGYouthProtectionColor youthProtectionColor;

/**
 *  The original title.
 */
@property (nonatomic, readonly, copy, nullable) NSString *originalTitle;

/**
 *  Crew members.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGCrewMember *> *crewMembers;

/**
 *  `YES` iff the program is a rebroadcast.
 */
@property (nonatomic, readonly) BOOL isRebroadcast;

/**
 *  A description of the rebroadcast.
 */
@property (nonatomic, readonly, copy, nullable) NSString *rebroadcastDescription;

/**
 *  `YES` iff subtitles are available.
 */
@property (nonatomic, readonly) BOOL subtitlesAvailable;

/**
 *  `YES` iff alternate audio is available.
 */
@property (nonatomic, readonly) BOOL alternateAudioAvailable;

/**
 *  `YES` iff sign language is available.
 */
@property (nonatomic, readonly) BOOL signLanguageAvailable;

/**
 *  `YES` iff audio description is available.
 */
@property (nonatomic, readonly) BOOL audioDescriptionAvailable;

/**
 *  `YES` iff Dolby Digital is available.
 */
@property (nonatomic, readonly) BOOL dolbyDigitalAvailable;

@end

NS_ASSUME_NONNULL_END
