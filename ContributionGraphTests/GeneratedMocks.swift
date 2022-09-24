@testable import ContributionGraph///
/// @Generated by Mockolo
///



import Combine
import CoreData
import Foundation


class ContributionMapperMock: ContributionMapper {
    init() { }


    private(set) var mapCallCount = 0
    var mapHandler: ((CDContribution) -> (Contribution))?
    func map(input: CDContribution) -> Contribution {
        mapCallCount += 1
        if let mapHandler = mapHandler {
            return mapHandler(input)
        }
        fatalError("mapHandler returns can't have a default value thus its handler must be set")
    }
}

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

class DtoContributionNoteMapperMock: DtoContributionNoteMapper {
    init() { }

     typealias Input = (Date,
                       ContributionNote,
                       CDContribution?,
                       StorageContext)

    private(set) var mapCallCount = 0
    var mapArgValues = [Input]()
    var mapHandler: ((Input) -> (Result<CDContributionNote, Error>))?
    func map(input: Input) -> Result<CDContributionNote, Error> {
        mapCallCount += 1
        mapArgValues.append(input)
        if let mapHandler = mapHandler {
            return mapHandler(input)
        }
        fatalError("mapHandler returns can't have a default value thus its handler must be set")
    }
}

class ContributionDetailsMapperMock: ContributionDetailsMapper {
    init() { }


    private(set) var mapCallCount = 0
    var mapHandler: ((CDContribution) -> (ContributionDetails?))?
    func map(input: CDContribution) -> ContributionDetails? {
        mapCallCount += 1
        if let mapHandler = mapHandler {
            return mapHandler(input)
        }
        return nil
    }
}

class ContributionMetricsMapperMock: ContributionMetricsMapper {
    init() { }

     typealias Input = (Int, [CDContribution])

    private(set) var mapCallCount = 0
    var mapHandler: ((Input) -> (ContributionMetrics))?
    func map(input: Input) -> ContributionMetrics {
        mapCallCount += 1
        if let mapHandler = mapHandler {
            return mapHandler(input)
        }
        fatalError("mapHandler returns can't have a default value thus its handler must be set")
    }
}

class GetContributionSettingsUseCaseMock: GetContributionSettingsUseCase {
    init() { }


    private(set) var callAsFunctionCallCount = 0
    var callAsFunctionHandler: (() -> (AnyPublisher<ContributionSettings, Error>))?
    func callAsFunction() -> AnyPublisher<ContributionSettings, Error> {
        callAsFunctionCallCount += 1
        if let callAsFunctionHandler = callAsFunctionHandler {
            return callAsFunctionHandler()
        }
        fatalError("callAsFunctionHandler returns can't have a default value thus its handler must be set")
    }
}

class SetContributionSettingsUseCaseMock: SetContributionSettingsUseCase {
    init() { }


    private(set) var callAsFunctionCallCount = 0
    var callAsFunctionHandler: ((ContributionSettings) -> (AnyPublisher<ContributionSettings, Error>))?
    func callAsFunction(_ input: ContributionSettings) -> AnyPublisher<ContributionSettings, Error> {
        callAsFunctionCallCount += 1
        if let callAsFunctionHandler = callAsFunctionHandler {
            return callAsFunctionHandler(input)
        }
        fatalError("callAsFunctionHandler returns can't have a default value thus its handler must be set")
    }
}

class DeleteNoteUseCaseMock: DeleteNoteUseCase {
    init() { }


    private(set) var callAsFunctionCallCount = 0
    var callAsFunctionArgValues = [(ContributionNote, Contribution)]()
    var callAsFunctionHandler: (((ContributionNote, Contribution)) -> (AnyPublisher<Void, Error>))?
    func callAsFunction(_ input: (ContributionNote, Contribution)) -> AnyPublisher<Void, Error> {
        callAsFunctionCallCount += 1
        callAsFunctionArgValues.append(input)
        if let callAsFunctionHandler = callAsFunctionHandler {
            return callAsFunctionHandler(input)
        }
        fatalError("callAsFunctionHandler returns can't have a default value thus its handler must be set")
    }
}

class UpdateNoteUseCaseMock: UpdateNoteUseCase {
    init() { }


    private(set) var callAsFunctionCallCount = 0
    var callAsFunctionHandler: (((Date, ContributionNote)) -> (AnyPublisher<Void, Error>))?
    func callAsFunction(_ input: (Date, ContributionNote)) -> AnyPublisher<Void, Error> {
        callAsFunctionCallCount += 1
        if let callAsFunctionHandler = callAsFunctionHandler {
            return callAsFunctionHandler(input)
        }
        fatalError("callAsFunctionHandler returns can't have a default value thus its handler must be set")
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

class DtoContributionMapperMock: DtoContributionMapper {
    init() { }

     typealias Input = (CDContribution,
                       Contribution)

    private(set) var mapCallCount = 0
    var mapArgValues = [Input]()
    var mapHandler: ((Input) -> (CDContribution))?
    func map(input: Input) -> CDContribution {
        mapCallCount += 1
        mapArgValues.append(input)
        if let mapHandler = mapHandler {
            return mapHandler(input)
        }
        fatalError("mapHandler returns can't have a default value thus its handler must be set")
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

