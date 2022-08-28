//
//  GetContributionUseCaseTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 27.08.2022.
//

import XCTest
import Combine
import Cuckoo

@testable import ContributionGraph

class GetContributionUseCaseTests: XCTestCase {
    func testExecute() throws {
        // Arrange
        let testData = [Contribution(days: 0, notes: ["test1"]),
                        Contribution(days: 1, notes: ["test2"]),
                        Contribution(days: 2, notes: ["test3"])]
        let repository = MockContributionRepository()
        stub(repository) { stub in
            when(stub).read().thenReturn(successAnswer(testData))
        }
        let getContrubtion = GetContributionUseCase(repository: repository)
        
        // Act
        let result = try awaitPublisher(getContrubtion(()))
        
        // Assert
        XCTAssertEqual(result.map { $0.value }.sorted { $0.date > $1.date },
                       testData)
        verify(repository).read()
    }
    
    func testExecuteError() throws {
        // Arrange
        let repository = MockContributionRepository()
        stub(repository) { stub in
            when(stub).read().thenReturn(failAnswer())
        }
        let getContrubtion = GetContributionUseCase(repository: repository)
        
        // Act
        let result = try awaitError(getContrubtion(()))
        
        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
        verify(repository).read()
    }
}
