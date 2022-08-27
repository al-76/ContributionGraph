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

extension NewContributionNote: Equatable {
    public static func == (lhs: NewContributionNote, rhs: NewContributionNote) -> Bool {
        lhs.note == rhs.note && lhs.day == rhs.day
    }
}

extension NewContributionNote: Matchable {}

class AddNoteUseCaseTests: XCTestCase {
    func testExecute() throws {
        // Arrange
        let testNote = NewContributionNote(day: 0, note: "test")
        let repository = MockContributionRepository()
        stub(repository) { stub in
            when(stub.write(note: testNote)).thenReturn(successAnswer(()))
        }
        let addNote = AddNoteUseCase(repository: repository)
        
        // Act
        try awaitPublisher(addNote(testNote))
        
        // Assert
        verify(repository).write(note: testNote)
    }
    
    func testExecuteError() throws {
        // Arrange
        let testNote = NewContributionNote(day: 0, note: "test")
        let repository = MockContributionRepository()
        stub(repository) { stub in
            when(stub.write(note: testNote)).thenReturn(failAnswer())
        }
        let addNote = AddNoteUseCase(repository: repository)
        
        // Act
        let result = try awaitError(addNote(testNote))
        
        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        verify(repository).write(note: testNote)
    }
}
