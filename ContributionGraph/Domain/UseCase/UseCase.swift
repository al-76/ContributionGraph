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

    func execute(with input: Input) -> AnyPublisher<Output, Error>
}

final class AnyUseCase<Input, Output>: UseCase {
    private let executeObject: (_ input: Input) -> AnyPublisher<Output, Error>

    init<TypeUseCase: UseCase>(wrapped: TypeUseCase)
        where TypeUseCase.Input == Input, TypeUseCase.Output == Output {
        executeObject = wrapped.execute
    }

    func execute(with input: Input) -> AnyPublisher<Output, Error> {
        executeObject(input)
    }
}
