//
//  UpdateNoteUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 27.08.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

class DefaultUpdateNoteUseCaseTests: XCTestCase {
    private let testDate = Date.now
    private let testNote = ContributionNote(id: UUID(), title: "", changed: Date.now, note: "test")
    private var useCase: DefaultUpdateNoteUseCase!
    private var repository: ContributionDetailsRepositoryMock!

    override func setUp() {
        super.setUp()

        repository = ContributionDetailsRepositoryMock()
        useCase = DefaultUpdateNoteUseCase(repository: repository)
    }

    func testExecute() throws {
        // Arrange
        repository.writeHandler = { _, _ in successAnswer(()) }

        // Act
        try awaitPublisher(useCase((testDate, testNote)))

        // Assert
        XCTAssertEqual(repository.writeCallCount, 1)
    }

    func testExecuteError() throws {
        // Arrange
        repository.writeHandler = { _, _ in failAnswer() }

        // Act
        let result = try awaitError(useCase((testDate, testNote)))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        XCTAssertEqual(repository.writeCallCount, 1)
    }
}
