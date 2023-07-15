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
     *  Return the URL for an image having a given width.
     */
    func url(for image: SRGImage?, width: SRGImageWidth) -> URL? {
        return requestURL(for: image, with: width)
    }
    
    /**
     *  Return the URL for an image having a given semantic size.
     */
    func url(for image: SRGImage?, size: SRGImageSize) -> URL? {
        return requestURL(for: image, with: size)
    }
}
