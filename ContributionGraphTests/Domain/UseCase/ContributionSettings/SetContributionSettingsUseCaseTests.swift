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

    override func setUp() {
        super.setUp()

        useCase = SetContributionSettingsUseCase()
    }

    func testExecute() throws {
        // Arrange
        let testData = ContributionSettings(weekCount: 15)

        // Act
        let result = try awaitPublisher(useCase(testData))

        // Assert
        XCTAssertEqual(result, testData)
    }
}
