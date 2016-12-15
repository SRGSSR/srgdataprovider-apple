//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "RTSMediaPlayerPlaybackButton.h"

#import "RTSMediaPlayerController.h"
#import "RTSMediaPlayerIconTemplate.h"
#import "NSBundle+RTSMediaPlayer.h"

NSString * RTSMediaPlaybackButtonGoToLiveAccessibilityLabel = nil;
NSString * RTSMediaPlaybackButtonBackwardAccessibilityLabelFormat = nil;
NSString * RTSMediaPlaybackButtonForwardAccessibilityLabelFormat = nil;

@implementation RTSMediaPlayerPlaybackButton

- (void)initialize
{
	RTSMediaPlaybackButtonGoToLiveAccessibilityLabel = SRGMediaPlayerAccessibityLocalizedString(@"Go to live", @"A go to live button");
	RTSMediaPlaybackButtonBackwardAccessibilityLabelFormat = SRGMediaPlayerAccessibityLocalizedString(@"%@ backward", @"A seek backward button");
	RTSMediaPlaybackButtonForwardAccessibilityLabelFormat = SRGMediaPlayerAccessibityLocalizedString(@"%@ forward", @"A seek forward button");
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setMediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
{
	if (_mediaPlayerController) {
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:RTSMediaPlayerPlaybackStateDidChangeNotification
													  object:_mediaPlayerController];
	}
	
	_mediaPlayerController = mediaPlayerController;
	[self refreshButton];

	if (mediaPlayerController) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(mediaPlayerPlaybackStateDidChange:)
													 name:RTSMediaPlayerPlaybackStateDidChangeNotification
												   object:mediaPlayerController];
	}
}

- (void)mediaPlayerPlaybackStateDidChange:(NSNotification *)notification
{
	[self refreshButton];
}

- (BOOL)hasStopButton
{
    return (self.behavior == RTSMediaPlayerPlaybackButtonBehaviorStopForLiveOnly && self.mediaPlayerController.streamType == RTSMediaStreamTypeLive)
        || self.behavior == RTSMediaPlayerPlaybackButtonBehaviorStopForAll;
}

- (void)play
{
	[self.mediaPlayerController play];
	[self refreshButton];
}

- (void)pause
{
	if ([self hasStopButton]) {
		[self.mediaPlayerController reset];
	}
	else {
		[self.mediaPlayerController pause];
	}
	[self refreshButton];
}

- (void)refreshButton
{
	BOOL isPlaying = self.mediaPlayerController.playbackState == RTSMediaPlaybackStatePlaying;
	SEL action = isPlaying ? @selector(pause) : @selector(play);

	[self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
	[self addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

	UIImage *normalImage = nil;
	UIImage *highlightedImage = nil;
	if (isPlaying) {
		if ([self hasStopButton]) {
            normalImage = self.stopImage ?: [RTSMediaPlayerIconTemplate stopImageWithSize:self.bounds.size color:self.normalColor];
            highlightedImage = self.stopImage ?: [RTSMediaPlayerIconTemplate stopImageWithSize:self.bounds.size color:self.hightlightColor];
            self.accessibilityLabel = SRGMediaPlayerAccessibityLocalizedString(@"Stop", @"Stop state of the Play/Pause/Stop button");
		}
		else {
            normalImage = self.pauseImage ?: [RTSMediaPlayerIconTemplate pauseImageWithSize:self.bounds.size color:self.normalColor];
            highlightedImage = self.pauseImage ?: [RTSMediaPlayerIconTemplate pauseImageWithSize:self.bounds.size color:self.hightlightColor];
            self.accessibilityLabel = SRGMediaPlayerAccessibityLocalizedString(@"Pause", @"Pause state of the Play/Pause/Stop button");
		}
	}
	else {
        normalImage = self.playImage ?: [RTSMediaPlayerIconTemplate playImageWithSize:self.bounds.size color:self.normalColor];
        highlightedImage = self.playImage ?: [RTSMediaPlayerIconTemplate playImageWithSize:self.bounds.size color:self.hightlightColor];
        self.accessibilityLabel = SRGMediaPlayerAccessibityLocalizedString(@"Play", @"Play state of the Play/Pause/Stop button");
	}
	[self setImage:normalImage forState:UIControlStateNormal];
	[self setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setPlayImage:(UIImage *)playImage
{
    _playImage = playImage;
    [self refreshButton];
}

- (void)setPauseImage:(UIImage *)pauseImage
{
    _pauseImage = pauseImage;
    [self refreshButton];
}

- (void)setStopImage:(UIImage *)stopImage
{
    _stopImage = stopImage;
    [self refreshButton];
}

- (void)setBounds:(CGRect)bounds
{
	[super setBounds:bounds];
	[self refreshButton];
}

- (void)setNormalColor:(UIColor *)normalColor
{
	_normalColor = normalColor;
	[self refreshButton];
}

- (void)setHightlightColor:(UIColor *)hightlightColor
{
	_hightlightColor = hightlightColor;
	[self refreshButton];
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self refreshButton];
}

@end
