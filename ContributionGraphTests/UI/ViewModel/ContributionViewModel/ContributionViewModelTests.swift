//
//  ContributionViewModelTests.swift
//  ContributionViewModelTests
//
//  Created by Vyacheslav Konopkin on 04.08.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

class ContributionViewModelTests: XCTestCase {
    private let data = ContributionViewModel.Data(items: [0: ContributionItem(date: Date.now, notes: ["Test"])],
                                                  settings: ContributionSettings(weekCount: 15),
                                                  metrics: ContributionMetrics(totalWeekCount: 50, totalContributionCount: 500))
    
    func testInitState() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase()),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase()),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase()),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase()))
        
        // Act
        let result = try awaitPublisher(viewModel.$state)
        
        // Assert
        XCTAssertEqual(result, .loading)
    }
    
    func testFetchDataItemsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase(failAnswer())),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase(noAnswer())),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase(noAnswer())),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase(noAnswer())))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchDataSettingsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.items))),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase(failAnswer())),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase(noAnswer())),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase(noAnswer())))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchDataMetricsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.items))),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.settings))),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase(noAnswer())),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase(failAnswer())))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchData() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.items))),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.settings))),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.settings))),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.metrics))))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(data))
    }
    
    func testSetSettings() {
        // Arrange
        let newData = ContributionViewModel.Data(items: data.items,
                                                 settings: ContributionSettings(weekCount: 400),
                                                 metrics: data.metrics)
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.items))),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.settings))),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(newData.settings))),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.metrics))))
        
        
        // Act
        viewModel.set(settings: newData.settings)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(newData))
    }
    
    func testSetSettingsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.items))),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.settings))),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase(failAnswer())),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.metrics))))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testSetSettingsItemsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase(failAnswer())),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.settings))),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase(failAnswer())),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.metrics))))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testSetSettingsMetricsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.items))),
                                              getSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.settings))),
                                              setSettingsUseCase: AnyUseCase(wrapped: MockUseCase(successAnswer(data.settings))),
                                              getMetricsUseCase: AnyUseCase(wrapped: MockUseCase(failAnswer())))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
}
