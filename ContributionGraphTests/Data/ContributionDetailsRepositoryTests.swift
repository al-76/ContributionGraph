//
//  ContributionDetailsRepositoryTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 31.08.2022.
//

import XCTest

@testable import ContributionGraph

extension ContributionDetails: Equatable {
    public static func == (lhs: ContributionDetails, rhs: ContributionDetails) -> Bool {
        lhs.date == rhs.date && lhs.notes == rhs.notes
    }
}

class ContributionDetailsRepositoryTests: XCTestCase {
    typealias OnCompletion = StorageMock.OnCompletion<CDContribution>

    private var storage: StorageMock!
    private var mapper: ContributionDetailsMapperMock!
    private var dtoMapper: DtoContributionNoteMapperMock!
    private var repository: ContributionDetailsRepository!

//    typealias DtoMockMapperInput = (Date, ContributionNote, CDContribution?, StorageContext)
//    typealias DtoMockMapper = MockMapper<DtoMockMapperInput,
//                                     Result<CDContributionNote, Error>>
//    typealias StorageResult = Result<(context: StorageContext, items: [CDContribution]), Error>

    override func setUp() {
        super.setUp()

        storage = StorageMock()
        mapper = ContributionDetailsMapperMock()
        dtoMapper = DtoContributionNoteMapperMock()
        repository = DefaultContributionDetailsRepository(storage: storage,
                                                          mapper: mapper, dtoMapper: dtoMapper)
    }

    func testRead() throws {
        // Arrange
        let test = (dto: CDContribution(),
                    details: ContributionDetails(date: Date.neutral,
                                                 notes: [ContributionNote("test")]))
        storage.fetchHandler = { _, _, completion in
            guard let completion = completion as? OnCompletion else {
                return
            }
            completion(.success((context: StorageContextMock(),
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
        let testDto = CDContribution()
        storage.fetchHandler = { _, _, completion in
            guard let completion = completion as? OnCompletion else {
                return
            }
            completion(.success((context: StorageContextMock(),
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
            guard let completion = completion as? OnCompletion else {
                return
            }
            completion(.failure(testError))
        }
        mapper.mapHandler = { _ in nil }

        // Act
        let result = try awaitError(repository.read(date: Date.neutral))

        // Assert
        XCTAssertEqual(result as? TestError, testError)
    }

//    func testWrite() throws {
//        // Arrange
//        let test = (date: Date.neutral,
//                    note: ContributionNote("test"),
//                    dto: CDContribution(),
//                    dtoNote: CDContributionNote())
//        let storage = MockStorage()
//        let context = MockStorageContext()
//        stub(storage) { stub in
//            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
//                args.2(.success((context: context, items: [test.dto])))
//            }
//        }
//        let dtoMapper = DtoMockMapper()
//        stub(dtoMapper) { stub in
//            when(stub).map(input: any())
//                .thenReturn(.success(test.dtoNote))
//        }
//        stub(context) { stub in
//            when(stub).save().thenDoNothing()
//        }
//        let repository = DefaultContributionDetailsRepository(storage: storage,
//                                                              mapper: mockAnyMapper(),
//                                                              dtoMapper: mockAnyMapper(dtoMapper))
//
//        // Act
//        try awaitPublisher(repository.write(test.note, at: test.date))
//
//        // Assert
//        let dtoMapperArguments = ArgumentCaptor<DtoMockMapperInput>()
//        verify(dtoMapper).map(input: dtoMapperArguments.capture())
//        let value = dtoMapperArguments.value
//        XCTAssert((value?.0, value?.1, value?.2) == (test.date, test.note, test.dto))
//        verify(context).save()
//    }
//
//    func testWriteStorageError() throws {
//        // Arrange
//        let testError = TestError.someError
//        let storage = MockStorage()
//        stub(storage) { stub in
//            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
//                args.2(StorageResult.failure(testError))
//            }
//        }
//        let repository = DefaultContributionDetailsRepository(storage: storage,
//                                                              mapper: mockAnyMapper(),
//                                                              dtoMapper: mockAnyMapper())
//
//        // Act
//        let result = try awaitError(repository.write(ContributionNote("test"),
//                                                     at: Date.neutral))
//
//        // Assert
//        XCTAssertEqual(result as? TestError, testError)
//    }
//
//    func testWriteMapperError() throws {
//        // Arrange
//        let testError = TestError.someError
//        let storage = MockStorage()
//        stub(storage) { stub in
//            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
//                args.2(.success((context: StorageContextStub(),
//                                 items: [CDContribution()])))
//            }
//        }
//        let dtoMapper = DtoMockMapper()
//        stub(dtoMapper) { stub in
//            when(stub).map(input: any())
//                .thenReturn(.failure(TestError.someError))
//        }
//        let repository = DefaultContributionDetailsRepository(storage: storage,
//                                                              mapper: mockAnyMapper(),
//                                                              dtoMapper: mockAnyMapper(dtoMapper))
//
//        // Act
//        let result = try awaitError(repository.write(ContributionNote("test"),
//                                                     at: Date.neutral))
//
//        // Assert
//        XCTAssertEqual(result as? TestError, testError)
//        verify(dtoMapper).map(input: any())
//    }
//
//    func testWriteContextSaveError() throws {
//        // Arrange
//        let testError = TestError.someError
//        let storage = MockStorage()
//        let context = MockStorageContext()
//        stub(storage) { stub in
//            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
//                args.2(.success((context: context, items: [CDContribution()])))
//            }
//        }
//        let dtoMapper = DtoMockMapper()
//        stub(dtoMapper) { stub in
//            when(stub).map(input: any())
//                .thenReturn(.success(CDContributionNote()))
//        }
//        stub(context) { stub in
//            when(stub).save().thenThrow(testError)
//        }
//        let repository = DefaultContributionDetailsRepository(storage: storage,
//                                                              mapper: mockAnyMapper(),
//                                                              dtoMapper: mockAnyMapper(dtoMapper))
//
//        // Act
//        let result = try awaitError(repository.write(ContributionNote("test"),
//                                                     at: Date.neutral))
//
//        // Assert
//        XCTAssertEqual(result as? TestError, testError)
//        verify(context).save()
//    }
}
