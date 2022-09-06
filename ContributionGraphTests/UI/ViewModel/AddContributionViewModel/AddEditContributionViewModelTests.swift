//
//  AddContributionViewModelTests.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 09.08.2022.
//

import XCTest
import Combine

class AddEditContributionViewModelTests: XCTestCase {
    let testDataNew = AddEditContributionViewModel.Data(day: 10,
                                                        title: "title",
                                                        note: "note",
                                                        contributionNote: nil)
    let testData = AddEditContributionViewModel.Data(day: 10,
                                                     title: "title",
                                                     note: "note",
                                                     contributionNote:
                                                        ContributionNote(id: UUID(),
                                                                         title: "test",
                                                                         changed: Date.now,
                                                                         note: "old_note"))
    var updateNote: UpdateNoteUseCaseMock!

    override func setUp() {
        super.setUp()

        updateNote = UpdateNoteUseCaseMock()
    }

    func testInitState() throws {
        // Arrange
        let viewModel = AddEditContributionViewModel(updateNote: updateNote)

        // Act
        let result = try awaitPublisher(viewModel.$state)

        // Assert
        XCTAssertEqual(result, .success(false))
    }

    func testSetData() {
        // Arrange
        updateNote.callAsFunctionHandler = { _ in successAnswer(()) }
        let viewModel = AddEditContributionViewModel(updateNote: updateNote)

        // Act
        viewModel.set(data: testData)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(true))
    }

    func testSetDataNew() {
        // Arrange
        updateNote.callAsFunctionHandler = { _ in successAnswer(()) }
        let viewModel = AddEditContributionViewModel(updateNote: updateNote)

        // Act
        viewModel.set(data: testDataNew)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(true))
    }

    func testSetDataError() {
        // Arrange
        updateNote.callAsFunctionHandler = { _ in failAnswer() }
        let viewModel = AddEditContributionViewModel(updateNote: updateNote)

        // Act
        viewModel.set(data: testData)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
}
