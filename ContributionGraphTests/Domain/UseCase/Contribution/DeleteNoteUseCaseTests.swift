//
//  DeleteNoteUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 07.09.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

class DeleteNoteUseCaseTests: XCTestCase {
    private let testNote = ContributionNote(id: UUID(), title: "", changed: Date.now, note: "test")
    private let testContribution = Contribution(days: 4)
    private var useCase: DefaultDeleteNoteUseCase!
    private var repository: ContributionDetailsRepositoryMock!

    override func setUp() {
        super.setUp()

        repository = ContributionDetailsRepositoryMock()
        useCase = DefaultDeleteNoteUseCase(repository: repository)
    }

    func testExecute() throws {
        // Arrange
        repository.deleteHandler = { _, _ in successAnswer(()) }

        // Act
        try awaitPublisher(useCase((testNote, testContribution)))

        // Assert
        verifyRepository()
    }

    func testExecuteError() throws {
        // Arrange
        repository.deleteHandler = { _, _ in failAnswer() }

        // Act
        let result = try awaitError(useCase((testNote, testContribution)))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        verifyRepository()
    }

    private func verifyRepository() {
        let args = repository.deleteArgValues.first
        XCTAssertEqual(args?.0, testNote)
        XCTAssertEqual(args?.1, testContribution)
        XCTAssertEqual(repository.deleteCallCount, 1)
    }
}
