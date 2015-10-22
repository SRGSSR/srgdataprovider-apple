//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "RTSAnalyticsTracker.h"
#import "RTSMediaPlayerControllerTracker_private.h"
#import "RTSAnalyticsLogger.h"
#import "RTSMediaPlayerControllerTrackingInfo.h"

#import <SRGMediaPlayer/RTSMediaPlayerController.h>
#import <SRGMediaPlayer/RTSMediaSegmentsController.h>
#import "RTSMediaPlayerControllerStreamSenseTracker_private.h"

#import <comScore-iOS-SDK-RTS/CSComScore.h>

@interface RTSMediaPlayerControllerTracker ()

@property (nonatomic, weak) id<RTSAnalyticsMediaPlayerDataSource> dataSource;
@property (nonatomic, weak) id<RTSAnalyticsMediaPlayerDelegate> mediaPlayerDelegate;

@property (nonatomic, strong) NSMutableDictionary *trackingInfos;

@property (nonatomic, strong) NSMutableDictionary *streamsenseTrackers;
@property (nonatomic, strong) NSString *virtualSite;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RTSMediaPlayerControllerTracker

+ (instancetype) sharedTracker
{
	static RTSMediaPlayerControllerTracker *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[[self class] alloc] init_custom_RTSMediaPlayerControllerTracker];
	});
	return sharedInstance;
}

- (id)init_custom_RTSMediaPlayerControllerTracker
{
	if (!(self = [super init]))
		return nil;
	
	_streamsenseTrackers = [NSMutableDictionary new];
    _trackingInfos = [NSMutableDictionary new];
    
    // Periodically update labels so that heartbeats get correct timestamps during playback
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(updateLabels:) userInfo:nil repeats:YES];
	
	return self;
}

- (void)dealloc
{
    self.timer = nil;
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTimer:(NSTimer *)timer
{
    if (_timer) {
        [_timer invalidate];
    }
    
    _timer = timer;
}

- (void)startStreamMeasurementForVirtualSite:(NSString *)virtualSite mediaDataSource:(id<RTSAnalyticsMediaPlayerDataSource>)dataSource
{
    NSParameterAssert(virtualSite && dataSource);
    
    if (!_dataSource && !_virtualSite) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mediaPlayerPlaybackStateDidChange:)
                                                     name:RTSMediaPlayerPlaybackStateDidChangeNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mediaPlayerPlaybackSegmentsDidChange:)
                                                     name:RTSMediaPlaybackSegmentDidChangeNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mediaPlayerPlaybackDidFail:)
                                                     name:RTSMediaPlayerPlaybackDidFailNotification
                                                   object:nil];
    }
    
    _dataSource = dataSource;
    _virtualSite = virtualSite;
}

- (BOOL)shouldTrackMediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
{
	BOOL track = YES;
    if ([self.mediaPlayerDelegate respondsToSelector:@selector(shouldTrackMediaWithIdentifier:)]) {
		track = [self.mediaPlayerDelegate shouldTrackMediaWithIdentifier:mediaPlayerController.identifier];
    }
	return track;
}


#pragma mark - Notifications

- (void)mediaPlayerPlaybackStateDidChange:(NSNotification *)notification
{
	if (!_dataSource) {
		// We haven't started yet.
		return;
	}
	
	RTSMediaPlayerController *mediaPlayerController = notification.object;
    RTSMediaPlayerControllerTrackingInfo *trackingInfo = [self trackingInfoForMediaPlayerController:mediaPlayerController];
    
	if ([self shouldTrackMediaPlayerController:mediaPlayerController]) {
		switch (mediaPlayerController.playbackState) {
			case RTSMediaPlaybackStatePreparing:
				[self notifyStreamTrackerEvent:CSStreamSenseBuffer
                                   mediaPlayer:mediaPlayerController
                                       segment:trackingInfo.currentSegment];
				break;
				
			case RTSMediaPlaybackStateReady:
                [self notifyComScoreOfReadyToPlayEvent:mediaPlayerController];
				break;
				
			case RTSMediaPlaybackStateStalled:
				[self notifyStreamTrackerEvent:CSStreamSenseBuffer
                                   mediaPlayer:mediaPlayerController
                                       segment:trackingInfo.currentSegment];
				break;
				
			case RTSMediaPlaybackStatePlaying:
                if (! trackingInfo.currentSegment || ! trackingInfo.skippingNextEvents) {
                    [self notifyStreamTrackerEvent:CSStreamSensePlay
                                       mediaPlayer:mediaPlayerController
                                           segment:trackingInfo.currentSegment];
                }
                trackingInfo.skippingNextEvents = NO;
				break;
                
            case RTSMediaPlaybackStateSeeking:
                if (! trackingInfo.currentSegment) {
                    [self notifyStreamTrackerEvent:CSStreamSensePause
                                       mediaPlayer:mediaPlayerController
                                           segment:nil];
                }
                break;
                
			case RTSMediaPlaybackStatePaused:
                if (! trackingInfo.skippingNextEvents) {
                    [self notifyStreamTrackerEvent:CSStreamSensePause
                                       mediaPlayer:mediaPlayerController
                                           segment:trackingInfo.currentSegment];
                }
				break;
				
			case RTSMediaPlaybackStateEnded:
				[self notifyStreamTrackerEvent:CSStreamSenseEnd
                                   mediaPlayer:mediaPlayerController
                                       segment:trackingInfo.currentSegment];
				break;
				
			case RTSMediaPlaybackStateIdle:
				[self stopTrackingMediaPlayerController:mediaPlayerController];
				break;
		}
	}
	else if (self.streamsenseTrackers[mediaPlayerController.identifier]) {
		[self stopTrackingMediaPlayerController:mediaPlayerController];
	}
}

- (void)mediaPlayerPlaybackSegmentsDidChange:(NSNotification *)notification
{
    RTSMediaSegmentsController *segmentsController = notification.object;
    RTSMediaPlayerController *mediaPlayerController = segmentsController.playerController;
    if (![self shouldTrackMediaPlayerController:mediaPlayerController]) {
        return;
    }
    
    RTSMediaPlayerControllerTrackingInfo *trackingInfo = [self trackingInfoForMediaPlayerController:mediaPlayerController];
    if (!trackingInfo) {
        return;
    }
    
    NSInteger value = [notification.userInfo[RTSMediaPlaybackSegmentChangeValueInfoKey] integerValue];
    BOOL wasUserSelected = [notification.userInfo[RTSMediaPlaybackSegmentChangeUserSelectInfoKey] boolValue];
    
    id<RTSMediaSegment> previousSegment = trackingInfo.currentSegment;
    id<RTSMediaSegment> segment = notification.userInfo[RTSMediaPlaybackSegmentChangeSegmentInfoKey];
    trackingInfo.currentSegment = (wasUserSelected ? segment : nil);
    
    // According to its implementation, Comscore only sends an event if different from the previously sent one. We
    // are therefore required to send a pause followed by a play when a segment end is detected (in which case
    // playback continues with another segment or with the full-length). Segment information is sent only if the
    // segment was selected by the user
    switch (value) {
        case RTSMediaPlaybackSegmentStart: {
            if (wasUserSelected) {
                [self notifyStreamTrackerEvent:CSStreamSensePause
                                   mediaPlayer:segmentsController.playerController
                                       segment:previousSegment];
                [self notifyStreamTrackerEvent:CSStreamSensePlay
                                   mediaPlayer:segmentsController.playerController
                                       segment:segment];
                
                
                trackingInfo.skippingNextEvents = YES;
            }
            break;
        }
            
        case RTSMediaPlaybackSegmentSwitch: {
            if (wasUserSelected || previousSegment) {
                [self notifyStreamTrackerEvent:CSStreamSensePause
                                   mediaPlayer:segmentsController.playerController
                                       segment:previousSegment];
                [self notifyStreamTrackerEvent:CSStreamSensePlay
                                   mediaPlayer:segmentsController.playerController
                                       segment:(wasUserSelected ? segment : nil)];
            }
            break;
        }
            
        case RTSMediaPlaybackSegmentEnd: {
            if (previousSegment) {
                [self notifyStreamTrackerEvent:CSStreamSensePause
                                   mediaPlayer:segmentsController.playerController
                                       segment:previousSegment];
                [self notifyStreamTrackerEvent:CSStreamSensePlay
                                   mediaPlayer:segmentsController.playerController
                                       segment:nil];
            }
            break;
        }
            
        default:
            break;
    }
}


- (void)mediaPlayerPlaybackDidFail:(NSNotification *)notification
{
	RTSMediaPlayerController *mediaPlayerController = notification.object;
    if ([self shouldTrackMediaPlayerController:mediaPlayerController]) {
		[self stopTrackingMediaPlayerController:mediaPlayerController];
    }
}

#pragma mark - Tracking information

- (RTSMediaPlayerControllerTrackingInfo *)trackingInfoForMediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
{
    if (!mediaPlayerController) {
        return nil;
    }
    
    RTSMediaPlayerControllerTrackingInfo *trackingInfo = self.trackingInfos[mediaPlayerController.identifier];
    if (!trackingInfo) {
        trackingInfo = [RTSMediaPlayerControllerTrackingInfo new];
        self.trackingInfos[mediaPlayerController.identifier] = trackingInfo;
    }
    return trackingInfo;
}

- (void)discardTrackingInfoForMediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
{
    [self.trackingInfos removeObjectForKey:mediaPlayerController.identifier];
}


#pragma mark - Stream tracking

- (void)trackMediaPlayerFromPresentingViewController:(id<RTSAnalyticsMediaPlayerDelegate>)mediaPlayerDelegate
{
	_mediaPlayerDelegate = mediaPlayerDelegate;
}

- (void)startTrackingMediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
{
	[self notifyStreamTrackerEvent:CSStreamSensePlay
                       mediaPlayer:mediaPlayerController
                           segment:nil];
}

- (void)stopTrackingMediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
{
    if (![self.streamsenseTrackers.allKeys containsObject:mediaPlayerController.identifier]) {
		return;
    }
	
    [self discardTrackingInfoForMediaPlayerController:mediaPlayerController];
	[self notifyStreamTrackerEvent:CSStreamSenseEnd
                       mediaPlayer:mediaPlayerController
                           segment:nil];
    
	[CSComScore onUxInactive];
    
	RTSAnalyticsLogVerbose(@"Delete stream tracker for media identifier `%@`", mediaPlayerController.identifier);
	[self.streamsenseTrackers removeObjectForKey:mediaPlayerController.identifier];	
}

- (void)notifyStreamTrackerEvent:(CSStreamSenseEventType)eventType
                     mediaPlayer:(RTSMediaPlayerController *)mediaPlayerController
                         segment:(id<RTSMediaSegment>)segment
{
	RTSMediaPlayerControllerStreamSenseTracker *tracker = self.streamsenseTrackers[mediaPlayerController.identifier];
	if (!tracker) {
		RTSAnalyticsLogVerbose(@"Create a new stream tracker for media identifier `%@`", mediaPlayerController.identifier);
		
		tracker = [[RTSMediaPlayerControllerStreamSenseTracker alloc] initWithPlayer:mediaPlayerController
                                                                          dataSource:self.dataSource
                                                                         virtualSite:self.virtualSite];
        
		self.streamsenseTrackers[mediaPlayerController.identifier] = tracker;
		[CSComScore onUxActive];
	}
	
    RTSAnalyticsLogVerbose(@"Notify stream tracker event %@ for media identifier `%@`", @(eventType), mediaPlayerController.identifier);
    [tracker notify:eventType withSegment:segment];
}

- (void)notifyComScoreOfReadyToPlayEvent:(RTSMediaPlayerController *)mediaPlayerController
{
    if ([self.dataSource respondsToSelector:@selector(comScoreReadyToPlayLabelsForIdentifier:)]) {
        NSDictionary *labels = [self.dataSource comScoreReadyToPlayLabelsForIdentifier:mediaPlayerController.identifier];
        if (labels) {
            RTSAnalyticsLogVerbose(@"Notify comScore view event for media identifier `%@`", mediaPlayerController.identifier);
            [CSComScore viewWithLabels:labels];
        }
    }
}

#pragma mark - Timer

- (void)updateLabels:(NSTimer *)timer
{
    for (NSValue *key in [self.streamsenseTrackers allKeys]) {
        RTSMediaPlayerControllerTrackingInfo *trackingInfo = self.trackingInfos[key];
        if (!trackingInfo) {
            continue;
        }
        
        RTSMediaPlayerControllerStreamSenseTracker *tracker = self.streamsenseTrackers[key];
        [tracker updateLabelsWithSegment:trackingInfo.currentSegment];
    }
}

@end
