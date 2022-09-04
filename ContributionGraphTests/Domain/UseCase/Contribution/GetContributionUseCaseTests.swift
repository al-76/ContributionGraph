////
////  GetContributionUseCaseTests.swift
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
//class GetContributionUseCaseTests: XCTestCase {
//    func testExecute() throws {
//        // Arrange
//        let testData = [Contribution(days: 0),
//                        Contribution(days: 1),
//                        Contribution(days: 2)]
//        let repository = mock(ContributionRepository.self)
//        given(repository.read()).willReturn(successAnswer(testData))
//        let getContrubtion = GetContributionUseCase(repository: repository)
//
//        // Act
//        let result = try awaitPublisher(getContrubtion(()))
//
//        // Assert
//        XCTAssertEqual(result.map { $0.value }.sorted { $0.date > $1.date },
//                       testData)
//        verify(repository.read()).wasCalled()
//    }
//
//    func testExecuteError() throws {
//        // Arrange
//        let repository = mock(ContributionRepository.self)
//        given(repository.read()).willReturn(failAnswer())
//        let getContrubtion = GetContributionUseCase(repository: repository)
//
//        // Act
//        let result = try awaitError(getContrubtion(()))
//
//        // Assert
//        XCTAssertEqual(result as? TestError, TestError.someError)
//        verify(repository.read()).wasCalled()
//    }
//}
