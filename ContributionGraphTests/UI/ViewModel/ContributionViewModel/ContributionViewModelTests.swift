//
//  ContributionViewModelTests.swift
//  ContributionViewModelTests
//
//  Created by Vyacheslav Konopkin on 04.08.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

private struct FakeGetItemsUseCase: UseCase {
    let data: [Int : ContributionItem]
    
    func execute(with input: Void) -> AnyPublisher<[Int : ContributionItem], Error> {
        Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private struct FakeErrorItemsUseCase: UseCase {
    func execute(with input: Void) -> AnyPublisher<[Int : ContributionItem], Error> {
        Fail(error: TestError.someError)
            .eraseToAnyPublisher()
    }
}

private struct FakeGetSettingsUseCase: UseCase {
    let data: ContributionSettings
    
    func execute(with input: Void) -> AnyPublisher<ContributionSettings, Error> {
        Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private struct FakeSetSettingsUseCase: UseCase {
    func execute(with input: ContributionSettings) -> AnyPublisher<ContributionSettings, Error> {
        Just(input)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private struct FakeErrorSetSettingsUseCase: UseCase {
    func execute(with input: ContributionSettings) -> AnyPublisher<ContributionSettings, Error> {
        Fail(error: TestError.someError)
            .eraseToAnyPublisher()
    }
}

private struct FakeErrorGetSettingsUseCase: UseCase {
    func execute(with input: Void) -> AnyPublisher<ContributionSettings, Error> {
        Fail(error: TestError.someError)
            .eraseToAnyPublisher()
    }
}

private struct FakeGetMetricsUseCase: UseCase {
    let data: ContributionMetrics
    
    func execute(with input: Void) -> AnyPublisher<ContributionMetrics, Error> {
        Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private struct FakeErrorGetMetricsUseCase: UseCase {
    func execute(with input: Void) -> AnyPublisher<ContributionMetrics, Error> {
        Fail(error: TestError.someError)
            .eraseToAnyPublisher()
    }
}

class ContributionViewModelTests: XCTestCase {
    private let data = ContributionViewModel.Data(items: [0: ContributionItem(date: Date.now, notes: ["Test"])],
                                                  settings: ContributionSettings(weekCount: 15),
                                                  metrics: ContributionMetrics(totalWeekCount: 50, totalContributionCount: 500))
    
    func testInitState() throws {
        // Arrange
        let getItemsUseCase = FakeGetItemsUseCase(data: data.items)
        let getSettingsUseCase = FakeGetSettingsUseCase(data: data.settings)
        let setSettingsUseCase = FakeSetSettingsUseCase()
        let getMetricsUseCase = FakeGetMetricsUseCase(data: data.metrics)
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        
        // Act
        let result = try awaitPublisher(viewModel.$state)
        
        // Assert
        XCTAssertEqual(result, .loading)
    }
    
    func testFetchDataItemsError() throws {
        // Arrange
        let getItemsUseCase = FakeErrorItemsUseCase()
        let getSettingsUseCase = FakeGetSettingsUseCase(data: data.settings)
        let setSettingsUseCase = FakeSetSettingsUseCase()
        let getMetricsUseCase = FakeGetMetricsUseCase(data: data.metrics)
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchDataSettingsError() throws {
        // Arrange
        let getItemsUseCase = FakeGetItemsUseCase(data: data.items)
        let getSettingsUseCase = FakeErrorGetSettingsUseCase()
        let setSettingsUseCase = FakeSetSettingsUseCase()
        let getMetricsUseCase = FakeGetMetricsUseCase(data: data.metrics)
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchDataMetricsError() throws {
        // Arrange
        let getItemsUseCase = FakeGetItemsUseCase(data: data.items)
        let getSettingsUseCase = FakeGetSettingsUseCase(data: data.settings)
        let setSettingsUseCase = FakeSetSettingsUseCase()
        let getMetricsUseCase = FakeErrorGetMetricsUseCase()
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testFetchData() throws {
        // Arrange
        let getItemsUseCase = FakeGetItemsUseCase(data: data.items)
        let getSettingsUseCase = FakeGetSettingsUseCase(data: data.settings)
        let setSettingsUseCase = FakeSetSettingsUseCase()
        let getMetricsUseCase = FakeGetMetricsUseCase(data: data.metrics)
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        
        // Act
        viewModel.fetchContributionData()
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(data))
    }
    
    func testSetSettings() {
        // Arrange
        let getItemsUseCase = FakeGetItemsUseCase(data: data.items)
        let getSettingsUseCase = FakeGetSettingsUseCase(data: data.settings)
        let setSettingsUseCase = FakeSetSettingsUseCase()
        let getMetricsUseCase = FakeGetMetricsUseCase(data: data.metrics)
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        let newData = ContributionViewModel.Data(items: data.items,
                                                 settings: ContributionSettings(weekCount: 400),
                                                 metrics: data.metrics)
        
        // Act
        viewModel.set(settings: newData.settings)
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(newData))
    }
    
    func testSetSettingsError() {
        // Arrange
        let getItemsUseCase = FakeGetItemsUseCase(data: data.items)
        let getSettingsUseCase = FakeGetSettingsUseCase(data: data.settings)
        let setSettingsUseCase = FakeErrorSetSettingsUseCase()
        let getMetricsUseCase = FakeGetMetricsUseCase(data: data.metrics)
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testSetSettingsItemsError() {
        // Arrange
        let getItemsUseCase = FakeErrorItemsUseCase()
        let getSettingsUseCase = FakeGetSettingsUseCase(data: data.settings)
        let setSettingsUseCase = FakeErrorSetSettingsUseCase()
        let getMetricsUseCase = FakeGetMetricsUseCase(data: data.metrics)
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
    
    func testSetSettingsMetricsError() {
        // Arrange
        let getItemsUseCase = FakeGetItemsUseCase(data: data.items)
        let getSettingsUseCase = FakeGetSettingsUseCase(data: data.settings)
        let setSettingsUseCase = FakeSetSettingsUseCase()
        let getMetricsUseCase = FakeErrorGetMetricsUseCase()
        let viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: getItemsUseCase),
                                              getSettingsUseCase: AnyUseCase(wrapped: getSettingsUseCase),
                                              setSettingsUseCase: AnyUseCase(wrapped: setSettingsUseCase),
                                              getMetricsUseCase: AnyUseCase(wrapped: getMetricsUseCase))
        
        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))
        
        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
}
