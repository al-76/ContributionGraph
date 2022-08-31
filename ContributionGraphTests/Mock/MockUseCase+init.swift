//
//  MockUseCase+init.swift
//  ContributionGraphTests
//
//  Created by Vyacheslav Konopkin on 24.08.2022.
//

import Combine
import Cuckoo

@testable import ContributionGraph

extension MockUseCase {
    convenience init(_ publisher: AnyPublisher<Output, Error>) {
        self.init()

        stub(self) { stub in
            stub.callAsFunction(any()).thenReturn(publisher)
        }
    }
}

func MockAnyUseCase<Input, Output>() -> AnyUseCase<Input, Output> {
    AnyUseCase(wrapped: MockUseCase())
}

func MockAnyUseCase<Input, Output>(_ publisher: AnyPublisher<Output, Error>) -> AnyUseCase<Input, Output> {
    AnyUseCase(wrapped: MockUseCase(publisher))
}
