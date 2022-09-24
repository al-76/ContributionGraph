//
//  ContributionViewModelTests.swift
//  ContributionViewModelTests
//
//  Created by Vyacheslav Konopkin on 04.08.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

// swiftlint:disable type_body_length
class ContributionViewModelTests: XCTestCase {
    // swiftlint:disable line_length
    private let data = ContributionViewModel.Data(items: [0: Contribution(days: 0)],
                                                  details: ContributionDetails(date: Date.neutral, notes: [ContributionNote("test")]),
                                                  settings: ContributionSettings(weekCount: 15),
                                                  metrics: ContributionMetrics(totalWeekCount: 50, totalContributionCount: 500),
                                                  selectedDay: 0,
                                                  editingNote: nil)
    private var getItems: UseCaseMock<Void, [Int: Contribution]>!
    private var getDetails: UseCaseMock<Date, ContributionDetails?>!
    private var getSettings: GetContributionSettingsUseCaseMock!
    private var setSettings: SetContributionSettingsUseCaseMock!
    private var getMetrics: UseCaseMock<Void, ContributionMetrics>!
    private var deleteNote: DeleteNoteUseCaseMock!
    private var viewModel: ContributionViewModel!

    override func setUp() {
        super.setUp()

        getItems = UseCaseMock<Void, [Int: Contribution]>()
        getDetails = UseCaseMock<Date, ContributionDetails?>()
        getSettings = GetContributionSettingsUseCaseMock()
        setSettings = SetContributionSettingsUseCaseMock()
        getMetrics = UseCaseMock<Void, ContributionMetrics>()
        deleteNote = DeleteNoteUseCaseMock()
        viewModel = ContributionViewModel(getItems: getItems,
                                          getDetails: getDetails,
                                          getSettings: getSettings,
                                          setSettings: setSettings,
                                          getMetrics: getMetrics,
                                          deleteNote: deleteNote)
        prepareViewModelState()
    }

    func testInitState() throws {
        // Arrange

        // Act
        let result = try awaitPublisher(viewModel.$state)

        // Assert
        XCTAssertEqual(result, .loading)
    }

    func testFetchData() throws {
        // Arrange

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(data))
    }

    func testFetchDataItemsError() throws {
        // Arrange
        getItems.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchDataSettingsError() throws {
        // Arrange
        getSettings.callAsFunctionHandler = { failAnswer() }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
//
    func testFetchDataMetricsError() throws {
        // Arrange
        getMetrics.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchDataDetailsError() throws {
        // Arrange
        getDetails.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.fetchContributionData()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchDataDouble() throws {
        // Arrange

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
        let newData = data.copy { $0.settings = ContributionSettings(weekCount: 200) }
        setSettings.callAsFunctionHandler = { _ in successAnswer(newData.settings) }
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
        setSettings.callAsFunctionHandler = { _ in failAnswer() }
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

        // Act
        viewModel.set(settings: ContributionSettings(weekCount: 100))

        // Assert
        XCTAssertEqual(setSettings.callAsFunctionCallCount, 0)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .loading)
    }

    func testSetSettingsSkipError() throws {
        // Arrangee
        getMetrics.callAsFunctionHandler = { _ in failAnswer() }
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
        let testData = data.copy { $0.selectedDay = testDay }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.set(selectedDay: testDay)

        // Answer
        XCTAssertEqual(try awaitPublisher(viewModel.$state), .success(testData))
    }

    func testSetEditingNote() throws {
        let testNote = ContributionNote("editingTest")
        let testData = data.copy { $0.editingNote = testNote }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.set(editingNote: testNote)

        // Answer
        XCTAssertEqual(try awaitPublisher(viewModel.$state), .success(testData))
    }

    func testFetchContributionDetails() throws {
        // Arrange
        let testData = data.copy { $0.details = ContributionDetails(date: Date.now, notes: [ContributionNote("test")]) }
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
        getMetrics.callAsFunctionHandler = { _ in failAnswer() }
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
        let testData = data.copy { $0.details = nil }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())
        getDetails.callAsFunctionHandler = { _ in successAnswer(nil) }

        // Act
        viewModel.fetchContribtuionDetails()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(testData))
    }

    func testDeleteDataNote() throws {
        // Arrange
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.deleteDataNote(at: 0)

        // Assert
        let args = deleteNote.callAsFunctionArgValues.first
        XCTAssertEqual(args?.0, data.details?.notes.first)
        XCTAssertEqual(args?.1, data.items[0])
        XCTAssertEqual(deleteNote.callAsFunctionCallCount, 1)
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(data))
    }

    func testDeleteDataNoteError() throws {
        // Arrange
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())
        deleteNote.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.deleteDataNote(at: 0)

        // Assert
        XCTAssertEqual(deleteNote.callAsFunctionCallCount, 1)
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testDeleteDataNoteErrorNoDetails() throws {
        // Arrange
        let testError = ContributionViewModel.ViewModelError
            .noData
        getDetails.callAsFunctionHandler = { _ in successAnswer(nil) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.deleteDataNote(at: 0)

        // Assert
        XCTAssertEqual(deleteNote.callAsFunctionCallCount, 0)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .failure(testError))
    }

    func testDeleteDataNoteErrorNoContribution() throws {
        // Arrange
        let testError = ContributionViewModel.ViewModelError
            .noData
        getItems.callAsFunctionHandler = { _ in successAnswer([:]) }
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.deleteDataNote(at: 0)

        // Assert
        XCTAssertEqual(deleteNote.callAsFunctionCallCount, 0)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .failure(testError))
    }

    func testDeleteDataNoteErrorWrongLargeIndex() throws {
        // Arrange
        let testIndex = 500
        let testError = ContributionViewModel.ViewModelError
            .wrongIndex(index: testIndex)
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.deleteDataNote(at: testIndex)

        // Assert
        XCTAssertEqual(deleteNote.callAsFunctionCallCount, 0)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .failure(testError))
    }

    func testDeleteDataNoteErrorWrongSmallIndex() throws {
        // Arrange
        let testIndex = -500
        let testError = ContributionViewModel.ViewModelError
            .wrongIndex(index: testIndex)
        viewModel.fetchContributionData()
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.deleteDataNote(at: testIndex)

        // Assert
        XCTAssertEqual(deleteNote.callAsFunctionCallCount, 0)
        XCTAssertEqual(try awaitPublisher(viewModel.$state),
                       .failure(testError))
    }

    private func prepareViewModelState() {
        let data = data
        getItems.callAsFunctionHandler = { _ in successAnswer(data.items) }
        getDetails.callAsFunctionHandler = { _ in successAnswer(data.details) }
        setSettings.callAsFunctionHandler = { _ in successAnswer(data.settings) }
        getSettings.callAsFunctionHandler = { successAnswer(data.settings) }
        getMetrics.callAsFunctionHandler = { _ in successAnswer(data.metrics) }
        deleteNote.callAsFunctionHandler = { _ in successAnswer(()) }
    }
}
