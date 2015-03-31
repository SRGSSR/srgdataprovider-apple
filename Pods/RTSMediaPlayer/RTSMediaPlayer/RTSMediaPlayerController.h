//
//  Created by Cédric Luthi on 25.02.15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <RTSMediaPlayer/RTSMediaPlayerControllerDataSource.h>

/**
 *  ---------------
 *  @name Constants
 *  ---------------
 */

/**
 *  @enum RTSMediaPlaybackState
 *
 *  Enumeration of the possible playback states.
 */
typedef NS_ENUM(NSInteger, RTSMediaPlaybackState) {
	/**
	 *  Default state when controller is initialized
	 */
	RTSMediaPlaybackStateIdle,
	
	/**
	 *  Player is ready to play or buffering media, the AVPlayer object has been loaded
	 */
	RTSMediaPlaybackStatePendingPlay,
	
	/**
	 *  Media is playing
	 */
	RTSMediaPlaybackStatePlaying,
	
	/**
	 *  Media is paused
	 */
	RTSMediaPlaybackStatePaused,
	
	/**
	 *  Ends either when the media's end is reached, if an error occurs or if the user dismiss it's enclosing view controller
	 */
	RTSMediaPlaybackStateEnded
};

/**
 *  @enum RTSMediaFinishReason
 *
 *  Enumeration of the possible finished reasons used by `RTSMediaPlayerPlaybackDidFinishNotification`.
 */
typedef NS_ENUM(NSInteger, RTSMediaFinishReason) {
	/**
	 *  Ended because player reached the end of the media
	 */
	RTSMediaFinishReasonPlaybackEnded,
	
	/**
	 *  Ended due to an error
	 */
	RTSMediaFinishReasonPlaybackError,
	
	/**
	 *  Ended without error and also without reaching the end of the stream
	 */
	RTSMediaFinishReasonUserExited
};

/**
 *  -------------------
 *  @name Notifications
 *  -------------------
 */

/**
 *  Posted when media playback ends or a user exits playback.
 */
FOUNDATION_EXTERN NSString * const RTSMediaPlayerPlaybackDidFinishNotification;
FOUNDATION_EXTERN NSString * const RTSMediaPlayerPlaybackDidFinishReasonUserInfoKey; // NSNumber (RTSMediaFinishReason)
FOUNDATION_EXTERN NSString * const RTSMediaPlayerPlaybackDidFinishErrorUserInfoKey; // NSError

/**
 *  Posted when the playback state changes, either programatically or by the user.
 */
FOUNDATION_EXTERN NSString * const RTSMediaPlayerPlaybackStateDidChangeNotification;

/**
 *  Posted when the currently playing media changes. Used when calling `playIdentifier:`
 */
FOUNDATION_EXTERN NSString * const RTSMediaPlayerNowPlayingMediaDidChangeNotification;

/**
 *  Posted when the AVPlayer instances has been created and is ready to play the media`
 */
FOUNDATION_EXTERN NSString * const RTSMediaPlayerReadyToPlayNotification;

/**
 *  RTSMediaPlayerController is inspired by the MPMoviePlayerController class.
 *  A media player (of type RTSMediaPlayerController) manages the playback of a media from a file or a network stream. You can incorporate a media player’s view into a view hierarchy owned by your app, or use a RTSMediaPlayerViewController object to manage the presentation for you.
 *
 *  The media player controller posts several notifications, see the notifications section.
 *
 *  Errors are handled through the `RTSMediaPlayerPlaybackDidFinishNotification` notification. There are two possible source of errors: either the error comes from the dataSource (see `RTSMediaPlayerControllerDataSource`) or from the network (playback error).
 *
 *  The media player controller manages its overlays visibility. See the `overlayViews` property.
 */
@interface RTSMediaPlayerController : NSObject

/**
 *  --------------------------------------------
 *  @name Initializing a Media Player Controller
 *  --------------------------------------------
 */

/**
*  Returns a RTSMediaPlayerController object initialized with the media at the specified URL.
*
*  @param contentURL The location of the media file. This file must be located either in your app directory or on a remote server.
*
*  @return A media player controller
*/
- (instancetype) initWithContentURL:(NSURL *)contentURL OS_NONNULL_ALL;

/**
 *  Returns a RTSMediaPlayerController object initialized with a datasource and a media identifier.
 *
 *  @param identifier <#identifier description#>
 *  @param dataSource <#dataSource description#>
 *
 *  @return A media player controller
 */
- (instancetype) initWithContentIdentifier:(NSString *)identifier dataSource:(id<RTSMediaPlayerControllerDataSource>)dataSource NS_DESIGNATED_INITIALIZER OS_NONNULL_ALL;

/**
 *  -------------------
 *  @name Player Object
 *  -------------------
 */

/**
 *  The player that provides the media content.
 *
 *  @discussion This can be used for exemple to listen to `addPeriodicTimeObserverForInterval:queue:usingBlock:` or to implement advanced behaviors
 */
@property(readonly) AVPlayer *player;

/**
 *  ------------------------
 *  @name Accessing the View
 *  ------------------------
 */

/**
 *  The view containing the media content.
 *
 *  @discussion This property contains the view used for presenting the media content. To display the view into your own view hierarchy, use the `attachPlayerToView:` method.
 *  This view has two gesture recognziers: a single tap gesture recognizer and a double tap gesture recognizer which respectively toggle overlays visibility and toggle the video of aspect between `AVLayerVideoGravityResizeAspectFill` and `AVLayerVideoGravityResizeAspect`.
 *  If you want to handle taps yourself, you can remove the gesture recognizers from the view and add your own gesture recognizer instead.
 *
 *  @see attachPlayerToView:
 */
@property(readonly) UIView *view;

/**
 *  Attach the player view into specified container view with default autoresizing mask. The player view will have the same frame as its `containerView`
 *
 *  @param containerView The parent view in hierarchy what will contains the player layer
 */
- (void) attachPlayerToView:(UIView *)containerView;

/**
 *  --------------------------------
 *  @name Accessing Media Properties
 *  --------------------------------
 */

/**
 *  <#Description#>
 */
@property (weak) IBOutlet id<RTSMediaPlayerControllerDataSource> dataSource;

/**
 *  Use this identifier to identify the media through notifications
 *
 *  @see initWithContentIdentifier:dataSource:
 */
@property (copy) NSString *identifier;

/**
 *  Returns the current playback state of the media player.
 */
@property (readonly) RTSMediaPlaybackState playbackState;

/**
 *  --------------------------
 *  @name Controlling Playback
 *  --------------------------
 */

/**
 *  Start playing the current media.
 *
 *  @see identifier
 */
- (void) play;

/**
 *  Start playing media specified with its identifier.
 *
 *  @param identifier the identifier of the media to be played.
 *
 *  @discussion the dataSource will be used to determine the URL of the media.
 */
- (void) playIdentifier:(NSString *)identifier;

/**
 *  Pause the currently playing media.
 */
- (void) pause;

/**
 *  Stop playing the current media.
 */
- (void) stop;

/**
 *  Moves the playback cursor to a given time.
 *
 *  @param time The time to which to move the playback cursor.
 */
- (void) seekToTime:(NSTimeInterval)time;

/**
 *  ----------------------------
 *  @name Managing Overlay Views
 *  ----------------------------
 */

/**
 *  A collection of views that will be shown/hidden automatically or manually when user interacts with the view.
 */
@property (copy) IBOutletCollection(UIView) NSArray *overlayViews;

@end
