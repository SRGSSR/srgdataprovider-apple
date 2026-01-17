//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

private import SRGDataProviderRequests

/**
 *  Services offered by the SwissTXT Live Center.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  List of videos available from the Live Center (Sport Manager).
     *
     *  - Parameter contentTypeFilter: The content type filter to apply.
     *  - Parameter eventsWithResultOnly: Whether only medias which are in the Live & Result Center (LRC) must be returned.
     *  - Parameter tags: An optional list of included tags.
     */
    func liveCenterVideos(for vendor: SRGVendor, contentTypeFilter: SRGContentTypeFilter = .none, eventsWithResultOnly: Bool = true, withTags tags: [String]? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestLiveCenterVideos(for: vendor, contentTypeFilter: contentTypeFilter, eventsWithResultOnly: eventsWithResultOnly, withTags: tags)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
}
