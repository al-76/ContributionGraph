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
                                                  metrics: ContributionMetrics(totalWeekCount: 50, totalContributionCount: 500),
                                                  selectedDay: 0,
                                                  editingNote: nil)
    private var getItems: GetContributionUseCaseMock!
    private var getDetails: GetContributionDetailsUseCaseMock!
    private var getSettings: GetContributionSettingsUseCaseMock!
    private var setSettings: SetContributionSettingsUseCaseMock!
    private var getMetrics: GetContributionMetricsUseCaseMock!
    private var viewModel: ContributionViewModel!

    override func setUp() {
        super.setUp()

        getItems = GetContributionUseCaseMock()
        getDetails = GetContributionDetailsUseCaseMock()
        getSettings = GetContributionSettingsUseCaseMock()
        setSettings = SetContributionSettingsUseCaseMock()
        getMetrics = GetContributionMetricsUseCaseMock()
        viewModel = ContributionViewModel(getItems: getItems,
                                          getDetails: getDetails,
                                          getSettings: getSettings,
                                          setSettings: setSettings,
                                          getMetrics: getMetrics)
    }

    func testInitState() throws {
        // Arrange

        // Act
        let result = try awaitPublisher(viewModel.$state)

        // Assert
        XCTAssertEqual(result, .loading)
    }

    func testFetchDataItemsError() throws {
        // Arrange
        getItems.callAsFunctionHandler = { failAnswer() }
        getDetails.callAsFunctionHandler = { _ in noAnswer() }
        getSettings.callAsFunctionHandler = { noAnswer() }
        getMetrics.callAsFunctionHandler = { noAnswer() }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchDataSettingsError() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(nil) }
        getSettings.callAsFunctionHandler = { failAnswer() }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
//
    func testFetchDataMetricsError() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(nil) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { failAnswer() }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchDataDetailsError() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in failAnswer() }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchData() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(data))
    }

    func testFetchDataDouble() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }

        // Act
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(data))
    }

    func testSetSettings() throws {
        // Arrange
        let data = data
        let newData = data.copy(settings: ContributionSettings(weekCount: 200))
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        setSettings.callAsFunctionHandler = { _ in successAnswer(newData.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.set(settings: newData.settings)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(newData))
    }

    func testSetSettingsError() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        setSettings.callAsFunctionHandler = { _ in failAnswer() }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 500))

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testSetSettingsSkipLoading() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        setSettings.callAsFunctionHandler = { _ in successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }

        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 100))

        // Assert
        XCTAssertEqual(setSettings.callAsFunctionCallCount, 0)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .loading)
    }

    func testSetSettingsSkipError() throws {
        // Arrangee
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        setSettings.callAsFunctionHandler = { _ in successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { failAnswer() }

        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 100))

        // Assert
        XCTAssertEqual(setSettings.callAsFunctionCallCount, 0)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .failure(TestError.someError))
    }

    func testSetSelectedDay() throws {
        // Arrange
        let testDay = 10
        let testData = data.copy(selectedDay: testDay)
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.set(selectedDay: testDay)

        // Answer
        XCTAssertEqual(try awaitPublisher(viewModel.$state), .success(testData))
    }

    func testSetEditingNote() throws {
        let testNote = ContributionNote("editingTest")
        let testData = data.copy(editingNote: testNote)
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.set(editingNote: testNote)

        // Answer
        XCTAssertEqual(try awaitPublisher(viewModel.$state), .success(testData))
    }

    func testFetchContributionDetails() throws {
        // Arrange
        let testData = data.copy(details: ContributionDetails(date: Date.now, notes: [ContributionNote("test")]))
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(nil) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())
        getDetails.callAsFunctionHandler = { _ in successAnswer(testData.details) }

        // Act
        viewModel.fetchContribtuionDetails()

        // Assert
        let res = try awaitPublisher(viewModel.$state.dropFirst())
        XCTAssertEqual(res,
                       .success(testData))
    }

    func testFetchContributionDetailsError() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(nil)  }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())
        getDetails.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.fetchContribtuionDetails()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchContributionDetailsSkipLoading() throws {
        // Arrange

        // Act
        viewModel.fetchContribtuionDetails()

        // Assert
        XCTAssertEqual(getDetails.callAsFunctionCallCount, 0)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .loading)
    }

    func testFetchContributionDetailsSkipError() throws {
        // Arrange
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { failAnswer() }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.fetchContribtuionDetails()

        // Assert
        XCTAssertEqual(getDetails.callAsFunctionCallCount, 1)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .failure(TestError.someError))
    }

    func testFetchContributionDetailsSetNil() throws {
        // Arrange
        let testData = data.copy(details: nil)
        let data = data
        getItems.callAsFunctionHandler = { successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { successAnswer(data.metrics) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())
        getDetails.callAsFunctionHandler = { _ in successAnswer(nil) }

        // Act
        viewModel.fetchContribtuionDetails()

        // Assert
        let res = try awaitPublisher(viewModel.$state.dropFirst())
        XCTAssertEqual(res, .success(testData))
    }
}
