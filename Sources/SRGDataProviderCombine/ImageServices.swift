//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

/**
 *  Image services.
 */
public extension SRGDataProvider {
    /**
     *  Return the URL for an image having a given width and scaled by applying the specified behavior.
     */
    func url(for image: SRGImage?, width: SRGImageWidth, scalingService: SRGImageScalingService = .default) -> URL? {
        return requestURL(for: image, with: width, scalingService: scalingService)
    }
    
    /**
     *  Return the URL for an image having a given semantic size and scaled by applying the specified behavior.
     */
    func url(for image: SRGImage?, size: SRGImageSize, scalingService: SRGImageScalingService = .default) -> URL? {
        return requestURL(for: image, with: size, scalingService: scalingService)
    }
}
