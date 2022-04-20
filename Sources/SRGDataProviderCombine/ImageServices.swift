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
    func url(for image: SRGImage?, width: SRGImageWidth, scaling: SRGImageScaling = .default) -> URL? {
        return requestURL(for: image, with: width, scaling: scaling)
    }
    
    /**
     *  Return the URL for an image having a given semantic size and scaled by applying the specified behavior.
     */
    func url(for image: SRGImage?, size: SRGImageSize, scaling: SRGImageScaling = .default) -> URL? {
        return requestURL(for: image, with: size, scaling: scaling)
    }
    
    /**
     *  Return the request URL created from an image URL for a given width and scaled by applying the specified behavior.
     */
    func url(for imageUrl: URL?, width: SRGImageWidth, scaling: SRGImageScaling = .default) -> URL? {
        return requestURL(forImageURL: imageUrl, with: width, scaling: scaling)
    }
}
