//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@testable import SRGDataProviderCombine
import XCTest

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class PublishersTestCase: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        super.tearDown()
        cancellables = []
    }

    func testSyntaxWithoutTypeErasure() {
        let expectation = expectation(description: "Publisher completed")

        Publishers.AccumulateLatestMany(
            Just(1),
            Just(2),
            Just(3)
        )
        .sink { completion in
            expectation.fulfill()
        } receiveValue: { value in
            XCTAssertEqual(value, [1, 2, 3])
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }
}
