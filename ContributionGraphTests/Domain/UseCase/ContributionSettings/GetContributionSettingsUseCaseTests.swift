//
//  GetContributionSettingsUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 06.09.2022.
//

import XCTest

@testable import ContributionGraph

class GetContributionSettingsUseCaseTests: XCTestCase {
    private var useCase: DefaultGetContributionSettingsUseCase!

    override func setUp() {
        super.setUp()

        useCase = DefaultGetContributionSettingsUseCase()
    }

    func testExecute() throws {
        // Arrange
        let testData = ContributionSettings(weekCount: 15)

        // Act
        let result = try awaitPublisher(useCase())

        // Assert
        XCTAssertEqual(result, testData)
    }
}
