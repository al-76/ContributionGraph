////
////  AddContributionViewModelTests.swift
////  ContributionGraph
////
////  Created by Vyacheslav Konopkin on 09.08.2022.
////
//
//import XCTest
//import Combine
//import Mockingbird
//
//@testable import ContributionGraph
//
//class AddEditContributionViewModelTests: XCTestCase {
//    let testDataNew = AddEditContributionViewModel.Data(day: 10,
//                                                        title: "title",
//                                                        note: "note",
//                                                        contributionNote: nil)
//    let testData = AddEditContributionViewModel.Data(day: 10,
//                                                     title: "title",
//                                                     note: "note",
//                                                     contributionNote:
//                                                        ContributionNote(id: UUID(),
//                                                                         title: "test",
//                                                                         changed: Date.now,
//                                                                         note: "old_note"))
//
//    func testInitState() throws {
//        // Arrange
//        let viewModel = AddEditContributionViewModel(updateNote: mockAnyUseCase())
//
//        // Act
//        let result = try awaitPublisher(viewModel.$state)
//
//        // Assert
//        XCTAssertEqual(result, .success(false))
//    }
//
//    func testSetData() {
//        // Arrange
//        let answer = successAnswer(())
//        let viewModel = AddEditContributionViewModel(updateNote: mockAnyUseCase(answer))
//
//        // Act
//        viewModel.set(data: testData)
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .success(true))
//    }
//
//    func testSetDataNew() {
//        // Arrange
//        let answer = successAnswer(())
//        let viewModel = AddEditContributionViewModel(updateNote: mockAnyUseCase(answer))
//
//        // Act
//        viewModel.set(data: testDataNew)
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .success(true))
//    }
//
//    func testSetDataError() {
//        // Arrange
//        let viewModel = AddEditContributionViewModel(updateNote: mockAnyUseCase(failAnswer()))
//
//        // Act
//        viewModel.set(data: testData)
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .failure(TestError.someError))
//    }
//}
