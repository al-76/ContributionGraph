//
//  SetContributionSettingsUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.09.2022.
//

import XCTest

@testable import ContributionGraph

class SetContributionSettingsUseCaseTests: XCTestCase {
    private var useCase: SetContributionSettingsUseCase!
    private var repository: ContributionSettingsRepositoryMock!

    override func setUp() {
        super.setUp()

        repository = ContributionSettingsRepositoryMock()
        useCase = SetContributionSettingsUseCase(repository: repository)
    }

    func testExecute() throws {
        // Arrange
        let testData = ContributionSettings(weekCount: 15)
        repository.readHandler = { successAnswer(testData) }
        repository.writeHandler = { _ in successAnswer(()) }

        // Act
        let result = try awaitPublisher(useCase(testData))

        // Assert
        XCTAssertEqual(result, testData)
        XCTAssertEqual(repository.readCallCount, 1)
        XCTAssertEqual(repository.writeCallCount, 1)
    }

    func testExecuteWriteError() throws {
        // Arrange
        let testData = ContributionSettings(weekCount: 15)
        repository.writeHandler = { _ in failAnswer() }

        // Act
        let result = try awaitError(useCase(testData))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        XCTAssertEqual(repository.readCallCount, 0)
        XCTAssertEqual(repository.writeCallCount, 1)
    }

    func testExecuteReadError() throws {
        // Arrange
        let testData = ContributionSettings(weekCount: 15)
        repository.readHandler = { failAnswer() }
        repository.writeHandler = { _ in successAnswer(()) }

        // Act
        let result = try awaitError(useCase(testData))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        XCTAssertEqual(repository.readCallCount, 1)
        XCTAssertEqual(repository.writeCallCount, 1)
    }
}
