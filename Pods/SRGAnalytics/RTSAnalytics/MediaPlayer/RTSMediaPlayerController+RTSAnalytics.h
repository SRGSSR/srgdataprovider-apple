//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "RTSMediaPlayerController.h"

@interface RTSMediaPlayerController (RTSAnalytics)

/**
 *  Set whether a stream tracker must be created for the receiver. The default value is YES.
 *
 *  @discussion If the stream tracker is not created yet and the player is already playing, the stream will be automatically
 *              opened. Conversely, any open stream will automatically be closed when tracking is set to NO.
 */
@property (nonatomic, getter=isTracked) BOOL tracked;

@end
