//
//  Copyright (c) RTS. All rights reserved.
//
//  Licence information is available from the LICENCE file.
//

#import <UIKit/UIKit.h>

/**
 *  Templates for various player icons
 */
@interface RTSMediaPlayerIconTemplate : NSObject

/**
 *  Play image
 *
 *  @param size  The desired image size
 *  @param color The desired tint color
 */
+ (UIImage *) playImageWithSize:(CGSize)size color:(UIColor *)color;

/**
 *  Pause image
 *
 *  @param size  The desired image size
 *  @param color The desired tint color
 */
+ (UIImage *) pauseImageWithSize:(CGSize)size color:(UIColor *)color;

@end
