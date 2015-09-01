//
//  Created by Cédric Luthi on 26.08.14.
//  Copyright (c) 2014 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  -------------------
 *  @name Notifications
 *  -------------------
 */

/**
 *  The `object` is the `NSURLRequest` that was sent to comScore.
 *  The `userInfo` contains the `ComScoreRequestSuccessUserInfoKey` which is a BOOL NSNumber indicating if the request succeeded or failed.
 *  The `userInfo` also contains the `ComScoreRequestLabelsUserInfoKey` which is a NSDictionary representing all the labels.
 */
FOUNDATION_EXTERN NSString * const RTSAnalyticsComScoreRequestDidFinishNotification;
FOUNDATION_EXTERN NSString * const RTSAnalyticsComScoreRequestSuccessUserInfoKey;
FOUNDATION_EXTERN NSString * const RTSAnalyticsComScoreRequestLabelsUserInfoKey;
