//
//  Created by Frédéric Humbert-Droz on 10/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  `RTSAnalyticsNetmetrixTracker` is used to track view events for Netmetrix.
 * 
 *  The tracker uses a `AFHTTPClient` to send HTTP GET requests. The destination URL is specified by a domain and appID.
 */
@interface RTSAnalyticsNetmetrixTracker : NSObject

/**
 *  --------------------------------------------
 *  @name Initializing a Netmetrix Tracker
 *  --------------------------------------------
 */

/**
 *  Returns a `RTSAnalyticsNetmetrixTracker` object initialized with the specified appID and Netmetrix domain.
 *
 *  @param appID  a unique id identifying Netmetrics application (by ex.: rts-info, rts-sport, srg-player, ...)
 *  @param domain the nexmetrics domain used  (by ex,: rts, srg, ...)
 *
 *  @discussion The AppID and Netmetrix domain MUST be set ONLY when application is in production !
 *
 *  @return a Netmetrix tracker
 */
- (instancetype) initWithAppID:(NSString *)appID domain:(NSString *)domain;

/**
 *  --------------------------------------------
 *  @name View Tracking
 *  --------------------------------------------
 */

/**
 *  Send a view event for application specified by its AppID and domain.
 */
- (void) trackView;

@end
