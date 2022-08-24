// MARK: - Mocks generated from file: ContributionGraph/Domain/UseCase/UseCase.swift at 2022-08-24 14:59:38 +0000

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




