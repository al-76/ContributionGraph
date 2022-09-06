//
//  ContributionDetailsRepositoryTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 31.08.2022.
//

import XCTest

@testable import ContributionGraph

class ContributionDetailsRepositoryTests: XCTestCase {
    private var storage: StorageMock!
    private var mapper: ContributionDetailsMapperMock!
    private var dtoMapper: DtoContributionNoteMapperMock!
    private var repository: ContributionDetailsRepository!

    override func setUp() {
        super.setUp()

        storage = StorageMock()
        mapper = ContributionDetailsMapperMock()
        dtoMapper = DtoContributionNoteMapperMock()
        repository = DefaultContributionDetailsRepository(storage: storage,
                                                          mapper: mapper,
                                                          dtoMapper: dtoMapper)
    }

    func testRead() throws {
        // Arrange
        let test = (dto: CDContribution(),
                    details: ContributionDetails(date: Date.neutral,
                                                 notes: [ContributionNote("test")]))
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: StorageContextMock(),
                                         items: [test.dto])))
        }
        mapper.mapHandler = { _ in test.details }

        // Act
        let result = try awaitPublisher(repository.read(date: Date.neutral))

        // Assert
        XCTAssertEqual(result, test.details)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(mapper.mapCallCount, 1)
    }

    func testReadNoDetails() throws {
        // Arrange
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: StorageContextMock(),
                                         items: [CDContribution]())))
        }

        // Act
        let result = try awaitPublisher(repository.read(date: Date.neutral))

        // Assert
        XCTAssertNil(result)
        XCTAssertEqual(storage.fetchCallCount, 1)
    }

    func testReadNoDetailsInContribution() throws {
        // Arrange
        let testDto = CDContribution()
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: StorageContextMock(),
                                         items: [testDto])))
        }
        mapper.mapHandler = { _ in nil }

        // Act
        let result = try awaitPublisher(repository.read(date: Date.neutral))

        // Assert
        XCTAssertNil(result)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(mapper.mapCallCount, 1)
    }

    func testReadError() throws {
        // Arrange
        let testError = TestError.someError
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .failure(TestError.someError),
                               CDContribution.self)
        }

        // Act
        let result = try awaitError(repository.read(date: Date.neutral))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
    }

    func testWrite() throws {
        // Arrange
        let test = (date: Date.neutral,
                    note: ContributionNote("test"),
                    dto: CDContribution(),
                    dtoNote: CDContributionNote())
        let context = StorageContextMock()
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: context,
                                         items: [test.dto])))
        }
        dtoMapper.mapHandler = { _ in .success(test.dtoNote) }
        context.saveHandler = {}

        // Act
        try awaitPublisher(repository.write(test.note, at: test.date))

        // Assert
        let value = dtoMapper.mapArgValues.last
        XCTAssert((value?.0, value?.1, value?.2) == (test.date, test.note, test.dto))
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(dtoMapper.mapCallCount, 1)
        XCTAssertEqual(context.saveCallCount, 1)
    }

    func testWriteStorageError() throws {
        // Arrange
        let testError = TestError.someError
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .failure(TestError.someError),
                               CDContribution.self)
        }

        // Act
        let result = try awaitError(repository.write(ContributionNote("test"),
                                                     at: Date.neutral))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
    }

    func testWriteMapperError() throws {
        // Arrange
        let testError = TestError.someError
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: StorageContextMock(),
                                         items: [CDContribution()])))
        }
        dtoMapper.mapHandler = { _ in .failure(TestError.someError)}

        // Act
        let result = try awaitError(repository.write(ContributionNote("test"),
                                                     at: Date.neutral))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(dtoMapper.mapCallCount, 1)
    }

    func testWriteContextSaveError() throws {
        // Arrange
        let testError = TestError.someError
        let context = StorageContextMock()
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: context,
                                         items: [CDContribution()])))
        }
        dtoMapper.mapHandler = { _ in .success(CDContributionNote()) }
        context.saveHandler = { throw testError }

        // Act
        let result = try awaitError(repository.write(ContributionNote("test"),
                                                     at: Date.neutral))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(dtoMapper.mapCallCount, 1)
        XCTAssertEqual(context.saveCallCount, 1)
    }
}
