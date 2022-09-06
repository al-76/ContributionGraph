//
//  ContributionRepositoryTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 27.08.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

class ContributionRepositoryTests: XCTestCase {
    private var storage: StorageMock!
    private var mapper: ContributionMapperMock!
    private var repository: ContributionRepository!

    override func setUp() {
        super.setUp()

        storage = StorageMock()
        mapper = ContributionMapperMock()
        repository = DefaultContributionRepository(storage: storage,
                                                   mapper: mapper)
    }

    func testRead() throws {
        // Arrange
        let test = (data: Contribution(days: 0),
                    dto: CDContribution())
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: StorageContextMock(), items: [test.dto])))
        }
        mapper.mapHandler = { _ in test.data }

        // Act
        let result = try awaitPublisher(repository.read())

        // Assert
        XCTAssertEqual(result, [test.data])
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(mapper.mapCallCount, 1)
    }

    func testReadError() throws {
        // Arrange
        let testError = TestError.someError
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .failure(TestError.someError),
                               CDContribution.self)
        }

        // Act
        let result = try awaitError(repository.read())

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
    }
}
