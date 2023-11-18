//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

@_implementationOnly import SRGDataProviderRequests

/**
 *  Services returning content configured by editors through the Play Application Configurator tool (PAC).
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Retrieve a page of content given by its unique identifier.
     *
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter date: The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                    at a specific date.
     */
    func contentPage(for vendor: SRGVendor, uid: String, published: Bool = true, at date: Date? = nil) -> AnyPublisher<SRGContentPage, Error> {
        let request = requestContentPage(for: vendor, uid: uid, published: published, at: date)
        return objectPublisher(for: request, type: SRGContentPage.self)
    }
    
    /**
     *  Retrieve the default content page for a product.
     *
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter product: The product to retrieve the content page for.
     *  - Parameter date: The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                    at a specific date.
     */
    func contentPage(for vendor: SRGVendor, product: SRGProduct, published: Bool = true, at date: Date? = nil) -> AnyPublisher<SRGContentPage, Error> {
        return contentPage(for: vendor, productName: product.rawValue, published: published, at: date)
    }
    
    /**
     *  Retrieve the default content page for a product.
     *
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter productName: The name of the product to retrieve the content page for.
     *  - Parameter date: The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                    at a specific date.
     */
    func contentPage(for vendor: SRGVendor, productName: String, published: Bool = true, at date: Date? = nil) -> AnyPublisher<SRGContentPage, Error> {
        let request = requestContentPage(for: vendor, productName: productName, published: published, at: date)
        return objectPublisher(for: request, type: SRGContentPage.self)
    }
    
    /**
     *  Retrieve a page of content for a specific topic.
     *
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter date: The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                    at a specific date.
     */
    func contentPage(for vendor: SRGVendor, topicWithUrn topicUrn: String, published: Bool = true, at date: Date? = nil) -> AnyPublisher<SRGContentPage, Error> {
        let request = requestContentPage(for: vendor, topicWithURN: topicUrn, published: published, at: date)
        return objectPublisher(for: request, type: SRGContentPage.self)
    }
    
    /**
     *  Retrieve a page of content for a specific show.
     *
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter product: The product to retrieve the content page for.
     *  - Parameter date: The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                    at a specific date.
     */
    func contentPage(for vendor: SRGVendor, product: SRGProduct, showWithUrn showUrn: String, published: Bool = true, at date: Date? = nil) -> AnyPublisher<SRGContentPage, Error> {
        return contentPage(for: vendor, productName: product.rawValue, showWithUrn: showUrn, published: published, at: date)
    }
    
    /**
     *  Retrieve a page of content for a specific show.
     *
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter productName: The name of the product to retrieve the content page for.
     *  - Parameter date: The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                    at a specific date.
     */
    func contentPage(for vendor: SRGVendor, productName: String, showWithUrn showUrn: String, published: Bool = true, at date: Date? = nil) -> AnyPublisher<SRGContentPage, Error> {
        let request = requestContentPage(for: vendor, productName: productName, showWithURN: showUrn, published: published, at: date)
        return objectPublisher(for: request, type: SRGContentPage.self)
    }
    
    /**
     *  Retrieve a section of content given by its unique identifier.
     *
     *  - Parameter published: Set this parameter to `true` to look only for published sections.
     */
    func contentSection(for vendor: SRGVendor, uid: String, published: Bool = true) -> AnyPublisher<SRGContentSection, Error> {
        let request = requestContentSection(for: vendor, uid: uid, published: published)
        return objectPublisher(for: request, type: SRGContentSection.self)
    }
    
    /**
     *  Retrieve medias for a content section.
     *
     *  - Parameter userId: An optional user identifier.
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter date: The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                    at a specific date.
     *
     *  - Remark: The section itself must be of type `SRGContentSectionTypeMedias`.
     */
    func medias(for vendor: SRGVendor, contentSectionUid: String, userId: String? = nil, published: Bool = true, at date: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestMedias(for: vendor, contentSectionUid: contentSectionUid, userId: userId, published: published, at: date)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
    
    /**
     *  Retrieve shows for a content section.
     *
     *  - Parameter userId: An optional user identifier.
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter date: The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                    at a specific date.
     *
     *  - Remark: The section itself must be of type `SRGContentSectionTypeShows`.
     */
    func shows(for vendor: SRGVendor, contentSectionUid: String, userId: String? = nil, published: Bool = true, at date: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGShow], Error> {
        let request = requestShows(for: vendor, contentSectionUid: contentSectionUid, userId: userId, published: published, at: date)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "showList", type: SRGShow.self, paginatedBy: signal)
    }
    
    enum ShowAndMediasForContentSection {
        public typealias Output = (show: SRGShow?, medias: [SRGMedia])
    }
    
    /**
     *  Retrieve the show and medias for a content section.
     *
     *  - Parameter userId: An optional user identifier.
     *  - Parameter published: Set this parameter to `true` to look only for published pages.
     *  - Parameter date The page content might change over time. Use `nil` to retrieve the page as it looks now, or
     *                   at a specific date.
     *
     *  - Remark: The section itself must be of type `SRGContentSectionTypeShowAndMedias`.
     */
    func showAndMedias(for vendor: SRGVendor, contentSectionUid: String, userId: String? = nil, published: Bool = true, at date: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<ShowAndMediasForContentSection.Output, Error> {
        let request = requestShowAndMedias(for: vendor, contentSectionUid: contentSectionUid, userId: userId, published: published, at: date)
        return paginatedObjectTriggeredPublisher(at: Page(request: request, size: pageSize), type: SRGShowAndMedias.self, paginatedBy: signal)
            .map { ($0.show, $0.medias) }
            .eraseToAnyPublisher()
    }
}
