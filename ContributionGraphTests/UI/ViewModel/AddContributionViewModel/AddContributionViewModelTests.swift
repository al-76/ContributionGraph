//
//  AddContributionViewModelTests.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 09.08.2022.
//

import XCTest
import Combine
import Cuckoo

@testable import ContributionGraph

class AddContributionViewModelTests: XCTestCase {
    func testInitState() throws {
        // Arrange
        let viewModel = AddContributionViewModel(addNote: MockAnyUseCase())
        
        // Act
        let result = try awaitPublisher(viewModel.$state)
        
        // Assert
        XCTAssertEqual(result, .success(false))
    }
    
    func testAdd() {
        // Arrange
        let answer = successAnswer(())
        let viewModel = AddContributionViewModel(addNote: MockAnyUseCase(answer))
        
        // Act
        viewModel.add(note: "test", at: 10)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(true))
    }
    
    func testAddError() {
        // Arrange
        let viewModel = AddContributionViewModel(addNote: MockAnyUseCase(failAnswer()))
        
        // Act
        viewModel.add(note: "test", at: 10)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
}
