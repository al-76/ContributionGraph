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
    private let data = ContributionViewModel.Data(items: [0: Contribution(days: 0)],
                                                  details: ContributionDetails(date: Date.neutral, notes: [ContributionNote(changed: Date.now, note: "Test")]),
                                                  settings: ContributionSettings(weekCount: 15),
                                                  metrics: ContributionMetrics(totalWeekCount: 50, totalContributionCount: 500))
    
    func testInitState() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(),
                                              getDetails: MockAnyUseCase(),
                                              getSettings: MockAnyUseCase(),
                                              setSettings: MockAnyUseCase(),
                                              getMetrics: MockAnyUseCase())
        
        // Act
        let result = try awaitPublisher(viewModel.$state)
        
        // Assert
        XCTAssertEqual(result, .loading)
    }
    
    func testFetchDataItemsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(failAnswer()),
                                              getDetails: MockAnyUseCase(noAnswer()),
                                              getSettings: MockAnyUseCase(noAnswer()),
                                              setSettings: MockAnyUseCase(noAnswer()),
                                              getMetrics: MockAnyUseCase(noAnswer()))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchDataSettingsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(successAnswer(data.details)),
                                              getSettings: MockAnyUseCase(failAnswer()),
                                              setSettings: MockAnyUseCase(noAnswer()),
                                              getMetrics: MockAnyUseCase(noAnswer()))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchDataMetricsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(successAnswer(data.details)),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(noAnswer()),
                                              getMetrics: MockAnyUseCase(failAnswer()))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchDataDetailsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(failAnswer()),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(noAnswer()),
                                              getMetrics: MockAnyUseCase(successAnswer(data.metrics)))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchData() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(successAnswer(data.details)),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              getMetrics: MockAnyUseCase(successAnswer(data.metrics)))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(data))
    }
    
    func testSetSettings() {
        // Arrange
        let newData = ContributionViewModel.Data(items: data.items,
                                                 details: nil,
                                                 settings: ContributionSettings(weekCount: 400),
                                                 metrics: data.metrics)
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(successAnswer(data.details)),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(successAnswer(newData.settings)),
                                              getMetrics: MockAnyUseCase(successAnswer(data.metrics)))
        
        
        // Act
        viewModel.set(settings: newData.settings)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(newData))
    }
    
    func testSetSettingsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(successAnswer(data.details)),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(failAnswer()),
                                              getMetrics: MockAnyUseCase(successAnswer(data.metrics)))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testSetSettingsItemsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(failAnswer()),
                                              getDetails: MockAnyUseCase(successAnswer(data.details)),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(failAnswer()),
                                              getMetrics: MockAnyUseCase(successAnswer(data.metrics)))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testSetSettingsMetricsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(successAnswer(data.details)),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              getMetrics: MockAnyUseCase(failAnswer()))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchContributionDetails() throws {
        // Arrange
        let testData = ContributionViewModel.Data(items: data.items,
                                                  details: nil,
                                                  settings: data.settings,
                                                  metrics: data.metrics)
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(successAnswer(nil)),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(),
                                              getMetrics: MockAnyUseCase(successAnswer(data.metrics)))
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())
        
        // Act
        viewModel.fetchContribtuionDetails(at: 2)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .success(testData))
    }
    
    func testFetchContributionDetailsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: MockAnyUseCase(successAnswer(data.items)),
                                              getDetails: MockAnyUseCase(failAnswer()),
                                              getSettings: MockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: MockAnyUseCase(),
                                              getMetrics: MockAnyUseCase(successAnswer(data.metrics)))
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())
        
        // Act
        viewModel.fetchContribtuionDetails(at: 2)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .failure(TestError.someError))
    }
}
