//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

@import UIKit;

SRGProduct const SRGProductPlayVideo = @"PLAY_VIDEO";
SRGProduct const SRGProductPlayAudio = @"PLAY_AUDIO";
SRGProduct const SRGProductNewsApp = @"NEWS_APP";
SRGProduct const SRGProductNewsVideo = @"NEWS_VIDEO";
SRGProduct const SRGProductNewsAudio = @"NEWS_AUDIO";

static SRGImageWidth SRGDefaultImageWidthForSize(SRGImageSize size)
{
    static NSDictionary<NSNumber *, NSNumber *> *s_widths;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
#if TARGET_OS_IOS
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            s_widths = @{
                @(SRGImageSizeSmall) : @(SRGImageWidth320),
                @(SRGImageSizeMedium) : @(SRGImageWidth640),
                @(SRGImageSizeLarge) : @(SRGImageWidth960)
            };
        }
        else {
            s_widths = @{
                @(SRGImageSizeSmall) : @(SRGImageWidth320),
                @(SRGImageSizeMedium) : @(SRGImageWidth960),
                @(SRGImageSizeLarge) : @(SRGImageWidth1920)
            };
        }
#else
        s_widths = @{
            @(SRGImageSizeSmall) : @(SRGImageWidth640),
            @(SRGImageSizeMedium) : @(SRGImageWidth1920),
            @(SRGImageSizeLarge) : @(SRGImageWidth1920)
        };
#endif
    });
    
    return s_widths[@(size)].integerValue;
}

static SRGImageWidth SRGPosterImageWidthForSize(SRGImageSize size)
{
    static NSDictionary<NSNumber *, NSNumber *> *s_widths;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
#if TARGET_OS_IOS
        s_widths = @{
            @(SRGImageSizeSmall) : @(SRGImageWidth320),
            @(SRGImageSizeMedium) : @(SRGImageWidth480),
            @(SRGImageSizeLarge) : @(SRGImageWidth640)
        };
#else
        s_widths = @{
            @(SRGImageSizeSmall) : @(SRGImageWidth480),
            @(SRGImageSizeMedium) : @(SRGImageWidth640),
            @(SRGImageSizeLarge) : @(SRGImageWidth960)
        };
#endif
    });
    return s_widths[@(size)].integerValue;
}

SRGImageWidth SRGRecommendedImageWidth(SRGImageSize size, SRGImageVariant variant)
{
    switch (variant) {
        case SRGImageVariantPoster: {
            return SRGPosterImageWidthForSize(size);
            break;
        }
            
        default: {
            return SRGDefaultImageWidthForSize(size);
            break;
        }
    }
}

CGSize SRGRecommendedImageCGSize(SRGImageSize size, SRGImageVariant variant)
{
    switch (variant) {
        case SRGImageVariantPoster: {
            CGFloat width = SRGPosterImageWidthForSize(size);
            return CGSizeMake(width, width * 3.f / 2.f);
            break;
        }
            
        default: {
            CGFloat width = SRGDefaultImageWidthForSize(size);
            return CGSizeMake(width, width * 9.f / 16.f);
            break;
        }
    }
}
