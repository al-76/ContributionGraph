@testable import ContributionGraph///
/// @Generated by Mockolo
///



import Combine
import CoreData
import Foundation


class ContributionRepositoryMock: ContributionRepository {
    init() { }


    private(set) var readCallCount = 0
    var readHandler: (() -> (AnyPublisher<[Contribution], Error>))?
    func read() -> AnyPublisher<[Contribution], Error> {
        readCallCount += 1
        if let readHandler = readHandler {
            return readHandler()
        }
        fatalError("readHandler returns can't have a default value thus its handler must be set")
    }
}

class ContributionSettingsRepositoryMock: ContributionSettingsRepository {
    init() { }


    private(set) var readCallCount = 0
    var readHandler: (() -> (AnyPublisher<ContributionSettings, Error>))?
    func read() -> AnyPublisher<ContributionSettings, Error> {
        readCallCount += 1
        if let readHandler = readHandler {
            return readHandler()
        }
        fatalError("readHandler returns can't have a default value thus its handler must be set")
    }

    private(set) var writeCallCount = 0
    var writeHandler: ((ContributionSettings) -> (AnyPublisher<Void, Error>))?
    func write(settings: ContributionSettings) -> AnyPublisher<Void, Error> {
        writeCallCount += 1
        if let writeHandler = writeHandler {
            return writeHandler(settings)
        }
        fatalError("writeHandler returns can't have a default value thus its handler must be set")
    }
}

class StorageContextMock: StorageContext {
    init() { }


    private(set) var newDataCallCount = 0
    var newDataHandler: ((Any) throws -> (Any))?
    func newData<T: NSManagedObject>(_ type: T.Type) throws -> T {
        newDataCallCount += 1
        if let newDataHandler = newDataHandler {
            return try newDataHandler(type) as! T
        }
        fatalError("newDataHandler returns can't have a default value thus its handler must be set")
    }

    private(set) var saveCallCount = 0
    var saveHandler: (() throws -> ())?
    func save() throws  {
        saveCallCount += 1
        if let saveHandler = saveHandler {
            try saveHandler()
        }
        
    }

    private(set) var deleteCallCount = 0
    var deleteArgValues = [Any]()
    var deleteHandler: ((Any) throws -> ())?
    func delete<T: NSManagedObject>(object: T) throws  {
        deleteCallCount += 1
        deleteArgValues.append(object)
        if let deleteHandler = deleteHandler {
            try deleteHandler(object)
        }
        
    }
}

class ContributionDetailsRepositoryMock: ContributionDetailsRepository {
    init() { }


    private(set) var readCallCount = 0
    var readArgValues = [Date]()
    var readHandler: ((Date) -> (AnyPublisher<ContributionDetails?, Error>))?
    func read(date: Date) -> AnyPublisher<ContributionDetails?, Error> {
        readCallCount += 1
        readArgValues.append(date)
        if let readHandler = readHandler {
            return readHandler(date)
        }
        fatalError("readHandler returns can't have a default value thus its handler must be set")
    }

    private(set) var writeCallCount = 0
    var writeArgValues = [(ContributionNote, Date)]()
    var writeHandler: ((ContributionNote, Date) -> (AnyPublisher<Void, Error>))?
    func write(_ note: ContributionNote, at date: Date) -> AnyPublisher<Void, Error> {
        writeCallCount += 1
        writeArgValues.append((note, date))
        if let writeHandler = writeHandler {
            return writeHandler(note, date)
        }
        fatalError("writeHandler returns can't have a default value thus its handler must be set")
    }

    private(set) var deleteCallCount = 0
    var deleteArgValues = [(ContributionNote, Contribution)]()
    var deleteHandler: ((ContributionNote, Contribution) -> (AnyPublisher<Void, Error>))?
    func delete(_ note: ContributionNote, to contribution: Contribution) -> AnyPublisher<Void, Error> {
        deleteCallCount += 1
        deleteArgValues.append((note, contribution))
        if let deleteHandler = deleteHandler {
            return deleteHandler(note, contribution)
        }
        fatalError("deleteHandler returns can't have a default value thus its handler must be set")
    }
}

class ContributionMetricsRepositoryMock: ContributionMetricsRepository {
    init() { }


    private(set) var readCallCount = 0
    var readHandler: (() -> (AnyPublisher<ContributionMetrics, Error>))?
    func read() -> AnyPublisher<ContributionMetrics, Error> {
        readCallCount += 1
        if let readHandler = readHandler {
            return readHandler()
        }
        fatalError("readHandler returns can't have a default value thus its handler must be set")
    }
}

class StorageMock: Storage {
    init() { }

     typealias OnFetchCompletion<T> = (Result<(context: StorageContext, items: [T]), Error>) -> Void
     typealias OnCountCompletion = (Result<Int, Error>) -> Void

    private(set) var fetchCallCount = 0
    var fetchHandler: ((NSPredicate?, Any, Any) -> ())?
    func fetch<T: NSManagedObject>(predicate: NSPredicate?, _ type: T.Type, onCompletion: @escaping OnFetchCompletion<T>)  {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            fetchHandler(predicate, type, onCompletion)
        }
        
    }

    private(set) var countCallCount = 0
    var countHandler: ((NSPredicate?, Any, @escaping OnCountCompletion) -> ())?
    func count<T: NSManagedObject>(predicate: NSPredicate?, _ type: T.Type, onCompletion: @escaping OnCountCompletion)  {
        countCallCount += 1
        if let countHandler = countHandler {
            countHandler(predicate, type, onCompletion)
        }
        
    }
}

