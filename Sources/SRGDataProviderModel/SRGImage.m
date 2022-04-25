//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImage.h"

@interface SRGImage ()

@property (nonatomic) NSURL *URL;
@property (nonatomic) SRGImageVariant variant;

@end

@implementation SRGImage

#pragma mark Class methods

+ (SRGImage *)imageWithURL:(NSURL *)URL variant:(SRGImageVariant)variant
{
    return [[self.class alloc] initWithURL:URL variant:variant];
}

#pragma mark Object lifecycle

- (instancetype)initWithURL:(NSURL *)URL variant:(SRGImageVariant)variant
{
    if (! URL) {
        return nil;
    }
    
    if (self = [super init]) {
        self.URL = URL;
        self.variant = variant;
    }
    return self;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; URL = %@",
            self.class,
            self,
            self.URL];
}

@end
