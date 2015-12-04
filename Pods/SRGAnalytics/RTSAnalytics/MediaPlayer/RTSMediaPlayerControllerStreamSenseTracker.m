//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAnalytics.h"

#import "RTSMediaPlayerControllerStreamSenseTracker_private.h"
#import "RTSAnalyticsLogger.h"
#import "RTSAnalyticsVersion_private.h"
#import "RTSMediaSegment.h"

#import <comScore-iOS-SDK-RTS/CSStreamSense.h>
#import <comScore-iOS-SDK-RTS/CSStreamSensePlaylist.h>
#import <comScore-iOS-SDK-RTS/CSStreamSenseClip.h>

#import <SRGMediaPlayer/RTSMediaPlayerView.h>
#import <SRGMediaPlayer/RTSMediaPlayerVersion.h>

static NSString * const LoggerDomainAnalyticsStreamSense = @"StreamSense";

@interface RTSMediaPlayerControllerStreamSenseTracker ()

@property (nonatomic, strong) RTSMediaPlayerController *mediaPlayerController;
@property (nonatomic, weak) id<RTSAnalyticsMediaPlayerDataSource> dataSource;

@end

@implementation RTSMediaPlayerControllerStreamSenseTracker

- (void)dealloc
{
	_mediaPlayerController = nil;
}

- (id)initWithPlayer:(RTSMediaPlayerController *)mediaPlayerController
          dataSource:(id<RTSAnalyticsMediaPlayerDataSource>)dataSource
         virtualSite:(NSString *)virtualSite
{
    NSParameterAssert(mediaPlayerController);
    NSParameterAssert(dataSource);
    NSParameterAssert(virtualSite);

    if(!(self = [super init])) {
	   return nil;
    }
	
	_mediaPlayerController = mediaPlayerController;
	_dataSource = dataSource;
	
	[self setLabel:@"ns_st_mp" value:@"SRGMediaPlayer"];
	[self setLabel:@"ns_st_pu" value:RTSAnalyticsVersion()];
	[self setLabel:@"ns_st_mv" value:RTSMediaPlayerVersion()];
	[self setLabel:@"ns_st_it" value:@"c"];
	
	[self setLabel:@"ns_vsite" value:virtualSite];
	[self setLabel:@"srg_ptype" value:@"p_app_ios"];
	
	RTSAnalyticsLogVerbose(@"%@ : new Streamsense instance with ns_vsite = %@", LoggerDomainAnalyticsStreamSense, self.labels[@"ns_vsite"]);

	return self;
}

- (void)notify:(CSStreamSenseEventType)playerEvent withSegment:(id<RTSMediaSegment>)segment customLabels:(NSDictionary *)customLabels
{
    [self updateLabelsWithSegment:segment customLabels:customLabels];
    
    if (segment && playerEvent == CSStreamSensePlay) {
        [self notify:playerEvent position:CMTimeGetSeconds(segment.timeRange.start) * 1000. labels:nil];
    }
    else {
        [self notify:playerEvent position:[self currentPositionInMilliseconds] labels:nil];
    }
}

#pragma mark - CSStreamSensePluginProtocol

- (long)currentPositionInMilliseconds
{
	CMTime currentTime = [self.mediaPlayerController.player.currentItem currentTime];
    if (CMTIME_IS_INDEFINITE(currentTime)) {
        return 0.0;
    }
	return (long) floor(CMTimeGetSeconds(currentTime) * 1000);
}

#pragma mark - Private Labels methods

- (void)updateLabelsWithSegment:(id<RTSMediaSegment>)segment customLabels:(NSDictionary *)customLabels
{
	// Labels
	[self setLabel:@"ns_st_br" value:[self bitRate]];
	[self setLabel:@"ns_st_ws" value:[self windowState]];
	[self setLabel:@"ns_st_vo" value:[self volume]];
	[self setLabel:@"ns_st_sg" value:[self scalingMode]];
	[self setLabel:@"ns_ap_ot" value:[self orientation]];
	[self setLabel:@"ns_st_airplay" value:[self airplay]];
	
	NSURL *contentURL = [self contentURL];
    if (contentURL) {
        [self setLabel:@"ns_st_cu" value:contentURL.absoluteString];
    }
	
	// Clips
	NSString *dimensions = [self dimensions];
    if (dimensions) {
		[[self clip] setLabel:@"ns_st_cs" value:dimensions];
    }
    else {
        [[[self clip] labels] removeObjectForKey:@"ns_st_cs"];
    }
		
	NSString *liveStream = [self liveStream];
    if (liveStream) {
		[[self clip] setLabel:@"ns_st_li" value:liveStream];
    }
    else {
        [[[self clip] labels] removeObjectForKey:@"ns_st_li"];
    }
    
	NSString *srg_enc = [self srg_enc];
    if (srg_enc) {
		[[self clip] setLabel:@"srg_enc" value:srg_enc];
    }
    else {
        [[[self clip] labels] removeObjectForKey:@"srg_enc"];
    }
    
    NSString *timeshift = [self timeshiftFromLiveInMilliseconds];
    if (timeshift) {
        [[self clip] setLabel:@"srg_timeshift" value:timeshift];
    }
    else {
        [[[self clip] labels] removeObjectForKey:@"srg_timeshift"];
    }
    
    if (self.mediaPlayerController.pictureInPictureController.pictureInPictureActive) {
        [[self clip] setLabel:@"srg_screen_type" value:@"pip"];
    }
    else if (self.mediaPlayerController.player.isExternalPlaybackActive) {
        [[self clip] setLabel:@"srg_screen_type" value:@"airplay"];
    }
    else {
        [[self clip] setLabel:@"srg_screen_type" value:@"default"];
    }
	
	// Playlist
	if ([self.dataSource respondsToSelector:@selector(streamSensePlaylistMetadataForIdentifier:)]) {
		NSDictionary *dataSourcePlaylist = [self.dataSource streamSensePlaylistMetadataForIdentifier:self.mediaPlayerController.identifier];
		[dataSourcePlaylist enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			[[self playlist] setLabel:key value:obj];
		}];
	}
	
	// Clips
	if ([self.dataSource respondsToSelector:@selector(streamSenseClipMetadataForIdentifier:withSegment:)]) {
		NSDictionary *dataSourceClip = [self.dataSource streamSenseClipMetadataForIdentifier:self.mediaPlayerController.identifier
                                                                                 withSegment:segment];
        
		[dataSourceClip enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			[[self clip] setLabel:key value:obj];
		}];
	}
    
    [customLabels enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull label, NSString *  _Nonnull value, BOOL * _Nonnull stop) {
        [[self clip] setLabel:label value:value];
    }];
}

#pragma mark - Private helper methods

- (NSString *)bitRate
{
	AVPlayerItem *currentItem = self.mediaPlayerController.player.currentItem;
	if (currentItem) {
		NSArray *events = currentItem.accessLog.events;
		if (events.lastObject) {
			double observedBitrate = [events.lastObject observedBitrate];
			return [@(observedBitrate) stringValue];
		}
	}
	return nil;
}

- (NSString *)windowState
{
	AVPlayerLayer *playerLayer = [(RTSMediaPlayerView *)self.mediaPlayerController.view playerLayer];
	CGSize size = playerLayer.videoRect.size;
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	return round(size.width) == round(screenRect.size.width) && round(size.height) == round(screenRect.size.height)  ? @"full" : @"norm";
}

- (NSString *)volume
{
    if (self.mediaPlayerController.player && self.mediaPlayerController.player.isMuted) {
		return @"0";
    }
	
    if (![[AVAudioSession sharedInstance] respondsToSelector:@selector(outputVolume)]) {
		return @"0";
    }
	
	id instance = [AVAudioSession sharedInstance];
	IMP outputVolumeImp = [instance methodForSelector:@selector(outputVolume)];
	float volume = ((float (*) (id,SEL))outputVolumeImp)(instance,@selector(outputVolume));
	return [NSString stringWithFormat:@"%d", (int) (volume * 100)];
}

- (NSString *)scalingMode
{
	AVPlayerLayer *playerLayer = [(RTSMediaPlayerView *)self.mediaPlayerController.view playerLayer];
	
	NSString *result = @"no";
	if (playerLayer) {
        if ([playerLayer.videoGravity isEqualToString:@"AVLayerVideoGravityResize"]) {
			result = @"fill";
        }
        else if ([playerLayer.videoGravity isEqualToString:@"AVLayerVideoGravityResizeAspect"]) {
			result = @"fit-a";
        }
        else if ([playerLayer.videoGravity isEqualToString:@"AVLayerVideoGravityResizeAspectFill"]) {
			result = @"fill-a";
        }
	}
	return result;
}

- (NSString *) orientation {
	NSString *result = NULL;
	UIDeviceOrientation orient = [[UIDevice currentDevice] orientation];
	switch (orient) {
		case UIDeviceOrientationFaceDown:
			result = @"facedown";
			break;
		case UIDeviceOrientationFaceUp:
			result = @"faceup";
			break;
		case UIDeviceOrientationPortrait:
			result = @"pt";
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			result = @"updown";
			break;
		case UIDeviceOrientationLandscapeLeft:
			result = @"left";
			break;
		case UIDeviceOrientationLandscapeRight:
			result = @"right";
			break;
		default:
			break;
	}
	return result;
}

- (NSString *) airplay
{
	return self.mediaPlayerController.player.isExternalPlaybackActive ? @"1" : @"0";
}

// As requested by Markus Gubler, do not even send a "0" when it is not live stream.
- (NSString *)liveStream
{
    return (self.mediaPlayerController.streamType == RTSMediaStreamTypeLive || self.mediaPlayerController.streamType == RTSMediaStreamTypeDVR) ? @"1" : nil;
}

- (NSString *) dimensions
{
	AVPlayerLayer *playerLayer = [(RTSMediaPlayerView *)self.mediaPlayerController.view playerLayer];
	if (!playerLayer)
		return nil;
	
	CGSize size = playerLayer.videoRect.size;
	return [NSString stringWithFormat:@"%0.0fx%0.0f", size.width, size.height];
}

- (NSString *)timeshiftFromLiveInMilliseconds
{
    if (self.mediaPlayerController.streamType == RTSMediaStreamTypeDVR) {
        CMTime timeShift = CMTimeSubtract(CMTimeRangeGetEnd(self.mediaPlayerController.timeRange), self.mediaPlayerController.playerItem.currentTime);
        NSInteger timeShiftInSeconds = (NSInteger)fabs(CMTimeGetSeconds(timeShift));
        
        // Consider offsets smaller than the tolerance to be equivalent to live conditions, sending 0 instead of the real offset
        if (timeShiftInSeconds <= RTSMediaLiveTolerance) {
            return @"0";
        }
        else {
            return [NSString stringWithFormat:@"%@", @(timeShiftInSeconds * 1000)];
        }
    }
    else if (self.mediaPlayerController.streamType == RTSMediaStreamTypeLive) {
        return @"0";
    }
    return nil;
}

- (NSURL *)contentURL
{
	AVAsset *asset = self.mediaPlayerController.player.currentItem.asset;
	if ([asset isKindOfClass:[AVURLAsset class]]) {
		NSURL *assetURL = [(AVURLAsset *)asset URL];
		NSURL *newURL = [[NSURL alloc] initWithScheme:assetURL.scheme host:assetURL.host path:assetURL.path.length > 0 ? assetURL.path: @"/" ];
		return newURL;
	}
	return nil;
}

- (NSString *)srg_enc
{
	// Add 'Encoder' value (live only):
	NSURL *contentURL = [self contentURL];
	NSString *liveStream = [self liveStream];
	if (contentURL.path.length > 0 && [liveStream isEqualToString:@"1"]) {
		NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"enc(\\d+)" options:0 error:nil];
		NSTextCheckingResult *firstMatch = [re firstMatchInString:contentURL.path options:0 range:NSMakeRange(0, contentURL.path.length)];
		
		if (firstMatch.range.location != NSNotFound)
			return [contentURL.path substringWithRange:[firstMatch rangeAtIndex:1]];
	}
	
	return nil;
}

@end
