//
//  DefaultContributionRepositoryTests.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 27.08.2022.
//

import XCTest
import Combine
import Cuckoo

@testable import ContributionGraph

extension CDContribution: Matchable {}
extension CDContributionNote: Matchable {}

class DefaultContributionRepositoryTests: XCTestCase {
    typealias StorageResult = Result<(context: StorageContext, items: [CDContribution]), Error>
    
    func testRead() throws {
        // Arrange
        let testData = Contribution(days: 0, notes: [])
        let testDto = CDContribution()
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: isNil(), any(), onCompletion: any()).then { args in
                args.2(.success((context: MockStorageContext(), items: [testDto])))
            }
        }
        let mapper = MockMapper<CDContribution, Contribution>()
        stub(mapper) { stub in
            when(stub).map(input: testDto)
                .thenReturn(testData)
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       contributionMapper: AnyMapper(wrapped: mapper),
                                                       dtoContributionMapper: AnyMapper(wrapped: CDContributionMapper()),
                                                       dtoContributionUpdateMapper: AnyMapper(wrapped: MockMapper()),
                                                       contributionNoteMapper: AnyMapper(wrapped: CDContributionNoteMapper()))

        // Act
        let result = try awaitPublisher(repository.read())

        // Assert
        XCTAssertEqual(result, [testData])
        verify(mapper).map(input: testDto)
    }
    
    func testReadError() throws {
        // Arrange
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: isNil(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.failure(TestError.someError))
            }
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       contributionMapper: AnyMapper(wrapped: MockMapper()),
                                                       dtoContributionMapper: AnyMapper(wrapped: CDContributionMapper()),
                                                       dtoContributionUpdateMapper: AnyMapper(wrapped: MockMapper()),
                                                       contributionNoteMapper: AnyMapper(wrapped: CDContributionNoteMapper()))

        // Act
        let result = try awaitError(repository.read())

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
    
    func testWriteFirstNote() throws {
        // Arrange
        let testNote = NewContributionNote(day: 10, note: "Test")
        let context = StorageContextStub()
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.success((context: context, items: [])))
            }
        }
        let dtoMapper = MockMapper<(StorageContext, Contribution),
                                   Result<CDContribution, Error>>()
        stub(dtoMapper) { stub in
            when(stub).map(input: any())
                .thenReturn(.success(CDContribution()))
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       contributionMapper: AnyMapper(wrapped: MockMapper()),
                                                       dtoContributionMapper: AnyMapper(wrapped: dtoMapper),
                                                       dtoContributionUpdateMapper: AnyMapper(wrapped: MockMapper()),
                                                       contributionNoteMapper: AnyMapper(wrapped: MockMapper()))
        
        // Act
        try awaitPublisher(repository.write(note: testNote))
        
        // Assert
        let dtoMapperArguments = ArgumentCaptor<(StorageContext, Contribution)>()
        verify(dtoMapper).map(input: dtoMapperArguments.capture())
        XCTAssertEqual(dtoMapperArguments.value?.1.notes, [testNote.note])
    }
    
    func testWriteFirstNoteMapperError() throws {
        // Arrange
        let testNote = NewContributionNote(day: 10, note: "Test")
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.success((context: MockStorageContext(), items: [])))
            }
        }
        let dtoMapper = MockMapper<(StorageContext, Contribution),
                                   Result<CDContribution, Error>>()
        stub(dtoMapper) { stub in
            when(stub).map(input: any())
                .thenReturn(.failure(TestError.someError))
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       contributionMapper: AnyMapper(wrapped: MockMapper()),
                                                       dtoContributionMapper: AnyMapper(wrapped: dtoMapper),
                                                       dtoContributionUpdateMapper: AnyMapper(wrapped: MockMapper()),
                                                       contributionNoteMapper: AnyMapper(wrapped: MockMapper()))
        
        // Act
        let result = try awaitError(repository.write(note: testNote))
        
        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
    
    func testWriteSecondNote() throws {
        // Arrange
        let testNote = NewContributionNote(day: 10, note: "Test")
        let testDtoContribution = CDContribution()
        let testDtoNote = CDContributionNote()
        let context = StorageContextStub()
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.success((context: context, items: [testDtoContribution])))
            }
        }
        let mapper = MockMapper<(StorageContext, NewContributionNote),
                                Result<CDContributionNote, Error>>()
        stub(mapper) { stub in
            when(stub).map(input: any())
                .thenReturn(.success(testDtoNote))
        }
        let dtoMapper = MockMapper<(CDContribution, CDContributionNote), CDContribution>()
        stub(dtoMapper) { stub in
            when(stub).map(input: any())
                .thenReturn(testDtoContribution)
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       contributionMapper: AnyMapper(wrapped: MockMapper()),
                                                       dtoContributionMapper: AnyMapper(wrapped: MockMapper()),
                                                       dtoContributionUpdateMapper: AnyMapper(wrapped: dtoMapper),
                                                       contributionNoteMapper: AnyMapper(wrapped: mapper))
        
        // Act
        try awaitPublisher(repository.write(note: testNote))
        
        // Assert
        let mapperArguments = ArgumentCaptor<(StorageContext, NewContributionNote)>()
        verify(mapper).map(input: mapperArguments.capture())
        XCTAssertEqual(mapperArguments.value?.1, testNote)
        let dtoMapperArguments = ArgumentCaptor<(CDContribution, CDContributionNote)>()
        verify(dtoMapper).map(input: dtoMapperArguments.capture())
        XCTAssertTrue(dtoMapperArguments.value! == (testDtoContribution, testDtoNote))
    }
    
    func testWriteSecondNoteMapperError() throws {
        // Arrange
        let testNote = NewContributionNote(day: 10, note: "Test")
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.success((context: StorageContextStub(), items: [CDContribution()])))
            }
        }
        let mapper = MockMapper<(StorageContext, NewContributionNote),
                                Result<CDContributionNote, Error>>()
        stub(mapper) { stub in
            when(stub).map(input: any())
                .thenReturn(.failure(TestError.someError))
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       contributionMapper: AnyMapper(wrapped: MockMapper()),
                                                       dtoContributionMapper: AnyMapper(wrapped: MockMapper()),
                                                       dtoContributionUpdateMapper: AnyMapper(wrapped: MockMapper()),
                                                       contributionNoteMapper: AnyMapper(wrapped: mapper))
        
        // Act
        let result = try awaitError(repository.write(note: testNote))
        
        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
    
    func testWriteError() throws {
        // Arrange
        let testNote = NewContributionNote(day: 10, note: "Test")
        let storage = MockStorage()
        stub(storage) { stub in
            when(stub).fetch(predicate: any(), any(), onCompletion: any()).then { args in
                args.2(StorageResult.failure(TestError.someError))
            }
        }
        let repository = DefaultContributionRepository(storage: storage,
                                                       contributionMapper: AnyMapper(wrapped: MockMapper()),
                                                       dtoContributionMapper: AnyMapper(wrapped: CDContributionMapper()),
                                                       dtoContributionUpdateMapper: AnyMapper(wrapped: MockMapper()),
                                                       contributionNoteMapper: AnyMapper(wrapped: CDContributionNoteMapper()))

        // Act
        let result = try awaitError(repository.write(note: testNote))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
}
