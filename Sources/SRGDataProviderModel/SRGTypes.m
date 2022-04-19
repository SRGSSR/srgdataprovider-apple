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

typedef NSString * SRGDeviceScale NS_TYPED_ENUM;

static SRGDeviceScale const SRGDeviceScaleNormal = @"normal";
static SRGDeviceScale const SRGDeviceScaleRetina = @"retina";

static SRGDeviceScale SRGCurrentDeviceScale(void)
{
    return (UIScreen.mainScreen.scale > 1.f) ? SRGDeviceScaleRetina : SRGDeviceScaleNormal;
}

static SRGImageWidth SRGDefaultImageWidthForSize(SRGImageSize size)
{
    static NSDictionary<SRGDeviceScale, NSDictionary<NSNumber *, NSNumber *> *> *s_widths;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
#if TARGET_OS_IOS
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            s_widths = @{
                SRGDeviceScaleNormal : @{
                    @(SRGImageSizeSmall) : @(SRGImageWidth160),
                    @(SRGImageSizeMedium) : @(SRGImageWidth320),
                    @(SRGImageSizeLarge) : @(SRGImageWidth480)
                },
                SRGDeviceScaleRetina : @{
                    @(SRGImageSizeSmall) : @(SRGImageWidth320),
                    @(SRGImageSizeMedium) : @(SRGImageWidth640),
                    @(SRGImageSizeLarge) : @(SRGImageWidth960)
                }
            };
        }
        else {
            s_widths = @{
                SRGDeviceScaleNormal : @{
                    @(SRGImageSizeSmall) : @(SRGImageWidth160),
                    @(SRGImageSizeMedium) : @(SRGImageWidth480),
                    @(SRGImageSizeLarge) : @(SRGImageWidth960)
                },
                SRGDeviceScaleRetina : @{
                    @(SRGImageSizeSmall) : @(SRGImageWidth320),
                    @(SRGImageSizeMedium) : @(SRGImageWidth960),
                    @(SRGImageSizeLarge) : @(SRGImageWidth1920)
                }
            };
        }
#else
        s_widths = @{
            SRGDeviceScaleNormal : @{
                @(SRGImageSizeSmall) : @(SRGImageWidth320),
                @(SRGImageSizeMedium) : @(SRGImageWidth960),
                @(SRGImageSizeLarge) : @(SRGImageWidth1280)
            },
            SRGDeviceScaleRetina : @{
                @(SRGImageSizeSmall) : @(SRGImageWidth640),
                @(SRGImageSizeMedium) : @(SRGImageWidth1920),
                @(SRGImageSizeLarge) : @(SRGImageWidth1920)
            }
        };
#endif
    });
    
    return s_widths[SRGCurrentDeviceScale()][@(size)].integerValue;
}

static SRGImageWidth SRGPosterImageWidthForSize(SRGImageSize size)
{
    static NSDictionary<SRGDeviceScale, NSDictionary<NSNumber *, NSNumber *> *> *s_widths;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
#if TARGET_OS_IOS
        s_widths = @{
            SRGDeviceScaleNormal : @{
                @(SRGImageSizeSmall) : @(SRGImageWidth160),
                @(SRGImageSizeMedium) : @(SRGImageWidth240),
                @(SRGImageSizeLarge) : @(SRGImageWidth320)
            },
            SRGDeviceScaleRetina : @{
                @(SRGImageSizeSmall) : @(SRGImageWidth320),
                @(SRGImageSizeMedium) : @(SRGImageWidth480),
                @(SRGImageSizeLarge) : @(SRGImageWidth640)
            }
        };
#else
        s_widths = @{
            SRGDeviceScaleNormal : @{
                @(SRGImageSizeSmall) : @(SRGImageWidth240),
                @(SRGImageSizeMedium) : @(SRGImageWidth320),
                @(SRGImageSizeLarge) : @(SRGImageWidth480)
            },
            SRGDeviceScaleRetina : @{
                @(SRGImageSizeSmall) : @(SRGImageWidth480),
                @(SRGImageSizeMedium) : @(SRGImageWidth640),
                @(SRGImageSizeLarge) : @(SRGImageWidth960)
            }
        };
#endif
    });
    return s_widths[SRGCurrentDeviceScale()][@(size)].integerValue;
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
