//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  Trigger for publishers waiting for a signal to continue their processing.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Trigger {
    public typealias Identifier = Int
    public typealias Subject = PassthroughSubject<Identifier, Never>
    public typealias Publisher = AnyPublisher<Identifier, Never>
    
    public typealias Id = (publisher: Publisher, identifier: Identifier)
    
    private let subject = Subject()
    
    /**
     *  Create a sentinel which emits a signal bound to some trigger identifier.
     */
    public static func sentinel(for triggerId: Trigger.Id) -> AnyPublisher<Bool, Never> {
        return triggerId.publisher
            .contains(triggerId.identifier)
            .eraseToAnyPublisher()
    }
    
    public init() {}
    
    private var publisher: Publisher {
        return subject.eraseToAnyPublisher()
    }
    
    /**
     *  Generate an identifier from an integer value.
     */
    public func id(_ identifier: Identifier) -> Id {
        return (publisher, identifier)
    }
    
    /**
     *  Generate an identifier from a hashable instance.
     */
    public func id<T>(_ t: T) -> Id where T: Hashable {
        return id(t.hashValue)
    }
    
    /**
     *  Ask the publisher matching the specified identifier to continue its work.
     */
    public func signal(_ identifier: Identifier) {
        subject.send(identifier)
    }
    
    /**
     *  Ask the publisher matching the specified hashable instance to continue its work.
     */
    public func signal<T>(_ t: T) where T: Hashable {
        signal(t.hashValue)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    /**
     *  Make the upstream publisher execute again when a second signal publisher emits some value. No matter whether
     *  the second publisher emits a value the upstream publishers executes normally once.
     */
    func publishAgain<S>(when signal: S) -> AnyPublisher<Self.Output, Self.Failure> where S: Publisher, S.Failure == Never {
        return signal
            .map { _ in }
            .prepend(())
            .setFailureType(to: Self.Failure.self)          // TODO: Remove when iOS 14 is the minimum deployment target
            .flatMap { _ in
                return self
            }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Make the upstream publisher wait until a second signal publsher emits some value.
     */
    func wait<S>(until signal: S) -> AnyPublisher<Self.Output, Self.Failure> where S: Publisher, S.Failure == Never {
        return self
            .prepend(
                Empty(completeImmediately: false)
                    .prefix(untilOutputFrom: signal)
            )
            .eraseToAnyPublisher()
    }
}

#endif
