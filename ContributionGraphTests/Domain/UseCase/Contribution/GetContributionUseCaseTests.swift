//
//  GetContributionUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 27.08.2022.
//

import XCTest
import Combine

class GetContributionUseCaseTests: XCTestCase {
    private var repository: ContributionRepositoryMock!
    private var useCase: DefaultGetContributionUseCase!

    override func setUp() {
        super.setUp()

        repository = ContributionRepositoryMock()
        useCase = DefaultGetContributionUseCase(repository: repository)
    }

    func testExecute() throws {
        // Arrange
        let testData = [Contribution(days: 0),
                        Contribution(days: 1),
                        Contribution(days: 2)]
        repository.readHandler = { successAnswer(testData) }

        // Act
        let result = try awaitPublisher(useCase())

        // Assert
        XCTAssertEqual(result.map { $0.value }.sorted { $0.date > $1.date },
                       testData)
        XCTAssertEqual(repository.readCallCount, 1)
    }

    func testExecuteError() throws {
        // Arrange
        repository.readHandler = { failAnswer() }

        // Act
        let result = try awaitError(useCase())

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        XCTAssertEqual(repository.readCallCount, 1)
    }
}
