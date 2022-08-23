//
//  AddContributionViewModelTests.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 09.08.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

private struct FakeAddNoteUseCase: UseCase {
    func execute(with input: NewContributionNote) -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private struct FakeErrorAddNoteUseCase: UseCase {
    func execute(with input: NewContributionNote) -> AnyPublisher<Void, Error> {
        Fail(error: TestError.someError)
            .eraseToAnyPublisher()
    }
}

class AddContributionViewModelTests: XCTestCase {
    func testInitState() {
        // Arrange
        let viewModel = AddContributionViewModel(addNoteUseCase: AnyUseCase(wrapped: FakeAddNoteUseCase()))
        
        // Assert
        XCTAssertEqual(viewModel.state, .success(false))
    }
    
    func testAdd() {
        // Arrange
        let viewModel = AddContributionViewModel(addNoteUseCase: AnyUseCase(wrapped: FakeAddNoteUseCase()))
        
        // Act
        viewModel.add(note: "test", at: 10)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()), .success(true))
    }
    
    func testAddError() {
        // Arrange
        let viewModel = AddContributionViewModel(addNoteUseCase: AnyUseCase(wrapped: FakeErrorAddNoteUseCase()))
        
        // Act
        viewModel.add(note: "test", at: 10)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()), .failure(TestError.someError))
    }
}
