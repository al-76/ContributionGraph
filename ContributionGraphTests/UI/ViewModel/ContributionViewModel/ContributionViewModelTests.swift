////
////  ContributionViewModelTests.swift
////  ContributionViewModelTests
////
////  Created by Vyacheslav Konopkin on 04.08.2022.
////
//
//import XCTest
//import Combine
//import Mockingbird
//
//@testable import ContributionGraph
//
//class ContributionViewModelTests: XCTestCase {
//    // swiftlint:disable line_length
//    private let data = ContributionViewModel.Data(items: [0: Contribution(days: 0)],
//                                                  details: ContributionDetails(date: Date.neutral, notes: [ContributionNote("test")]),
//                                                  settings: ContributionSettings(weekCount: 15),
//                                                  metrics: ContributionMetrics(totalWeekCount: 50, totalContributionCount: 500),
//                                                  selectedDay: 0)
//
//    func testInitState() throws {
//        // Arrange
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(),
//                                              getDetails: mockAnyUseCase(),
//                                              getSettings: mockAnyUseCase(),
//                                              setSettings: mockAnyUseCase(),
//                                              getMetrics: mockAnyUseCase())
//
//        // Act
//        let result = try awaitPublisher(viewModel.$state)
//
//        // Assert
//        XCTAssertEqual(result, .loading)
//    }
//
//    func testFetchDataItemsError() throws {
//        // Arrange
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(failAnswer()),
//                                              getDetails: mockAnyUseCase(noAnswer()),
//                                              getSettings: mockAnyUseCase(noAnswer()),
//                                              setSettings: mockAnyUseCase(noAnswer()),
//                                              getMetrics: mockAnyUseCase(noAnswer()))
//
//        // Act
//        viewModel.fetchContributionData()
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .failure(TestError.someError))
//    }
//
//    func testFetchDataSettingsError() throws {
//        // Arrange
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(failAnswer()),
//                                              setSettings: mockAnyUseCase(noAnswer()),
//                                              getMetrics: mockAnyUseCase(noAnswer()))
//
//        // Act
//        viewModel.fetchContributionData()
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .failure(TestError.someError))
//    }
//
//    func testFetchDataMetricsError() throws {
//        // Arrange
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(noAnswer()),
//                                              getMetrics: mockAnyUseCase(failAnswer()))
//
//        // Act
//        viewModel.fetchContributionData()
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .failure(TestError.someError))
//    }
//
//    func testFetchDataDetailsError() throws {
//        // Arrange
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(failAnswer()),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(noAnswer()),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//
//        // Act
//        viewModel.fetchContributionData()
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .failure(TestError.someError))
//    }
//
//    func testFetchData() throws {
//        // Arrange
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//
//        // Act
//        viewModel.fetchContributionData()
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .success(data))
//    }
//
//    func testFetchDataDouble() throws {
//        // Arrange
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//
//        // Act
//        viewModel.fetchContributionData()
//        try awaitPublisher(viewModel.$state.dropFirst())
//        viewModel.fetchContributionData()
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .success(data))
//    }
//
//    func testSetSettings() throws {
//        // Arrange
//        let newData = ContributionViewModel.Data(items: data.items,
//                                                 details: nil,
//                                                 settings: ContributionSettings(weekCount: 400),
//                                                 metrics: data.metrics,
//                                                 selectedDay: 0)
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(successAnswer(newData.settings)),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//        viewModel.fetchContributionData()
//        try awaitPublisher(viewModel.$state.dropFirst())
//
//        // Act
//        viewModel.set(settings: newData.settings)
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .success(newData))
//    }
//
//    func testSetSettingsError() throws {
//        // Arrange
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(failAnswer()),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//        viewModel.fetchContributionData()
//        try awaitPublisher(viewModel.$state.dropFirst())
//
//        // Act
//        viewModel.set(settings: ContributionSettings(weekCount: 500))
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .failure(TestError.someError))
//    }
//
//    func testSetSettingsSkipLoading() throws {
//        // Arrange
//        let setSettings = mock(UseCase<ContributionSettings, ContributionSettings>.self)
//        given(setSettings(any())).willReturn(successAnswer(data.settings))
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: AnyUseCase(wrapped: setSettings),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//
//        // Act
//        viewModel.set(settings: ContributionSettings(weekCount: 100))
//
//        // Assert
//        verify(setSettings(any())).wasNeverCalled()
//        XCTAssertEqual(try awaitPublisher(viewModel.$state),
//                       .loading)
//    }
//
//    func testSetSettingsSkipError() throws {
//        // Arrangee
//        let setSettings = mock(UseCase<ContributionSettings, ContributionSettings>.self)
//        given(setSettings(any())).willReturn(successAnswer(data.settings))
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: AnyUseCase(wrapped: setSettings),
//                                              getMetrics: mockAnyUseCase(failAnswer()))
//        viewModel.fetchContributionData()
//        try awaitPublisher(viewModel.$state.dropFirst())
//
//        // Act
//        viewModel.set(settings: ContributionSettings(weekCount: 100))
//
//        // Assert
//        verify(setSettings(any())).wasNeverCalled()
//        XCTAssertEqual(try awaitPublisher(viewModel.$state),
//                       .failure(TestError.someError))
//    }
//
//    func testSetSelectedDay() throws {
//        // Arrange
//        let testDay = 10
//        let testData = data.update(selectedDay: testDay)
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(data.details)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//        viewModel.fetchContributionData()
//        try awaitPublisher(viewModel.$state.dropFirst())
//
//        // Act
//        viewModel.set(selectedDay: testDay)
//
//        // Answer
//        XCTAssertEqual(try awaitPublisher(viewModel.$state), .success(testData))
//    }
//
//    func testFetchContributionDetails() throws {
//        // Arrange
//        let testData = ContributionViewModel.Data(items: data.items,
//                                                  details: nil,
//                                                  settings: data.settings,
//                                                  metrics: data.metrics,
//                                                  selectedDay: 0)
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: mockAnyUseCase(successAnswer(nil)),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//        viewModel.fetchContributionData()
//        try awaitPublisher(viewModel.$state.dropFirst())
//
//        // Act
//        viewModel.fetchContribtuionDetails(at: 2)
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .success(testData))
//    }
//
//    func testFetchContributionDetailsError() throws {
//        // Arrange
//        let testError = 20
//        let getDetails = mock(UseCase<Date, ContributionDetails?>.self)
//        given(getDetails(Date.neutral.days(ago: 0))).willReturn(successAnswer(data.details))
//        given(getDetails(Date.neutral.days(ago: testError))).willReturn(failAnswer())
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: AnyUseCase(wrapped: getDetails),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//        viewModel.fetchContributionData()
//        try awaitPublisher(viewModel.$state.dropFirst())
//
//        // Act
//        viewModel.fetchContribtuionDetails(at: testError)
//
//        // Assert
//        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
//                       .failure(TestError.someError))
//    }
//
//    func testFetchContributionDetailsSkipLoading() throws {
//        // Arrange
//        let getDetails = mock(UseCase<Date, ContributionDetails?>.self)
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: AnyUseCase(wrapped: getDetails),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              getMetrics: mockAnyUseCase(successAnswer(data.metrics)))
//
//        // Act
//        viewModel.fetchContribtuionDetails(at: 2)
//
//        // Assert
//        verify(getDetails(any())).wasNeverCalled()
//        XCTAssertEqual(try awaitPublisher(viewModel.$state),
//                       .loading)
//    }
//
//    func testFetchContributionDetailsSkipError() throws {
//        // Arrange
//        let getDetails = mock(UseCase<Date, ContributionDetails?>.self)
//        given(getDetails(any())).willReturn(successAnswer(data.details))
//        let viewModel = ContributionViewModel(getItems: mockAnyUseCase(successAnswer(data.items)),
//                                              getDetails: AnyUseCase(wrapped: getDetails),
//                                              getSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              setSettings: mockAnyUseCase(successAnswer(data.settings)),
//                                              getMetrics: mockAnyUseCase(failAnswer()))
//        viewModel.fetchContributionData()
//        try awaitPublisher(viewModel.$state.dropFirst())
//
//        // Act
//        viewModel.fetchContribtuionDetails(at: 2)
//
//        // Assert
//        verify(getDetails(any())).wasCalled()
//        XCTAssertEqual(try awaitPublisher(viewModel.$state),
//                       .failure(TestError.someError))
//    }
//}
