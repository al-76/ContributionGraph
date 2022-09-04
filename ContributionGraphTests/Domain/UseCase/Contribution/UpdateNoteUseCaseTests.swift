////
////  UpdateNoteUseCaseTests.swift
////  ContributionGraphTests
////
////  Created by Vyacheslav Konopkin on 27.08.2022.
////
//
//import XCTest
//import Combine
//import Mockingbird
//
//@testable import ContributionGraph
//
////extension ContributionNote: Matchable {}
////extension Date: Matchable {}
//
//class UpdateNoteUseCaseTests: XCTestCase {
//    private let testDate = Date.now
//    private let testNote = ContributionNote(id: UUID(), title: "", changed: Date.now, note: "test")
//
//    func testExecute() throws {
//        // Arrange
//        let repository = mock(ContributionDetailsRepository.self)
//        given(repository.write(testNote, at: testDate)).willReturn(successAnswer(()))
//        let addNote = UpdateNoteUseCase(repository: repository)
//
//        // Act
//        try awaitPublisher(addNote((testDate, testNote)))
//
//        // Assert
//        verify(repository.write(testNote, at: testDate)).wasCalled()
//    }
//
//    func testExecuteError() throws {
//        // Arrange
//        let repository = mock(ContributionDetailsRepository.self)
//        given(repository.write(testNote, at: testDate)).willReturn(failAnswer())
//        let addNote = UpdateNoteUseCase(repository: repository)
//
//        // Act
//        let result = try awaitError(addNote((testDate, testNote)))
//
//        // Assert
//        XCTAssertEqual(result as? TestError, TestError.someError)
//        verify(repository.write(testNote, at: testDate)).wasCalled()
//    }
//}
