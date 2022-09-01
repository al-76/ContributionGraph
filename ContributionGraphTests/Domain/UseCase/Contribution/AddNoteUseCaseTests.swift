//
//  AddNoteUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 27.08.2022.
//

import XCTest
import Combine
import Cuckoo

@testable import ContributionGraph

extension ContributionNote: Matchable {}
extension Date: Matchable {}

class AddNoteUseCaseTests: XCTestCase {
    private let testDate = Date.now
    private let testNote = ContributionNote(changed: Date.now, note: "test")

    func testExecute() throws {
        // Arrange
        let repository = MockContributionDetailsRepository()
        stub(repository) { stub in
            when(stub.write(testNote, at: testDate)).thenReturn(successAnswer(()))
        }
        let addNote = AddNoteUseCase(repository: repository)

        // Act
        try awaitPublisher(addNote((testDate, testNote)))

        // Assert
        verify(repository).write(testNote, at: testDate)
    }

    func testExecuteError() throws {
        // Arrange
        let repository = MockContributionDetailsRepository()
        stub(repository) { stub in
            when(stub.write(testNote, at: testDate)).thenReturn(failAnswer())
        }
        let addNote = AddNoteUseCase(repository: repository)

        // Act
        let result = try awaitError(addNote((testDate, testNote)))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        verify(repository).write(testNote, at: testDate)
    }
}
