//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
import SRGDataProvider
import SRGDataProviderModel

@_implementationOnly import Mantle

public extension Calendar {
    /**
     *  The calendar which the SRG SSR is located in, with its associated time zone (Zurich). Should be used for calendrical
     *  calculations involving SRG SSR data.
     */
    static var srgDefault: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.srgTimeZone
        return calendar
    }()
}

public extension TimeZone {
    /**
     *  The time zone which the SRG SSR is located in (Zurich). Should be used for calendrical calculations involving SRG
     *  SSR data.
     */
    static let srgTimeZone = TimeZone(identifier: "Europe/Zurich")!
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension SRGDataProvider {
    typealias PaginatedObjectsOutput<T> = (objects: [T], total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, nextRequest: URLRequest?)
    
    /**
     *  A publisher able to retrieve possibly paginated arrays of objects.
     */
    func paginatedObjectsPublisher<T>(for request: URLRequest, rootKey: String, type: T.Type) -> AnyPublisher<PaginatedObjectsOutput<T>, Error> where T: MTLModel {
        return paginatedDictionaryPublisher(for: request)
            .tryMap { result in
                // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array
                //         (or no such entry at all for the episode composition request)
                // See https://confluence.srg.beecollaboration.com/display/SRGPLAY/Developer+Meeting+2016-10-05
                guard let array = result.object[rootKey] as? [Any] else {
                    return ([], result.total, result.aggregations, result.suggestions, nil)
                }
                
                if let objects = try? MTLJSONAdapter.models(of: T.self, fromJSONArray: array) as? [T] {
                    return (objects, result.total, result.aggregations, result.suggestions, result.nextRequest)
                }
                else {
                    throw URLError(.cannotDecodeContentData)
                }
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    typealias PaginatedObjectsTriggeredOutput<T> = (objects: [T], total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?)
    
    /**
     *  A publisher that recursively retrieves possibly paginated arrays of objects. The first page is automatically retrieved
     *  when connecting a subscriber. Subsequent page retrieval is requested through a `Trigger` stored separately. Consolidated
     *  results are added to the current object array and are provided to subscribers when available. If a trigger id is attached
     *  the pipeline reaches completion when the last page of content has been exhausted. If no trigger id is attached the pipeline
     *  completes immediately after returning the first page of results.
     *
     *  Inspired from RXSwift code, see for example:
     *    https://github.com/RxSwiftCommunity/RxPager/blob/master/RxPager/Classes/RxPager.swift
     *    https://stackoverflow.com/a/39645113/760435
     */
    func paginatedObjectsTriggeredPublisher<T, P>(at page: P, rootKey: String, type: T.Type, paginatedBy signal: Trigger.Signal?) -> AnyPublisher<PaginatedObjectsTriggeredOutput<T>, Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectsPublisher(for: page.request, rootKey: rootKey, type: T.self)
            .map { result -> AnyPublisher<PaginatedObjectsTriggeredOutput<T>, Error> in
                let output = (result.objects, result.total, result.aggregations, result.suggestions)
                if let signal = signal, let nextPage = page.next(with: result.nextRequest) {
                    return self.paginatedObjectsTriggeredPublisher(at: nextPage, rootKey: rootKey, type: type, paginatedBy: signal)
                        // Publish available results first, then wait for signal to load next page. If a failure is encountered
                        // wait again to retry (no limit).
                        .wait(untilOutputFrom: signal)
                        .retry(.max)
                        .prepend(output)
                        .eraseToAnyPublisher()
                }
                else {
                    return Just(output)
                        .setFailureType(to: Error.self)         // TODO: Remove when iOS 14 is the minimum deployment target
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    /**
     *  Convenience publisher emitting arrays of objects directly.
     */
    func paginatedObjectsTriggeredPublisher<T, P>(at page: P, rootKey: String, type: T.Type, paginatedBy signal: Trigger.Signal?) -> AnyPublisher<[T], Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectsTriggeredPublisher(at: page, rootKey: rootKey, type: type, paginatedBy: signal)
            .map(\.objects)
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension SRGDataProvider {
    typealias PaginatedObjectOutput<T> = (object: T, total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, nextRequest: URLRequest?)
    
    /**
     *  A publisher able to retrieve possibly paginated objects (one object per page).
     */
    func paginatedObjectPublisher<T>(for request: URLRequest, type: T.Type) -> AnyPublisher<PaginatedObjectOutput<T>, Error> where T: MTLModel {
        return paginatedDictionaryPublisher(for: request)
            .tryMap { result in
                if let object = try? MTLJSONAdapter.model(of: T.self, fromJSONDictionary: result.object) as? T {
                    return (object, result.total, result.aggregations, result.suggestions, result.nextRequest)
                }
                else {
                    throw SRGDataProviderError.invalidData
                }
            }
            .eraseToAnyPublisher()
    }
    
    /**
     *  A publisher able to retrieve possibly paginated JSON dictionaries.
     */
    private func paginatedDictionaryPublisher(for request: URLRequest) -> AnyPublisher<PaginatedObjectOutput<[String: Any]>, Error> {
        func extractNextUrl(from dictionary: [String: Any]) -> URL? {
            if let nextUrlString = dictionary["next"] as? String {
                return URL(string: nextUrlString)
            }
            else {
                return nil
            }
        }
        
        func updatedRequest(from request: URLRequest, with url: URL?) -> URLRequest? {
            guard let url = url else { return nil }
            var updatedRequest = request
            updatedRequest.url = url
            return updatedRequest
        }
        
        func extractTotal(from dictionary: [String: Any]) -> UInt {
            return dictionary["total"] as? UInt ?? 0
        }
        
        func extractAggregations(from dictionary: [String: Any]) -> SRGMediaAggregations? {
            guard let aggregationsJsonDictionary = dictionary["aggregations"] as? [String: Any] else { return nil }
            return try? MTLJSONAdapter.model(of: SRGMediaAggregations.self, fromJSONDictionary: aggregationsJsonDictionary) as? SRGMediaAggregations
        }
        
        func extractSuggestions(from dictionary: [String: Any]) -> [SRGSearchSuggestion]? {
            guard let suggestionsJsonArray = dictionary["suggestionList"] as? [Any] else { return nil }
            return try? MTLJSONAdapter.models(of: SRGSearchSuggestion.self, fromJSONArray: suggestionsJsonArray) as? [SRGSearchSuggestion]
        }
        
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .map { result in
                let nextRequest = updatedRequest(from: request, with: extractNextUrl(from: result.data))
                return (result.data, extractTotal(from: result.data), extractAggregations(from: result.data), extractSuggestions(from: result.data), nextRequest)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    typealias PaginatedObjectTriggeredOutput<T> = (object: T, total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?)
    
    /**
     *  A publisher that recursively retrieves possibly paginated objects (one object per page). The first page is automatically
     *  retrieved when connecting a subscriber. Subsequent page retrieval is requested through a `Trigger` stored separately.
     *  Consolidated results are added to the current object array and are provided to subscribers when available. The pipeline
     *  reaches completion when the last page of content has been reached.
     *
     *  Inspired from RXSwift code, see for example:
     *    https://github.com/RxSwiftCommunity/RxPager/blob/master/RxPager/Classes/RxPager.swift
     *    https://stackoverflow.com/a/39645113/760435
     */
    private func paginatedObjectTriggeredPublisher<T, P>(at page: P, type: T.Type, paginatedBy signal: Trigger.Signal?) -> AnyPublisher<PaginatedObjectTriggeredOutput<T>, Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectPublisher(for: page.request, type: T.self)
            .map { result -> AnyPublisher<PaginatedObjectTriggeredOutput<T>, Error> in
                let output = (result.object, result.total, result.aggregations, result.suggestions)
                if let signal = signal, let nextPage = page.next(with: result.nextRequest) {
                    return self.paginatedObjectTriggeredPublisher(at: nextPage, type: type, paginatedBy: signal)
                        // Publish available results first, then wait for signal to load next page. If a failure is encountered
                        // wait again to retry (no limit).
                        .wait(untilOutputFrom: signal)
                        .retry(.max)
                        .prepend(output)
                        .eraseToAnyPublisher()
                }
                else {
                    return Just(output)
                        .setFailureType(to: Error.self)         // TODO: Remove when iOS 14 is the minimum deployment target
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    /**
     *  Convenience publisher emitting single objects directly.
     */
    func paginatedObjectTriggeredPublisher<T, P>(at page: P, type: T.Type, paginatedBy signal: Trigger.Signal?) -> AnyPublisher<T, Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectTriggeredPublisher(at: page, type: type, paginatedBy: signal)
            .map(\.object)
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    /**
     *  A publisher able to retrieve non-paginated arrays of objects.
     */
    func objectsPublisher<T>(for request: URLRequest, rootKey: String, type: T.Type) -> AnyPublisher<[T], Error> where T: MTLModel {
        return paginatedObjectsPublisher(for: request, rootKey: rootKey, type: T.self)
            .map(\.objects)
            .eraseToAnyPublisher()
    }
    
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    /**
     *  A publisher able to retrieve a single object.
     */
    func objectPublisher<T>(for request: URLRequest, type: T.Type) -> AnyPublisher<T, Error> where T: MTLModel {
        return paginatedObjectPublisher(for: request, type: T.self)
            .map(\.object)
            .eraseToAnyPublisher()
    }
}
