//
//  ContributionMetricsRepositoryTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 20.09.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

class ContributionMetricsRepositoryTests: XCTestCase {
    typealias ContributionMetricsMapperMock = MapperMock<(Int, [CDContribution]),
                                                            ContributionMetrics>

    private var storage: StorageMock!
    private var mapper: ContributionMetricsMapperMock!
    private var repository: ContributionMetricsRepository!

    override func setUp() {
        super.setUp()

        storage = StorageMock()
        mapper = ContributionMetricsMapperMock()
        repository = DefaultContributionMetricsRepository(storage: storage,
                                                          mapper: mapper)
    }

    func testRead() throws {
        // Arrange
        let test = (dto: CDContribution(),
                    metrics: ContributionMetrics(totalWeekCount: 10,
                                                 totalContributionCount: 10))
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                .success((context: StorageContextMock(),
                          items: [test.dto])))
        }
        storage.countHandler = { _, _, completion in
            completion(.success(test.metrics.totalContributionCount))
        }
        mapper.mapHandler = { _ in test.metrics }

        // Act
        let result = try awaitPublisher(repository.read())

        // Assert
        XCTAssertEqual(result, test.metrics)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(storage.countCallCount, 1)
        XCTAssertEqual(mapper.mapCallCount, 1)
    }

    func testReadStorageCountError() throws {
        // Arrange
        let testError = TestError.someError
        storage.countHandler = { _, _, completion in
            completion(.failure(testError))
        }

        // Act
        let result = try awaitError(repository.read())

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.countCallCount, 1)
    }

    func testFetchStorageCountError() throws {
        // Arrange
        let testError = TestError.someError
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .failure(testError),
                               CDContribution.self)
        }
        storage.countHandler = { _, _, completion in
            completion(.success(100))
        }

        // Act
        let result = try awaitError(repository.read())

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(storage.countCallCount, 1)
    }
}
