//
//  DefaultContributionRepositoryTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 27.08.2022.
//

import XCTest
import Combine
import Cuckoo

@testable import ContributionGraph

extension CDContribution: Matchable {}
extension CDContributionNote: Matchable {}

class DefaultContributionRepositoryTests: XCTestCase {
    typealias StorageResult = Result<(context: StorageContext, items: [CDContribution]), Error>

    func testRead() throws {
        // Arrange
        let test = (data: Contribution(days: 0),
                    dto: CDContribution())
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: isNil(), any(), onCompletion: any()).then { args in
                args.2(.success((context: MockStorageContext(), items: [test.dto])))
            }
        }
        let mapper = MockMapper<CDContribution, Contribution>()
        stub(mapper) { stub in
            when(stub).map(input: test.dto)
                .thenReturn(test.data)
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       mapper: mockAnyMapper(mapper))

        // Act
        let result = try awaitPublisher(repository.read())

        // Assert
        XCTAssertEqual(result, [test.data])
        verify(mapper).map(input: test.dto)
    }

    func testReadError() throws {
        // Arrange
        let testError = TestError.someError
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: isNil(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.failure(testError))
            }
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       mapper: mockAnyMapper())

        // Act
        let result = try awaitError(repository.read())

        // Assert
        XCTAssertEqual(result as? TestError, testError)
    }
}
