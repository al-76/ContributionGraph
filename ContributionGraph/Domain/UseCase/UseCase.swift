//
//  UseCase.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 05.08.2022.
//

import Combine

protocol UseCase {
    associatedtype Input
    associatedtype Output

    func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error>
}

final class AnyUseCase<Input, Output>: UseCase {
    private let callAsFunction: (_ input: Input) -> AnyPublisher<Output, Error>

    init<TypeUseCase: UseCase>(wrapped: TypeUseCase)
        where TypeUseCase.Input == Input, TypeUseCase.Output == Output {
        callAsFunction = wrapped.callAsFunction
    }
    
    func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error> {
        callAsFunction(input)
    }
}

extension AnyUseCase where Input == Void {
    func callAsFunction(_ input: Input = ()) -> AnyPublisher<Output, Error> {
        callAsFunction(input)
    }
}
