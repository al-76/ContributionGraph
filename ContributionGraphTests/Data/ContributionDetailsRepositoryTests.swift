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
    private var detailsMapper: ContributionDetailsMapperMock!
    private var dtoNoteMapper: DtoContributionNoteMapperMock!
    private var dtoContributionMapper: DtoContributionMapperMock!
    private var repository: ContributionDetailsRepository!

    override func setUp() {
        super.setUp()

        storage = StorageMock()
        detailsMapper = ContributionDetailsMapperMock()
        dtoNoteMapper = DtoContributionNoteMapperMock()
        dtoContributionMapper = DtoContributionMapperMock()
        repository = DefaultContributionDetailsRepository(storage: storage,
                                                          detailsMapper: detailsMapper,
                                                          dtoNoteMapper: dtoNoteMapper,
                                                          dtoContributionMapper: dtoContributionMapper)
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
        detailsMapper.mapHandler = { _ in test.details }

        // Act
        let result = try awaitPublisher(repository.read(date: Date.neutral))

        // Assert
        XCTAssertEqual(result, test.details)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(detailsMapper.mapCallCount, 1)
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
        detailsMapper.mapHandler = { _ in nil }

        // Act
        let result = try awaitPublisher(repository.read(date: Date.neutral))

        // Assert
        XCTAssertNil(result)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(detailsMapper.mapCallCount, 1)
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
        dtoNoteMapper.mapHandler = { _ in .success(test.dtoNote) }
        context.saveHandler = {}

        // Act
        try awaitPublisher(repository.write(test.note, at: test.date))

        // Assert
        let value = dtoNoteMapper.mapArgValues.first
        XCTAssert((value?.0, value?.1, value?.2) == (test.date, test.note, test.dto))
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(dtoNoteMapper.mapCallCount, 1)
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
        dtoNoteMapper.mapHandler = { _ in .failure(TestError.someError)}

        // Act
        let result = try awaitError(repository.write(ContributionNote("test"),
                                                     at: Date.neutral))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(dtoNoteMapper.mapCallCount, 1)
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
        dtoNoteMapper.mapHandler = { _ in .success(CDContributionNote()) }
        context.saveHandler = { throw testError }

        // Act
        let result = try awaitError(repository.write(ContributionNote("test"),
                                                     at: Date.neutral))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(dtoNoteMapper.mapCallCount, 1)
        XCTAssertEqual(context.saveCallCount, 1)
    }

    func testDelete() throws {
        // Arrange
        let test = (contribution: Contribution(days: 4),
                    modContribution: Contribution(date: Date.neutral.days(ago: 4), count: 1),
                    note: ContributionNote("test"),
                    dto: CDContribution(),
                    dtoNote: CDContributionNote())
        let context = StorageContextMock()
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: context,
                                         items: [test.dto])))
        }
        dtoContributionMapper.mapHandler = { _ in test.dto }
        dtoNoteMapper.mapHandler = { _ in .success(test.dtoNote) }
        context.deleteHandler = { _ in }
        context.saveHandler = {}

        // Act
        try awaitPublisher(repository.delete(test.note, to: test.contribution))

        // Assert
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssert(dtoContributionMapper.mapArgValues.first! == (test.dto, test.modContribution))
        XCTAssertEqual(dtoContributionMapper.mapCallCount, 1)
        let value = dtoNoteMapper.mapArgValues.first
        XCTAssert((value?.0, value?.1, value?.2) == (test.contribution.date, test.note, test.dto))
        XCTAssertEqual(dtoNoteMapper.mapCallCount, 1)
        XCTAssertEqual(context.deleteArgValues.first as? CDContributionNote,
                       test.dtoNote)
        XCTAssertEqual(context.deleteCallCount, 1)
        XCTAssertEqual(context.saveCallCount, 1)
    }

    func testDeleteLastContribution() throws {
        // Arrange
        let test = (contribution: Contribution(date: Date.neutral, count: 1),
                    note: ContributionNote("test"),
                    dto: CDContribution(),
                    dtoNote: CDContributionNote())
        let context = StorageContextMock()
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: context,
                                         items: [test.dto])))
        }
        dtoContributionMapper.mapHandler = { _ in test.dto }
        dtoNoteMapper.mapHandler = { _ in .success(test.dtoNote) }
        context.deleteHandler = { _ in }
        context.saveHandler = {}

        // Act
        try awaitPublisher(repository.delete(test.note, to: test.contribution))

        // Assert
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(context.deleteCallCount, 2)
        XCTAssertEqual(context.deleteArgValues.first as? CDContributionNote,
                       test.dtoNote)
        XCTAssertEqual(context.deleteArgValues.last as? CDContribution,
                       test.dto)
        XCTAssertEqual(context.saveCallCount, 1)
    }

    func testDeleteErrorNoContribution() throws {
        // Arrange
        let testError = DefaultContributionDetailsRepository
            .RepositoryError.noContribution
        let test = (contribution: Contribution(days: 4),
                    note: ContributionNote("test"))
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: StorageContextMock(),
                                         items: [CDContribution]())))
        }

        // Act
        let result = try awaitError(repository.delete(test.note, to: test.contribution))

        // Assert
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(result as? DefaultContributionDetailsRepository.RepositoryError,
                       testError)
    }

    func testDeleteMapperError() throws {
        // Arrange
        let testError = TestError.someError
        let test = (contribution: Contribution(days: 4),
                    note: ContributionNote("test"),
                    dto: CDContribution())
        let context = StorageContextMock()
        storage.fetchHandler = { _, _, completion in
            storageMockHandler(completion,
                               .success((context: context,
                                         items: [test.dto])))
        }
        dtoContributionMapper.mapHandler = { _ in test.dto }
        dtoNoteMapper.mapHandler = { _ in .failure(testError) }

        // Act
        let result = try awaitError(repository.delete(test.note, to: test.contribution))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(dtoContributionMapper.mapCallCount, 1)
        XCTAssertEqual(dtoNoteMapper.mapCallCount, 1)
        XCTAssertEqual(context.deleteCallCount, 0)
        XCTAssertEqual(context.saveCallCount, 0)
    }
}
