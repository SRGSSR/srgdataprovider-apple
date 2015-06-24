//
//  SRGAudio.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 02/10/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILAudio.h"

@implementation SRGILAudio

- (SRGILMediaType)type
{
    return SRGILMediaTypeAudio;
}

- (NSURL *)contentURL
{
    return self.MQHLSURL ?: self.MQHTTPURL;
}

@end
