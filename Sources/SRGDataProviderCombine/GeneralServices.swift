//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

@_implementationOnly import SRGDataProviderRequests

/**
 *  General services.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Retrieve a message from the service about its status, if there is currently one. If none is available, the
     *  call ends with an HTTP error.
     */
    func serviceMessage(for vendor: SRGVendor) -> AnyPublisher<SRGServiceMessage, Error> {
        let request = requestServiceMessage(for: vendor)
        return objectPublisher(for: request, type: SRGServiceMessage.self)
    }
}
