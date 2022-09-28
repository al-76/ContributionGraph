//
//  ContributionSettingsRepositoryTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 28.09.2022.
//

import XCTest
import Combine

@testable import ContributionGraph

final class ContributionSettingsRepositoryTests: XCTestCase {
    typealias SettingsMapper = MapperMock<CDContributionSettings?,
                                            ContributionSettings>
    typealias DtoSettingsMapper = MapperMock<(ContributionSettings,
                                              CDContributionSettings?,
                                              StorageContext),
                                                Result<CDContributionSettings, Error>>

    private var storage: StorageMock!
    private var mapper: SettingsMapper!
    private var dtoMapper: DtoSettingsMapper!
    private var repository: ContributionSettingsRepository!

    override func setUp() {
        super.setUp()

        storage = StorageMock()
        mapper = SettingsMapper()
        dtoMapper = DtoSettingsMapper()
        repository = DefaultContributionSettingsRepository(storage: storage,
                                                           mapper: mapper,
                                                           dtoMapper: dtoMapper)
    }

    func testRead() throws {
        // Arrange
        let test = (settings: ContributionSettings(weekCount: 15),
                    dto: CDContributionSettings())
        storage.fetchHandler = {
            storageMockHandler($2,
                               .success((StorageContextMock(),
                                         [test.dto])))
        }
        mapper.mapHandler = { _ in test.settings }

        // Act
        let result = try awaitPublisher(repository.read())

        // Assert
        XCTAssertEqual(result, test.settings)
        XCTAssertEqual(mapper.mapArgValues.first, test.dto)
        XCTAssertEqual(storage.fetchCallCount, 1)
    }

    func testReadError() throws {
        // Arrange
        let testError = TestError.someError
        storage.fetchHandler = {
            storageMockHandler($2,
                               .failure(TestError.someError),
                               CDContributionSettings.self)
        }

        // Act
        let result = try awaitError(repository.read())

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
    }

    func testWrite() throws {
        // Arrange
        let test = (settings: ContributionSettings(weekCount: 15),
                    dto: CDContributionSettings(),
                    context: StorageContextMock())
        storage.fetchHandler = {
            storageMockHandler($2,
                               .success((test.context,
                                         [test.dto])))
        }
        dtoMapper.mapHandler = { _ in .success(test.dto) }

        // Act
        try awaitPublisher(repository.write(settings: test.settings))

        // Assert
        let values = dtoMapper.mapArgValues.first
        XCTAssertEqual(values?.0, test.settings)
        XCTAssertEqual(values?.1, test.dto)
        XCTAssertEqual(test.context.saveCallCount, 1)
    }

    func testWriteFetchError() throws {
        // Arrange
        let testError = TestError.someError
        storage.fetchHandler = {
            storageMockHandler($2,
                               .failure(TestError.someError),
                               CDContributionSettings.self)
        }

        // Act
        let result = try awaitError(repository.write(settings: ContributionSettings(weekCount: 15)))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
    }

    func testWriteMapperError() throws {
        // Arrange
        let testError = TestError.someError
        storage.fetchHandler = {
            storageMockHandler($2,
                               .success((StorageContextMock(),
                                         [CDContributionSettings()])))
        }
        dtoMapper.mapHandler = { _ in .failure(testError) }

        // Act
        let result = try awaitError(repository.write(settings: ContributionSettings(weekCount: 15)))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
    }
}
