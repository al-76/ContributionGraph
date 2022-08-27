// MARK: - Mocks generated from file: ContributionGraph/Data/Mapper/Mapper.swift at 2022-08-27 21:41:43 +0000

//
//  Mapper.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 17.08.2022.
//

import Cuckoo
@testable import ContributionGraph

import Foundation






 class MockMapper<Input, Output>: Mapper, Cuckoo.ProtocolMock {
    
     typealias MocksType = DefaultImplCaller<Input, Output>
    
     typealias Stubbing = __StubbingProxy_Mapper
     typealias Verification = __VerificationProxy_Mapper

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
     class DefaultImplCaller<Input, Output>: Mapper {
        private let reference: Any
    
        
        
        init<_CUCKOO$$GENERIC: Mapper>(from defaultImpl: UnsafeMutablePointer<_CUCKOO$$GENERIC>, keeping reference: @escaping @autoclosure () -> Any?) where _CUCKOO$$GENERIC.Input == Input, _CUCKOO$$GENERIC.Output == Output {
            self.reference = reference
    
            
            _storage$1$map = defaultImpl.pointee.map
            
        }
        
        
    
        
        private let _storage$1$map: (Input) -> Output
         func map(input: Input) -> Output {
            return _storage$1$map(input)
        }
        
    }

    private var __defaultImplStub: DefaultImplCaller<Input, Output>?

     func enableDefaultImplementation<_CUCKOO$$GENERIC: Mapper>(_ stub: _CUCKOO$$GENERIC) where _CUCKOO$$GENERIC.Input == Input, _CUCKOO$$GENERIC.Output == Output {
        var mutableStub = stub
        __defaultImplStub = DefaultImplCaller(from: &mutableStub, keeping: mutableStub)
        cuckoo_manager.enableDefaultStubImplementation()
    }

     func enableDefaultImplementation<_CUCKOO$$GENERIC: Mapper>(mutating stub: UnsafeMutablePointer<_CUCKOO$$GENERIC>) where _CUCKOO$$GENERIC.Input == Input, _CUCKOO$$GENERIC.Output == Output {
        __defaultImplStub = DefaultImplCaller(from: stub, keeping: nil)
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func map(input: Input) -> Output {
        
    return cuckoo_manager.call(
    """
    map(input: Input) -> Output
    """,
            parameters: (input),
            escapingParameters: (input),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.map(input: input))
        
    }
    
    

     struct __StubbingProxy_Mapper: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func map<M1: Cuckoo.Matchable>(input: M1) -> Cuckoo.ProtocolStubFunction<(Input), Output> where M1.MatchedType == Input {
            let matchers: [Cuckoo.ParameterMatcher<(Input)>] = [wrap(matchable: input) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockMapper.self, method:
    """
    map(input: Input) -> Output
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_Mapper: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func map<M1: Cuckoo.Matchable>(input: M1) -> Cuckoo.__DoNotUse<(Input), Output> where M1.MatchedType == Input {
            let matchers: [Cuckoo.ParameterMatcher<(Input)>] = [wrap(matchable: input) { $0 }]
            return cuckoo_manager.verify(
    """
    map(input: Input) -> Output
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class MapperStub<Input, Output>: Mapper {
    

    

    
    
    
    
     func map(input: Input) -> Output  {
        return DefaultValueRegistry.defaultValue(for: (Output).self)
    }
    
    
}





// MARK: - Mocks generated from file: ContributionGraph/Data/Platform/Storage.swift at 2022-08-27 21:41:43 +0000

//
//  Storage.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 16.08.2022.
//

import Cuckoo
@testable import ContributionGraph

import Combine
import CoreData
import Foundation






 class MockStorageContext: StorageContext, Cuckoo.ProtocolMock {
    
     typealias MocksType = StorageContext
    
     typealias Stubbing = __StubbingProxy_StorageContext
     typealias Verification = __VerificationProxy_StorageContext

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: StorageContext?

     func enableDefaultImplementation(_ stub: StorageContext) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func newData<T: NSManagedObject>(_ type: T.Type) throws -> T {
        
    return try cuckoo_manager.callThrows(
    """
    newData(_: T.Type) throws -> T
    """,
            parameters: (type),
            escapingParameters: (type),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.newData(type))
        
    }
    
    
    
    
    
     func save() throws {
        
    return try cuckoo_manager.callThrows(
    """
    save() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.save())
        
    }
    
    
    
    
    
     func delete<T: NSManagedObject>(object: T) throws {
        
    return try cuckoo_manager.callThrows(
    """
    delete(object: T) throws
    """,
            parameters: (object),
            escapingParameters: (object),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.delete(object: object))
        
    }
    
    

     struct __StubbingProxy_StorageContext: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func newData<M1: Cuckoo.Matchable, T: NSManagedObject>(_ type: M1) -> Cuckoo.ProtocolStubThrowingFunction<(T.Type), T> where M1.MatchedType == T.Type {
            let matchers: [Cuckoo.ParameterMatcher<(T.Type)>] = [wrap(matchable: type) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStorageContext.self, method:
    """
    newData(_: T.Type) throws -> T
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func save() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockStorageContext.self, method:
    """
    save() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func delete<M1: Cuckoo.Matchable, T: NSManagedObject>(object: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: object) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStorageContext.self, method:
    """
    delete(object: T) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_StorageContext: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func newData<M1: Cuckoo.Matchable, T: NSManagedObject>(_ type: M1) -> Cuckoo.__DoNotUse<(T.Type), T> where M1.MatchedType == T.Type {
            let matchers: [Cuckoo.ParameterMatcher<(T.Type)>] = [wrap(matchable: type) { $0 }]
            return cuckoo_manager.verify(
    """
    newData(_: T.Type) throws -> T
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func save() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    save() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable, T: NSManagedObject>(object: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: object) { $0 }]
            return cuckoo_manager.verify(
    """
    delete(object: T) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class StorageContextStub: StorageContext {
    

    

    
    
    
    
     func newData<T: NSManagedObject>(_ type: T.Type) throws -> T  {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
    
    
    
    
     func save() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func delete<T: NSManagedObject>(object: T) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}










 class MockStorage: Storage, Cuckoo.ProtocolMock {
    
     typealias MocksType = Storage
    
     typealias Stubbing = __StubbingProxy_Storage
     typealias Verification = __VerificationProxy_Storage

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: Storage?

     func enableDefaultImplementation(_ stub: Storage) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func fetch<T: NSManagedObject>(predicate: NSPredicate?, _ Type: T.Type, onCompletion: @escaping OnCompletion<T>)  {
        
    return cuckoo_manager.call(
    """
    fetch(predicate: NSPredicate?, _: T.Type, onCompletion: @escaping OnCompletion<T>)
    """,
            parameters: (predicate, Type, onCompletion),
            escapingParameters: (predicate, Type, onCompletion),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetch(predicate: predicate, Type, onCompletion: onCompletion))
        
    }
    
    

     struct __StubbingProxy_Storage: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fetch<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, T: NSManagedObject>(predicate: M1, _ Type: M2, onCompletion: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(NSPredicate?, T.Type, OnCompletion<T>)> where M1.OptionalMatchedType == NSPredicate, M2.MatchedType == T.Type, M3.MatchedType == OnCompletion<T> {
            let matchers: [Cuckoo.ParameterMatcher<(NSPredicate?, T.Type, OnCompletion<T>)>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: Type) { $0.1 }, wrap(matchable: onCompletion) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStorage.self, method:
    """
    fetch(predicate: NSPredicate?, _: T.Type, onCompletion: @escaping OnCompletion<T>)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_Storage: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fetch<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, T: NSManagedObject>(predicate: M1, _ Type: M2, onCompletion: M3) -> Cuckoo.__DoNotUse<(NSPredicate?, T.Type, OnCompletion<T>), Void> where M1.OptionalMatchedType == NSPredicate, M2.MatchedType == T.Type, M3.MatchedType == OnCompletion<T> {
            let matchers: [Cuckoo.ParameterMatcher<(NSPredicate?, T.Type, OnCompletion<T>)>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: Type) { $0.1 }, wrap(matchable: onCompletion) { $0.2 }]
            return cuckoo_manager.verify(
    """
    fetch(predicate: NSPredicate?, _: T.Type, onCompletion: @escaping OnCompletion<T>)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class StorageStub: Storage {
    

    

    
    
    
    
     func fetch<T: NSManagedObject>(predicate: NSPredicate?, _ Type: T.Type, onCompletion: @escaping OnCompletion<T>)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: ContributionGraph/Domain/Data/ContributionRepository.swift at 2022-08-27 21:41:43 +0000

//
//  ContributionRepository.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 04.08.2022.
//

import Cuckoo
@testable import ContributionGraph

import Combine






 class MockContributionRepository: ContributionRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = ContributionRepository
    
     typealias Stubbing = __StubbingProxy_ContributionRepository
     typealias Verification = __VerificationProxy_ContributionRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ContributionRepository?

     func enableDefaultImplementation(_ stub: ContributionRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func read() -> AnyPublisher<[Contribution], Error> {
        
    return cuckoo_manager.call(
    """
    read() -> AnyPublisher<[Contribution], Error>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.read())
        
    }
    
    
    
    
    
     func write(note: NewContributionNote) -> AnyPublisher<Void, Error> {
        
    return cuckoo_manager.call(
    """
    write(note: NewContributionNote) -> AnyPublisher<Void, Error>
    """,
            parameters: (note),
            escapingParameters: (note),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.write(note: note))
        
    }
    
    

     struct __StubbingProxy_ContributionRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func read() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<[Contribution], Error>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockContributionRepository.self, method:
    """
    read() -> AnyPublisher<[Contribution], Error>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func write<M1: Cuckoo.Matchable>(note: M1) -> Cuckoo.ProtocolStubFunction<(NewContributionNote), AnyPublisher<Void, Error>> where M1.MatchedType == NewContributionNote {
            let matchers: [Cuckoo.ParameterMatcher<(NewContributionNote)>] = [wrap(matchable: note) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockContributionRepository.self, method:
    """
    write(note: NewContributionNote) -> AnyPublisher<Void, Error>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ContributionRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func read() -> Cuckoo.__DoNotUse<(), AnyPublisher<[Contribution], Error>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    read() -> AnyPublisher<[Contribution], Error>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func write<M1: Cuckoo.Matchable>(note: M1) -> Cuckoo.__DoNotUse<(NewContributionNote), AnyPublisher<Void, Error>> where M1.MatchedType == NewContributionNote {
            let matchers: [Cuckoo.ParameterMatcher<(NewContributionNote)>] = [wrap(matchable: note) { $0 }]
            return cuckoo_manager.verify(
    """
    write(note: NewContributionNote) -> AnyPublisher<Void, Error>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ContributionRepositoryStub: ContributionRepository {
    

    

    
    
    
    
     func read() -> AnyPublisher<[Contribution], Error>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<[Contribution], Error>).self)
    }
    
    
    
    
    
     func write(note: NewContributionNote) -> AnyPublisher<Void, Error>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, Error>).self)
    }
    
    
}





// MARK: - Mocks generated from file: ContributionGraph/Domain/UseCase/UseCase.swift at 2022-08-27 21:41:43 +0000

//
//  UseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Cuckoo
@testable import ContributionGraph

import Combine






 class MockUseCase<Input, Output>: UseCase, Cuckoo.ProtocolMock {
    
     typealias MocksType = DefaultImplCaller<Input, Output>
    
     typealias Stubbing = __StubbingProxy_UseCase
     typealias Verification = __VerificationProxy_UseCase

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
     class DefaultImplCaller<Input, Output>: UseCase {
        private let reference: Any
    
        
        
        init<_CUCKOO$$GENERIC: UseCase>(from defaultImpl: UnsafeMutablePointer<_CUCKOO$$GENERIC>, keeping reference: @escaping @autoclosure () -> Any?) where _CUCKOO$$GENERIC.Input == Input, _CUCKOO$$GENERIC.Output == Output {
            self.reference = reference
    
            
            _storage$1$callAsFunction = defaultImpl.pointee.callAsFunction
            
        }
        
        
    
        
        private let _storage$1$callAsFunction: (Input) -> AnyPublisher<Output, Error>
         func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error> {
            return _storage$1$callAsFunction(input)
        }
        
    }

    private var __defaultImplStub: DefaultImplCaller<Input, Output>?

     func enableDefaultImplementation<_CUCKOO$$GENERIC: UseCase>(_ stub: _CUCKOO$$GENERIC) where _CUCKOO$$GENERIC.Input == Input, _CUCKOO$$GENERIC.Output == Output {
        var mutableStub = stub
        __defaultImplStub = DefaultImplCaller(from: &mutableStub, keeping: mutableStub)
        cuckoo_manager.enableDefaultStubImplementation()
    }

     func enableDefaultImplementation<_CUCKOO$$GENERIC: UseCase>(mutating stub: UnsafeMutablePointer<_CUCKOO$$GENERIC>) where _CUCKOO$$GENERIC.Input == Input, _CUCKOO$$GENERIC.Output == Output {
        __defaultImplStub = DefaultImplCaller(from: stub, keeping: nil)
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error> {
        
    return cuckoo_manager.call(
    """
    callAsFunction(_: Input) -> AnyPublisher<Output, Error>
    """,
            parameters: (input),
            escapingParameters: (input),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.callAsFunction(input))
        
    }
    
    

     struct __StubbingProxy_UseCase: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func callAsFunction<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.ProtocolStubFunction<(Input), AnyPublisher<Output, Error>> where M1.MatchedType == Input {
            let matchers: [Cuckoo.ParameterMatcher<(Input)>] = [wrap(matchable: input) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockUseCase.self, method:
    """
    callAsFunction(_: Input) -> AnyPublisher<Output, Error>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_UseCase: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func callAsFunction<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.__DoNotUse<(Input), AnyPublisher<Output, Error>> where M1.MatchedType == Input {
            let matchers: [Cuckoo.ParameterMatcher<(Input)>] = [wrap(matchable: input) { $0 }]
            return cuckoo_manager.verify(
    """
    callAsFunction(_: Input) -> AnyPublisher<Output, Error>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class UseCaseStub<Input, Output>: UseCase {
    

    

    
    
    
    
     func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Output, Error>).self)
    }
    
    
}




