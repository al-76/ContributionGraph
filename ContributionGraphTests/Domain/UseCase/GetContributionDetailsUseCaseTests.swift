//
//  GetContributionDetailsUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.09.2022.
//

import XCTest

@testable import ContributionGraph

class GetContributionDetailsUseCaseTests: XCTestCase {
    private var useCase: DefaultGetContributionDetailsUseCase!
    private var repository: ContributionDetailsRepositoryMock!

    override func setUp() {
        super.setUp()

        repository = ContributionDetailsRepositoryMock()
        useCase = DefaultGetContributionDetailsUseCase(repository: repository)
    }

    func testExecute() throws {
        // Arrange
        let testData = ContributionDetails(date: Date.now,
                                           notes: [ContributionNote("test")])
        repository.readHandler = { _ in successAnswer(testData) }

        // Act
        let result = try awaitPublisher(useCase(Date.neutral))

        // Assert
        XCTAssertEqual(result, testData)
        XCTAssertEqual(repository.readCallCount, 1)
    }

    func testExecuteNoDetails() throws {
        // Arrange
        repository.readHandler = { _ in successAnswer(nil) }

        // Act
        let result = try awaitPublisher(useCase(Date.neutral))

        // Assert
        XCTAssertNil(result)
        XCTAssertEqual(repository.readCallCount, 1)
    }

    func testExecuteError() throws {
        // Arrange
        repository.readHandler = { _ in failAnswer() }

        // Act
        let result = try awaitError(useCase(Date.neutral))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        XCTAssertEqual(repository.readCallCount, 1)
    }
}
