//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSURL+SRGDataProvider.h"

@implementation NSURL (SRGDataProvider)

- (NSURL *)srg_URLForWidth:(SRGImageWidth)width
{
    if (self.fileURL) {
        return self;
    }
    
    NSString *sizeComponent = [NSString stringWithFormat:@"scale/width/%@", @(width)];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    URLComponents.path = [URLComponents.path stringByAppendingPathComponent:sizeComponent];
    return URLComponents.URL;
}

@end
