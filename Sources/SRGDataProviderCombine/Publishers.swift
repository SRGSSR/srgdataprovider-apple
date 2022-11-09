//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

@_implementationOnly import SRGNetwork

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    /**
     *  Make the upstream publisher wait until a second signal publisher emits some value.
     */
    func wait<S>(untilOutputFrom signal: S) -> AnyPublisher<Output, Failure> where S: Publisher, S.Failure == Never {
        return prepend(
            Empty(completeImmediately: false)
                .prefix(untilOutputFrom: signal)
        )
        .eraseToAnyPublisher()
    }
    
    /**
     * Publish the first upstream value, then apply usual debouncing for subsequent values.
     */
    func debounceAfterFirst<S>(for dueTime: S.SchedulerTimeType.Stride, scheduler: S, options: S.SchedulerOptions? = nil) -> AnyPublisher<Output, Failure> where S: Scheduler {
        // Borrowed from https://stackoverflow.com/a/30145789/760435
        return Publishers.Concatenate(
            prefix: first(),
            suffix: dropFirst()
                .debounce(for: dueTime, scheduler: scheduler, options: options)
        )
        .eraseToAnyPublisher()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    /**
     *  Make the upstream publisher publish each time a second signal publisher emits some value. If no
     *  signal is provided the publisher never executes.
     */
    static func Publish<S, P>(onOutputFrom signal: S?, _ publisher: @escaping () -> P) -> AnyPublisher<P.Output, P.Failure> where S: Publisher, P: Publisher, S.Failure == Never {
        guard let signal = signal else {
            return Empty<P.Output, P.Failure>().eraseToAnyPublisher()
        }
        return signal
            .map { _ in }
            .setFailureType(to: P.Failure.self)          // TODO: Remove when iOS 14 is the minimum deployment target
            .map { _ in
                return publisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    /**
     *  Make the upstream publisher execute once and repeat each time a second signal publisher emits some value. If no
     *  signal is provided the publisher simply executes once and never repeats.
     */
    static func PublishAndRepeat<S, P>(onOutputFrom signal: S?, _ publisher: @escaping () -> P) -> AnyPublisher<P.Output, P.Failure> where S: Publisher, P: Publisher, S.Failure == Never {
        guard let signal = signal else {
            return publisher().eraseToAnyPublisher()
        }
        
        // Use `prepend(_:)` to trigger an initial update
        // Inspired from https://stackoverflow.com/questions/66075000/swift-combine-publishers-where-one-hasnt-sent-a-value-yet
        return signal
            .map { _ in }
            .prepend(())
            .setFailureType(to: P.Failure.self)          // TODO: Remove when iOS 14 is the minimum deployment target
            .map { _ in
                return publisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    /**
     *  Accumulate the results of a list of publishers and deliver them as a stream of arrays containing the latest
     *  values in publisher order. The first array is emitted once all publishers have at least emitted a value once.
     */
    static func AccumulateLatestMany<Upstream>(_ publishers: Upstream...) -> AnyPublisher<[Upstream.Output], Upstream.Failure> where Upstream: Publisher {
        return AccumulateLatestMany(publishers)
    }
    
    /**
     *  Accumulate the results of a list of publishers and deliver them as a stream of arrays containing the latest
     *  values in publisher order. The first array is emitted once all publishers have at least emitted a value once.
     */
    static func AccumulateLatestMany<Upstream, S>(_ publishers: S) -> AnyPublisher<[Upstream.Output], Upstream.Failure> where Upstream: Publisher, S: Swift.Sequence, S.Element == Upstream {
        let publishersArray = Array(publishers)
        switch publishersArray.count {
        case 0:
            return Just([])
                .setFailureType(to: Upstream.Failure.self)
                .eraseToAnyPublisher()
        case 1:
            return publishersArray[0]
                .map { [$0] }
                .eraseToAnyPublisher()
        case 2:
            return Publishers.CombineLatest(publishersArray[0], publishersArray[1])
                .map { t1, t2 in
                    return [t1, t2]
                }
                .eraseToAnyPublisher()
        case 3:
            return Publishers.CombineLatest3(publishersArray[0], publishersArray[1], publishersArray[2])
                .map { t1, t2, t3 in
                    return [t1, t2, t3]
                }
                .eraseToAnyPublisher()
        default:
            let half = publishersArray.count / 2
            return Publishers.CombineLatest(
                AccumulateLatestMany(Array(publishersArray[0..<half])),
                AccumulateLatestMany(Array(publishersArray[half..<publishersArray.count]))
            )
            .map { array1, array2 in
                return array1 + array2
            }
            .eraseToAnyPublisher()
        }
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    typealias Ouput<T> = (data: T, response: URLResponse)
    
    /**
     *  An operator to enable `SRGNetwork` automatic network activity management on a data task publisher.
     */
    func manageNetworkActivity() -> Publishers.HandleEvents<Self> where Self == URLSession.DataTaskPublisher {
        return handleEvents { _ in
            SRGNetworkActivityManagement.increaseNumberOfRunningRequests()
        } receiveCompletion: { _ in
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        } receiveCancel: {
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        }
    }
    
    /**
     *  An operator turning all HTTP errors over 400 into proper errors reported to the publisher stream.
     */
    func reportHttpErrors() -> Publishers.TryMap<Self, Output> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                throw SRGDataProviderError.http(statusCode: httpResponse.statusCode)
            }
            return result
        }
    }
    
    /**
     *  An operator attempting to map some JSON to an object of a given type.
     */
    func tryMapJson<T>(_ type: T.Type) -> Publishers.TryMap<Self, Ouput<T>> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let object = try JSONSerialization.jsonObject(with: result.data, options: []) as? T {
                return (object, result.response)
            }
            else {
                throw SRGDataProviderError.invalidData
            }
        }
    }
}
