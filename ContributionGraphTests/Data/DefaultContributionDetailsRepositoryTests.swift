//
//  DefaultContributionDetailsRepositoryTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 31.08.2022.
//

import XCTest
import Cuckoo

@testable import ContributionGraph

extension ContributionDetails: Equatable {
    public static func == (lhs: ContributionDetails, rhs: ContributionDetails) -> Bool {
        lhs.date == rhs.date && lhs.notes == rhs.notes
    }
}

class DefaultContributionDetailsRepositoryTests: XCTestCase {
    typealias DtoMockMapperInput = (Date, ContributionNote, CDContribution?, StorageContext)
    typealias DtoMockMapper = MockMapper<DtoMockMapperInput,
                                     Result<CDContributionNote, Error>>
    typealias StorageResult = Result<(context: StorageContext, items: [CDContribution]), Error>
    
    func testRead() throws {
        // Arrange
        let test = (dto: CDContribution(),
                    details: ContributionDetails(date: Date.neutral,
                                                 notes: [ContributionNote(changed: Date.now, note: "test")]))
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(.success((context: MockStorageContext(), items: [test.dto])))
            }
        }
        let mapper = MockMapper<CDContribution, ContributionDetails?>()
        stub(mapper) { stub in
            when(stub).map(input: test.dto)
                .thenReturn(test.details)
        }
        let repository = DefaultContributionDetailsRepository(storage: storage,
                                                              mapper: MockAnyMapper(mapper),
                                                              dtoMapper: MockAnyMapper())
        
        // Act
        let result = try awaitPublisher(repository.read(date: Date.neutral))
        
        // Assert
        XCTAssertEqual(result, test.details)
        verify(mapper).map(input: test.dto)
    }
    
    func testReadNoDetails() throws {
        // Arrange
        let testDto = CDContribution()
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(.success((context: MockStorageContext(), items: [testDto])))
            }
        }
        let mapper = MockMapper<CDContribution, ContributionDetails?>()
        stub(mapper) { stub in
            when(stub).map(input: testDto)
                .thenReturn(nil)
        }
        let repository = DefaultContributionDetailsRepository(storage: storage,
                                                              mapper: MockAnyMapper(mapper),
                                                              dtoMapper: MockAnyMapper())
        
        // Act
        let result = try awaitPublisher(repository.read(date: Date.neutral))
        
        // Assert
        XCTAssertNil(result)
        verify(mapper).map(input: testDto)
    }
    
    func testReadError() throws {
        // Arrange
        let testError = TestError.someError
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.failure(testError))
            }
        }
        let repository = DefaultContributionDetailsRepository(storage: storage,
                                                              mapper: MockAnyMapper(),
                                                              dtoMapper: MockAnyMapper())
        
        // Act
        let result = try awaitError(repository.read(date: Date.neutral))
        
        // Assert
        XCTAssertEqual(result as? TestError, testError)
    }

    func testWrite() throws {
        // Arrange
        let test = (date: Date.neutral,
                    note: ContributionNote(changed: Date.now, note: "Test"),
                    dto: CDContribution(),
                    dtoNote: CDContributionNote())
        let storage = MockStorage()
        let context = MockStorageContext()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(.success((context: context, items: [test.dto])))
            }
        }
        let dtoMapper = DtoMockMapper()
        stub(dtoMapper) { stub in
            when(stub).map(input: any())
                .thenReturn(.success(test.dtoNote))
        }
        stub(context) { stub in
            when(stub).save().thenDoNothing()
        }
        let repository = DefaultContributionDetailsRepository(storage: storage,
                                                              mapper: MockAnyMapper(),
                                                              dtoMapper: MockAnyMapper(dtoMapper))
        
        // Act
        try awaitPublisher(repository.write(test.note, at: test.date))
        
        // Assert
        let dtoMapperArguments = ArgumentCaptor<DtoMockMapperInput>()
        verify(dtoMapper).map(input: dtoMapperArguments.capture())
        let value = dtoMapperArguments.value
        XCTAssert((value?.0, value?.1, value?.2) == (test.date, test.note, test.dto))
        verify(context).save()
    }
    
    func testWriteStorageError() throws {
        // Arrange
        let testError = TestError.someError
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.failure(testError))
            }
        }
        let repository = DefaultContributionDetailsRepository(storage: storage,
                                                              mapper: MockAnyMapper(),
                                                              dtoMapper: MockAnyMapper())
        
        // Act
        let result = try awaitError(repository.write(ContributionNote(changed: Date.now, note: "Test"),
                                                     at: Date.neutral))
        
        // Assert
        XCTAssertEqual(result as? TestError, testError)
    }
    
    func testWriteMapperError() throws {
        // Arrange
        let testError = TestError.someError
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(.success((context: StorageContextStub(),
                                 items: [CDContribution()])))
            }
        }
        let dtoMapper = DtoMockMapper()
        stub(dtoMapper) { stub in
            when(stub).map(input: any())
                .thenReturn(.failure(TestError.someError))
        }
        let repository = DefaultContributionDetailsRepository(storage: storage,
                                                              mapper: MockAnyMapper(),
                                                              dtoMapper: MockAnyMapper(dtoMapper))
        
        // Act
        let result = try awaitError(repository.write(ContributionNote(changed: Date.now, note: "Test"),
                                                     at: Date.neutral))
        
        // Assert
        XCTAssertEqual(result as? TestError, testError)
        verify(dtoMapper).map(input: any())
    }
    
    func testWriteContextSaveError() throws {
        // Arrange
        let testError = TestError.someError
        let storage = MockStorage()
        let context = MockStorageContext()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(.success((context: context, items: [CDContribution()])))
            }
        }
        let dtoMapper = DtoMockMapper()
        stub(dtoMapper) { stub in
            when(stub).map(input: any())
                .thenReturn(.success(CDContributionNote()))
        }
        stub(context) { stub in
            when(stub).save().thenThrow(testError)
        }
        let repository = DefaultContributionDetailsRepository(storage: storage,
                                                              mapper: MockAnyMapper(),
                                                              dtoMapper: MockAnyMapper(dtoMapper))
        
        // Act
        let result = try awaitError(repository.write(ContributionNote(changed: Date.now, note: "Test"),
                                                     at: Date.neutral))
        
        // Assert
        XCTAssertEqual(result as? TestError, testError)
        verify(context).save()
    }
}
