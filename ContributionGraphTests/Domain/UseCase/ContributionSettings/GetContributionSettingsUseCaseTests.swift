//
//  GetContributionSettingsUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.09.2022.
//

import XCTest

@testable import ContributionGraph

class GetContributionSettingsUseCaseTests: XCTestCase {
    private var useCase: GetContributionSettingsUseCase!
    private var repository: ContributionSettingsRepositoryMock!

    override func setUp() {
        super.setUp()

        repository = ContributionSettingsRepositoryMock()
        useCase = GetContributionSettingsUseCase(repository: repository)
    }

    func testExecute() throws {
        // Arrange
        let testData = ContributionSettings(weekCount: 15)
        repository.readHandler = { successAnswer(testData) }

        // Act
        let result = try awaitPublisher(useCase())

        // Assert
        XCTAssertEqual(result, testData)
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
