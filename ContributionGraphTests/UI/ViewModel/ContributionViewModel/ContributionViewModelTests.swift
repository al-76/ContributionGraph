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
    // swiftlint:disable line_length
    private let data = ContributionViewModel.Data(items: [0: Contribution(days: 0)],
                                                  details: ContributionDetails(date: Date.neutral, notes: [ContributionNote("test")]),
                                                  settings: ContributionSettings(weekCount: 15),
                                                  metrics: ContributionMetrics(totalWeekCount: 50, totalContributionCount: 500))

    func testInitState() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(),
                                              getDetails: mockAnyUseCase(),
                                              getSettings: mockAnyUseCase(),
                                              setSettings: mockAnyUseCase(),
                                              getMetrics: mockAnyUseCase())

        // Act
        let result = try awaitPublisher(viewModel.$state)

        // Assert
        XCTAssertEqual(result, .loading)
    }

    func testFetchDataItemsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(failAnswer()),
                                              getDetails: mockAnyUseCase(noAnswer()),
                                              getSettings: mockAnyUseCase(noAnswer()),
                                              setSettings: mockAnyUseCase(noAnswer()),
                                              getMetrics: mockAnyUseCase(noAnswer()))

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchDataSettingsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
                                              getSettings: mockAnyUseCase(failAnswer()),
                                              setSettings: mockAnyUseCase(noAnswer()),
                                              getMetrics: mockAnyUseCase(noAnswer()))

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchDataMetricsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(noAnswer()),
                                              getMetrics: mockAnyUseCase(failAnswer()))

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchDataDetailsError() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(failAnswer()),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(noAnswer()),
                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchData() throws {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))

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
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(successAnswer(newData.settings)),
                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))

        // Act
        viewModel.set(settings: newData.settings)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(newData))
    }

    func testSetSettingsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(failAnswer()),
                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))

        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testSetSettingsItemsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(failAnswer()),
                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(failAnswer()),
                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))

        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testSetSettingsMetricsError() {
        // Arrange
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              getMetrics: mockAnyUseCase(failAnswer()))

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
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(successAnswer(nil)),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(),
                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
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
        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
                                              getDetails: mockAnyUseCase(failAnswer()),
                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
                                              setSettings: mockAnyUseCase(),
                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.fetchContribtuionDetails(at: 2)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .failure(TestError.someError))
    }
}
